//
//  GKRealStuffCell.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffCell.h"
#import "UIColor+GKColors.h"

@interface GKRealStuffCell ()

@property (nonatomic, strong) UIView *markView;

@end

@implementation GKRealStuffCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureLayout];
    }
    return self;
}

- (void)configureLayout {
    [self.contentView insertSubview:self.markView atIndex:0];
    
    [NSLayoutConstraint constraintWithItem:self.markView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30].active = YES;
    [NSLayoutConstraint constraintWithItem:self.markView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30].active = YES;
    [NSLayoutConstraint constraintWithItem:self.markView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.markView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
}

- (void)configreCellWithRealStuff:(RealStuff *)rs {
    UIColor *color = [UIColor colorWithRealStuffType:rs.type];
    
    self.realStuffTitleLabel.text = rs.desc;
    self.kindIndicatorView.backgroundColor = color;
    self.markView.hidden = !rs.isFavorite;
    
    NSLog(@"%@", rs.images);
}

- (UIView *)markView {
    if (!_markView) {
        _markView = [[UIView alloc] init];
        [_markView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        CAShapeLayer *markLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(30, 0)];
        [path addLineToPoint:CGPointMake(30, 30)];
        [path closePath];
        markLayer.path = path.CGPath;
        markLayer.fillColor = [UIColor orangeColor].CGColor;
        
        [_markView.layer addSublayer:markLayer];
    }
    
    return _markView;
}

@end
