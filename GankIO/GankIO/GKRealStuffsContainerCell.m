//
//  GKRealStuffsContainerCell.m
//  GankIO
//
//  Created by Josscii on 16/9/26.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffsContainerCell.h"
#import "GKRealStuffCell.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "GKRealStuffCell.h"
#import "GKRealStuffViewModel.h"
#import "GKDBManager.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffCell";

@interface GKRealStuffsContainerCell () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation GKRealStuffsContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    // tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-1) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GKRealStuffCell" bundle:nil] forCellReuseIdentifier:@"GKRealStuffCell"];
    self.tableView.estimatedRowHeight = 68;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    [self.contentView addSubview:self.tableView];
    
    // pullrefreshers
    self.pullHeader = [[GKPullRefresher alloc] initWithScrollView:self.tableView type:GKPullRefresherTypeHeader addRefreshBlock:^{
        [self.delegate loadPre];
    }];
    
    self.pullFooter = [[GKPullRefresher alloc] initWithScrollView:self.tableView type:GKPullRefresherTypeFooter addRefreshBlock:^{
        [self.delegate loadNext];
    }];
    
    // mark realstuff
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKDidUnMarkRealStuffNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         RealStuff *rs = notifi.userInfo[@"realstuff"];
         [self.realStuffs enumerateObjectsUsingBlock:^(RealStuff * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([rs.desc isEqualToString:obj.desc]) {
                 obj.isFavorite = 0;
                 [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                 *stop = YES;
             }
         }];
     }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GKHasReachedTheTop" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         [self.pullHeader stopLoading];
         [UIView animateWithDuration:0.5f animations:^{
             self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
         }];
     }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GKHasReachedTheBottom" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         [self.pullFooter stopLoading];
     }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.realStuffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    
    [cell configreCellWithRealStuff:self.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RealStuff *realStuff = self.realStuffs[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GKDidSelectRealStuffNotification object:nil userInfo:@{@"url": realStuff.url}];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    RealStuff *realStuff = self.realStuffs[indexPath.row];
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

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullHeader scrollViewDidScroll:scrollView];
    [self.pullFooter scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.pullHeader scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    [self.pullFooter scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)setRealStuffs:(NSArray *)realStuffs {
    _realStuffs = realStuffs;
    [self.tableView reloadData];
}

@end