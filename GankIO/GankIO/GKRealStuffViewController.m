//
//  GKRealStuffViewController.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffViewController.h"
#import "GKRealStuffCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GKRealStuffViewModel.h"
#import "GKAppConstants.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"
#import "GKDBManager.h"
#import "GKRealStuffsContainerCell.h"
#import "GKLoadingView.h"
#import "GKDatePicker.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffsContainerCell";

typedef void(^Block)(void);

@interface GKRealStuffViewController () <UITableViewDelegate, UITableViewDataSource, GKRealStuffProtocol>

@property (nonatomic, strong) GKRealStuffViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Block moveCellBlock;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) GKLoadingView *loadingView;

@end

@implementation GKRealStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureLayout];
    
    self.currentIndex = 0;
    self.viewModel = [[GKRealStuffViewModel alloc] init];
    
    RAC(self, navigationItem.title) = RACObserve(self.viewModel, title);
    
    @weakify(self)
    [[self.viewModel.requestRealStuffCommand.executionSignals switchToLatest] subscribeNext:^(NSArray *x) {
        @strongify(self)
        [self.loadingView stopLoading];
        self.moveCellBlock();
        self.moveCellBlock = ^{
            @strongify(self)
            [self.tableView reloadData];
        };;
    }];
    
    [self.viewModel.requestRealStuffCommand.executing subscribeNext:^(NSNumber *x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = x.boolValue;
    }];
    
    self.moveCellBlock = ^{
        @strongify(self)
        [self.tableView reloadData];
    };
    
    // notification
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKDidSelectRealStuffNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         NSString *url = notifi.userInfo[@"url"];
         KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
         webBrowser.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:webBrowser animated:YES];
         [webBrowser loadURLString:url];
     }];
    
    [self.viewModel loadHistory];
}

- (IBAction)test:(id)sender {
    GKDatePicker *picker = [[GKDatePicker alloc] initWithSelectBlock:^(NSString *selectedHistory) {
        // did select
        NSInteger pickedIndex = [self.viewModel.history indexOfObject:selectedHistory];
        self.currentIndex = 0;
        [self.loadingView startLoading];
        self.viewModel.loadState = GKLoadStateRandom;
        [self.viewModel loadRealStuffAtOneDay:pickedIndex];
    }];
    
    picker.historys = self.viewModel.history;
    [self.view addSubview:picker];
    [picker showAnimation];
}

- (void)configureLayout {
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // tableview
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = SCREEN_HEIGHT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GKRealStuffsContainerCell class] forCellReuseIdentifier:cellReuseIndentifier];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    // loading view
    self.loadingView = [[GKLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.loadingView];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.currentIndex = 0;
        [self.loadingView startLoading];
        [self.viewModel loadRandomRealStuff];
    }
}

#pragma mark - protocol

- (void)loadNext {
    [self.viewModel loadNextRealStuff];
    @weakify(self)
    self.moveCellBlock = ^{
        @strongify(self)
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:++self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    };
}

- (void)loadPre {
    [self.viewModel loadPreRealStuff];
    @weakify(self)
    self.moveCellBlock = ^{
        @strongify(self)
        if (self.currentIndex == 0) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:--self.currentIndex inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    };
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.realStuffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffsContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.realStuffs = self.viewModel.realStuffs[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffsContainerCell *rfcell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    [rfcell.pullHeader stopLoading];
    [rfcell.pullFooter stopLoading];
}
@end
