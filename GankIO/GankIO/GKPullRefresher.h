//
//  GKPullRefresher.h
//  GankIO
//
//  Created by Josscii on 16/9/11.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)(void);

typedef NS_ENUM(NSInteger, GKPullRefresherState) {
    GKPullRefresherStateInitial,
    GKPullRefresherStateReady,
    GKPullRefresherStateLoading
    
};

typedef NS_ENUM(NSInteger, GKPullRefresherType) {
    GKPullRefresherTypeHeader,
    GKPullRefresherTypeFooter
};

@interface GKPullRefresher : UIView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                              type:(GKPullRefresherType)type
                   addRefreshBlock:(RefreshBlock)refreshBlock;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)stopLoading;

@end
