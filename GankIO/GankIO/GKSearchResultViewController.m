//
//  GKSearchResultViewController.m
//  GankIO
//
//  Created by Josscii on 16/9/7.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKSearchResultViewController.h"
#import "GKSearchViewModel.h"
#import "GKRealStuffCell.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"
#import "GKAppConstants.h"
#import "GKPullHeaderView.h"
#import "GKPullRefresher.h"

#define MAX_PULL_HEIGHT 60.0f

@interface GKSearchResultViewController () <UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) GKSearchViewModel *viewModel;
@property (nonatomic, strong) GKPullRefresher *pullFooter;

@end

@implementation GKSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[GKSearchViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.searchRealStuffsCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.pullFooter stopLoading];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.searchRealStuffsCommand.executing subscribeNext:^(NSNumber *x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = x.boolValue;
    }];
    
    [self configureLayout];
}

- (void)configureLayout {
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    // pull footer
    self.pullFooter = [[GKPullRefresher alloc] initWithScrollView:self.tableView type:GKPullRefresherTypeFooter addRefreshBlock:^{
        self.viewModel.currentPage += 1;
        [self.viewModel.searchRealStuffsCommand execute:nil];
    }];
}

#pragma mark - scoll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullFooter scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.pullFooter scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.realStuffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GKRealStuffCell" forIndexPath:indexPath];
    
    [cell configreCellWithRealStuff:self.viewModel.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RealStuff *realStuff = self.viewModel.realStuffs[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GKDidSelectRealStuffNotification object:nil userInfo:@{@"url": realStuff.url}];
}

#pragma mark - search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // do nothing
    if ([searchController.searchBar.text isEqualToString:@""]) {
        self.viewModel.realStuffs = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.searchKey = searchBar.text;
    self.viewModel.category = @"all";
    [self.viewModel.searchRealStuffsCommand execute:nil];
}

@end
