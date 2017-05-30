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
#import "GKDBManager.h"

NSString * const cellReuseIndentifier = @"GKRealStuffCell";

NSString * const newCellReuseIdentifier = @"newCellReuseIdentifier";

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
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.contentView addSubview:self.tableView];
    
    /// -----
    [self.tableView registerClass:[GKNewGankRealStuffCell class] forCellReuseIdentifier:newCellReuseIdentifier];
    /// -----
    
    // pull refreshers
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
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKHasReachedTheTopNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.pullHeader stopLoading];
         });
     }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKHasReachedTheBottomNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.pullFooter stopLoading];
         });
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
    //GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    
    ///-----------
    GKNewGankRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:newCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    ///-----------
    
    [cell configureCellWithRealStuff:self.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RealStuff *realStuff = self.realStuffs[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GKDidSelectRealStuffNotification object:nil userInfo:@{@"url": realStuff.url}];
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

#pragma mark - GKNewGankRealStuffCellDelegate

- (void)didSelectImageInCell:(UITableViewCell *)cell withImageView:(GKImageView *)imageView withIndex:(NSInteger)index {
    [imageView startLoadingWithProgress:0.4];
}

- (void)didPressFavoriteButton:(UIButton *)button inCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RealStuff *realStuff = self.realStuffs[indexPath.row];
    [[[GKDBManager defaultManager] markRealStuff:realStuff AsFavorite:!realStuff.isFavorite] subscribeNext:^(id x) {
        realStuff.isFavorite = !realStuff.isFavorite;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

@end
