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
#import "GKPullHeaderView.h"
#import "GKAppConstants.h"
#import "GKHistoryViewController.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffCell";

@interface GKRealStuffViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GKRealStuffViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *preBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

@property (nonatomic, strong) GKPullHeaderView *pullHeader;

@end

@implementation GKRealStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureLayout];
    
    self.viewModel = [[GKRealStuffViewModel alloc] init];
    
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    @weakify(self)
    [[self.viewModel.requestRealStuffCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestRealStuffCommand.executing subscribeNext:^(NSNumber *x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = x.boolValue;
    }];
    
    self.preBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.viewModel loadPreRealStuff];
        return [RACSignal empty];
    }];
    
    self.nextBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.viewModel loadNextRealStuff];
        return [RACSignal empty];
    }];
    
    [self.viewModel loadHistory];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPickAHistoryDay:) name:@"GKDidPickAHistoryDay" object:nil];
}

- (void)didPickAHistoryDay:(NSNotification *)notifi {
    NSNumber *pickedIndex = notifi.userInfo[@"pickedIndex"];
    [self.viewModel loadRealStuffAtOneDay:pickedIndex.integerValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"history"]) {
        UINavigationController *historyNav = (UINavigationController *)segue.destinationViewController;
        GKHistoryViewController *historyVC = (GKHistoryViewController *)historyNav.topViewController;
        historyVC.history = self.viewModel.history;
    }
}

- (void)configureLayout {
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.pullHeader = [[GKPullHeaderView alloc] init];
    [self.tableView insertSubview:self.pullHeader atIndex:0];
    [self.pullHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[NSLayoutConstraint constraintWithItem:self.pullHeader
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.tableView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    self.pullHeader.belowThresholdText = GKPullToLoadPre;
    self.pullHeader.overThresholdText = GKLoosenToLoadPre;
}

#pragma mark - scrollview delegate

// would it be great if replace these with rac_signalForSelector ?

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pullHeader.overThreshold = scrollView.contentOffset.y < -120;
    self.pullHeader.viewHeightConstraint.constant = MAX(-(scrollView.contentOffset.y + 64), 0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -120) {
        [self.viewModel loadRandomRealStuff];
    }
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.realStuffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    
    [cell configreCellWithRealStuff:self.viewModel.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RealStuff *realStuff = self.viewModel.realStuffs[indexPath.row];
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    [self.navigationController pushViewController:webBrowser animated:YES];
    [webBrowser loadURLString:realStuff.url];
}

@end
