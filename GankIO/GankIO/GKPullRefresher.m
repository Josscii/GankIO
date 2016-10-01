//
//  GKPullRefresher.m
//  GankIO
//
//  Created by Josscii on 16/9/11.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKPullRefresher.h"
#import "GKAppConstants.h"

#define MAX_TRIGGERH_HEIGHT 60.0
#define REFRESHER_HEIGHT 400.0

@interface GKPullRefresher ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, assign) CGFloat pullDistance;
@property (nonatomic, assign) GKPullRefresherType refreshType;
@property (nonatomic, assign) GKPullRefresherState refreshState;
@property (nonatomic, copy) RefreshBlock refreshBlock;

@end

@implementation GKPullRefresher

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                             type:(GKPullRefresherType)type
                   addRefreshBlock:(RefreshBlock)refreshBlock {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _refreshType = type;
        _refreshBlock = refreshBlock;
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    // self
    CGFloat y = self.refreshType == GKPullRefresherTypeHeader ? -REFRESHER_HEIGHT : self.scrollView.contentSize.height;
    self.frame = CGRectMake(0, y, SCREEN_WIDTH, REFRESHER_HEIGHT);
    [self.scrollView addSubview:self];
    self.layer.zPosition = -1;
    
    // descriptionLabel
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.descriptionLabel];
    
    [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    
    NSLayoutAttribute atti = self.refreshType == GKPullRefresherTypeHeader ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    CGFloat multiplier = self.refreshType == GKPullRefresherTypeHeader ? -1.0 : 1.0;
    
    [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:atti relatedBy:NSLayoutRelationEqual toItem:self attribute:atti multiplier:1 constant: multiplier * 20.0].active = YES;
}

- (void)startLoading {
    self.refreshState = GKPullRefresherStateLoading;
    self.refreshBlock();
}

- (void)stopLoading {
    self.refreshState = GKPullRefresherStateInitial;
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.refreshType == GKPullRefresherTypeHeader) {
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = 64;
            self.scrollView.contentInset = inset;
        } else {
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = 49;
            self.scrollView.contentInset = inset;
        }
    } completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.refreshType == GKPullRefresherTypeHeader) {
        self.pullDistance = -(scrollView.contentOffset.y + scrollView.contentInset.top);
    } else {
        self.pullDistance = scrollView.contentOffset.y - (scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height);
        CGRect rect = self.frame;
        rect.origin.y = scrollView.contentSize.height;
        self.frame = rect;
        
        // hide if content is not enough
        self.hidden = scrollView.contentSize.height < SCREEN_HEIGHT;
    }
    
    if (self.refreshState != GKPullRefresherStateLoading) {
        if (self.pullDistance > MAX_TRIGGERH_HEIGHT) {
            self.refreshState = GKPullRefresherStateReady;
        } else {
            self.refreshState = GKPullRefresherStateInitial;
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.pullDistance > MAX_TRIGGERH_HEIGHT && self.refreshState != GKPullRefresherStateLoading) {
        [self startLoading];
        if (self.refreshType == GKPullRefresherTypeHeader) {
            [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.top += MAX_TRIGGERH_HEIGHT;
                self.scrollView.contentInset = inset;
            } completion:nil];
            
            (*targetContentOffset).y = -scrollView.contentInset.top;
        } else {
            [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom += MAX_TRIGGERH_HEIGHT;
                self.scrollView.contentInset = inset;
            } completion:nil];
            
            (*targetContentOffset).y = scrollView.contentOffset.y;
        }
    }
}

- (void)setRefreshState:(GKPullRefresherState)refreshState {
    switch (refreshState) {
        case GKPullRefresherStateInitial:
            self.descriptionLabel.text = self.refreshType == GKPullRefresherTypeHeader ? @"下拉开始刷新" : @"上拉开始刷新";
            break;
        case GKPullRefresherStateReady:
            self.descriptionLabel.text = @"松开开始刷新";
            break;
        case GKPullRefresherStateLoading:
            self.descriptionLabel.text = @"正在刷新";
            break;
        default:
            break;
    }
    _refreshState = refreshState;
}

@end
