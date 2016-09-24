//
//  GKFeatureViewController.m
//  GankIO
//
//  Created by Josscii on 16/9/5.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKFeatureViewController.h"
#import "GKRealStuffCell.h"
#import "GKFeatureViewModel.h"
#import "GKDBManager.h"
#import "GKAppConstants.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"

@interface GKFeatureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GKFeatureViewModel *viewModel;

@end

@implementation GKFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[GKFeatureViewModel alloc] init];
    
    @weakify(self)
    [[self.viewModel.getFeaturedRealStuffsCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    [self.viewModel.getFeaturedRealStuffsCommand execute:nil];
}

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
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    webBrowser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webBrowser animated:YES];
    [webBrowser loadURLString:realStuff.url];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    RealStuff *realStuff = self.viewModel.realStuffs[indexPath.row];
    NSString *title = !realStuff.isFavorite ? @"收藏" : @"取消收藏";
    
    UITableViewRowAction *saveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @weakify(self)
        [[[GKDBManager defaultManager] markRealStuff:realStuff AsFavorite:!realStuff.isFavorite] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.realStuffs removeObject:realStuff];
            tableView.editing = NO;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[NSNotificationCenter defaultCenter] postNotificationName:GKDidUnMarkRealStuffNotification object:nil userInfo:@{@"realstuff": realStuff}];
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
