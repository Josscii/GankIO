//
//  GKLoadingView.m
//  GankIO
//
//  Created by Josscii on 16/9/6.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKLoadingView.h"
#import "GKAppConstants.h"

@interface GKLoadingView ()

@property (nonatomic, strong) UIVisualEffectView *visualView;
@property (nonatomic, strong) UIBlurEffect *blurEffect;

@end

@implementation GKLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureLayout];
    }
    return self;
}

- (void)configureLayout {
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.alpha = 0.0f;
        self.visualView.effect = self.blurEffect;
    }
    
    for (UIView* v in @[self.visualView, self.indicator]) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:v];
    }
    
    // visualView
    [NSLayoutConstraint constraintWithItem:self.visualView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.visualView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.visualView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.visualView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
    
    // indicator
    [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
}

// http://stackoverflow.com/questions/29307827/how-does-one-fade-a-uivisualeffectview-and-or-uiblureffect-in-and-out
// iOS 9 and below does not support so wrap a container and animate its alpha
#pragma mark - loaing

- (void)startLoading {
    self.hidden = NO;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [UIView animateWithDuration:0.25f animations:^{
            self.visualView.effect = self.blurEffect;
            [self.indicator startAnimating];
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 1.0f;
            [self.indicator startAnimating];
        }];
    }
}

- (void)stopLoading {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [UIView animateWithDuration:0.25f animations:^{
            self.visualView.effect = nil;
            [self.indicator stopAnimating];
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
            [self.indicator stopAnimating];
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

#pragma mark - getters and setters

- (UIVisualEffectView *)visualView {
    if (!_visualView) {
        _visualView = [[UIVisualEffectView alloc] init];
    }
    return _visualView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

- (UIBlurEffect *)blurEffect {
    if (!_blurEffect) {
        _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return _blurEffect;
}

@end
