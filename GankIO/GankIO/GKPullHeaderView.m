//
//  GKPullHeaderView.m
//  GankIO
//
//  Created by Josscii on 16/8/12.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKPullHeaderView.h"
#import "GKAppConstants.h"

@interface GKPullHeaderView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation GKPullHeaderView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self configureLayout];
    }
    
    return self;
}

- (void)configureLayout {
    self.container = [[UIView alloc] init];
    
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.container];
    
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.container addSubview:self.label];
    
    [[NSLayoutConstraint constraintWithItem:self.container
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.container
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.container
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.container
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.container
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:SCREEN_WIDTH] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.label
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.container
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.label
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.container
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    self.viewHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:0];
    [self.viewHeightConstraint setActive:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.hidden = self.viewHeightConstraint.constant == 0;
}

- (void)setOverThreshold:(BOOL)overThreshold {
    _label.text = overThreshold ? _overThresholdText : _belowThresholdText;
    _overThreshold = overThreshold;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }
    return _label;
}

@end
