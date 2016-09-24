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
#import "GKDBManager.h"
#import "GKLoadingView.h"
#import "GKPullRefresher.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffCell";

@interface GKRealStuffViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GKRealStuffViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *preBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

//@property (nonatomic, strong) GKPullHeaderView *pullHeader;
@property (nonatomic, strong) GKLoadingView *loadingView;

@property (nonatomic, strong) GKPullRefresher *pullHeader;

@end

@implementation GKRealStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureLayout];
    
    self.viewModel = [[GKRealStuffViewModel alloc] init];
    
    RAC(self, navigationItem.title) = RACObserve(self.viewModel, title);
    
    @weakify(self)
    [[self.viewModel.requestRealStuffCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestRealStuffCommand.executing subscribeNext:^(NSNumber *x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = x.boolValue;
        if (x.boolValue) {
            [self.loadingView startLoading];
        } else {
            [self.loadingView stopLoading];
            [self.pullHeader stopLoading];
        }
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
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKDidPickAHistoryDayNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         NSNumber *pickedIndex = notifi.userInfo[@"pickedIndex"];
         [self.viewModel loadRealStuffAtOneDay:pickedIndex.integerValue];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKDidUnMarkRealStuffNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         RealStuff *rs = notifi.userInfo[@"realstuff"];
         [self.viewModel.realStuffs enumerateObjectsUsingBlock:^(RealStuff * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([rs.desc isEqualToString:obj.desc]) {
                 obj.isFavorite = 0;
                 [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                 *stop = YES;
             }
         }];
    }];
    
    [self.viewModel loadHistory];
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
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    // pull header
    self.pullHeader = [[GKPullRefresher alloc] initWithScrollView:self.tableView type:GKPullRefresherTypeFooter addRefreshBlock:^{
        [self.viewModel loadRandomRealStuff];
    }];
    
    // loading view
    self.loadingView = [[GKLoadingView alloc] init];
    [self.loadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.loadingView];
    
    [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullHeader scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.pullHeader scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
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
    webBrowser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webBrowser animated:YES];
    [webBrowser loadURLString:realStuff.url];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    RealStuff *realStuff = self.viewModel.realStuffs[indexPath.row];
    NSString *title = !realStuff.isFavorite ? @"收藏" : @"取消收藏";
    
    UITableViewRowAction *saveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[[GKDBManager defaultManager] markRealStuff:realStuff AsFavorite:!realStuff.isFavorite] subscribeNext:^(id x) {
            realStuff.isFavorite = !realStuff.isFavorite;
            tableView.editing = NO;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    
    saveAction.backgroundColor = [UIColor brownColor];
    
    return @[saveAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // iOS 8
}
@end
