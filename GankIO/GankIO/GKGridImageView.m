//
//  GKGridImageView.m
//  NewGankHomeDemo
//
//  Created by Josscii on 16/10/10.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKGridImageView.h"
#import "Masonry/Masonry.h"

@interface GKGridImageView ()

@end

@implementation GKGridImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageViews = @[];
        self.mas_key = @"GKGridImageView";
    }
    return self;
}

- (void)initializeImagesWithCount:(NSInteger)count {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    switch (count) {
        case 1:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.width.mas_equalTo(SCREEN_WIDTH - 40.0f);
                make.height.mas_equalTo((SCREEN_WIDTH - 40.0f) / 1.7f).priorityHigh();
            }];
            
            _imageViews = [NSArray arrayWithObject:imageView1];
        }
            break;
        case 2:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 45.0f)/2.0f).priorityHigh();
            }];
            
            GKImageView *imageView2 = [[GKImageView alloc] init];
            imageView2.contentMode = UIViewContentModeTop;
            imageView2.clipsToBounds = YES;
            [self addSubview:imageView2];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.equalTo(self);
                make.left.equalTo(imageView1.mas_right).offset(5);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 45.0f)/2.0f);
            }];
            
            _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, nil];
        }
            break;
        case 3:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f).priorityHigh();
            }];
            
            GKImageView *imageView2 = [[GKImageView alloc] init];
            imageView2.contentMode = UIViewContentModeTop;
            imageView2.clipsToBounds = YES;
            [self addSubview:imageView2];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView1);
                make.left.equalTo(imageView1.mas_right).offset(5);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView3 = [[GKImageView alloc] init];
            imageView3.contentMode = UIViewContentModeTop;
            imageView3.clipsToBounds = YES;
            [self addSubview:imageView3];
            [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView1);
                make.left.equalTo(imageView2.mas_right).offset(5);
                make.right.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, nil];
        }
            break;
        case 4:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.width.mas_equalTo(SCREEN_WIDTH - 40.0f);
                make.height.mas_equalTo((SCREEN_WIDTH - 40.0f) / 1.7f).priorityHigh();
            }];
            
            GKImageView *imageView2 = [[GKImageView alloc] init];
            imageView2.contentMode = UIViewContentModeTop;
            imageView2.clipsToBounds = YES;
            [self addSubview:imageView2];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView1.mas_bottom).offset(5.0f);
                make.left.bottom.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f).priorityHigh();
            }];
            
            GKImageView *imageView3 = [[GKImageView alloc] init];
            imageView3.contentMode = UIViewContentModeTop;
            imageView3.clipsToBounds = YES;
            [self addSubview:imageView3];
            [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView2.mas_right).offset(5.0f);
                make.centerY.equalTo(imageView2);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView4 = [[GKImageView alloc] init];
            imageView4.contentMode = UIViewContentModeTop;
            imageView4.clipsToBounds = YES;
            [self addSubview:imageView4];
            [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView3.mas_right).offset(5.0f);
                make.centerY.equalTo(imageView2);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, imageView4, nil];
        }
            break;
        case 5:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 45.0f)/2.0f).priorityHigh();
            }];
            
            GKImageView *imageView2 = [[GKImageView alloc] init];
            imageView2.contentMode = UIViewContentModeTop;
            imageView2.clipsToBounds = YES;
            [self addSubview:imageView2];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView1.mas_right).offset(5.0f);
                make.top.right.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 45.0f)/2.0f);
            }];
            
            GKImageView *imageView3 = [[GKImageView alloc] init];
            imageView3.contentMode = UIViewContentModeTop;
            imageView3.clipsToBounds = YES;
            [self addSubview:imageView3];
            [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView1.mas_bottom).offset(5.0f);
                make.left.bottom.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f).priorityHigh();
            }];
            
            GKImageView *imageView4 = [[GKImageView alloc] init];
            imageView4.contentMode = UIViewContentModeTop;
            imageView4.clipsToBounds = YES;
            [self addSubview:imageView4];
            [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView3.mas_right).offset(5.0f);
                make.centerY.equalTo(imageView3);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView5 = [[GKImageView alloc] init];
            imageView5.contentMode = UIViewContentModeTop;
            imageView5.clipsToBounds = YES;
            [self addSubview:imageView5];
            [imageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView4.mas_right).offset(5.0f);
                make.centerY.equalTo(imageView3);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, imageView4, imageView5,nil];
        }
            break;
        case 6:
        {
            GKImageView *imageView1 = [[GKImageView alloc] init];
            imageView1.contentMode = UIViewContentModeTop;
            imageView1.clipsToBounds = YES;
            [self addSubview:imageView1];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f).priorityHigh();
            }];
            
            GKImageView *imageView2 = [[GKImageView alloc] init];
            imageView2.contentMode = UIViewContentModeTop;
            imageView2.clipsToBounds = YES;
            [self addSubview:imageView2];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView1);
                make.left.equalTo(imageView1.mas_right).offset(5);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView3 = [[GKImageView alloc] init];
            imageView3.contentMode = UIViewContentModeTop;
            imageView3.clipsToBounds = YES;
            [self addSubview:imageView3];
            [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView1);
                make.left.equalTo(imageView2.mas_right).offset(5);
                make.right.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView4 = [[GKImageView alloc] init];
            imageView4.contentMode = UIViewContentModeTop;
            imageView4.clipsToBounds = YES;
            [self addSubview:imageView4];
            [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView1.mas_bottom).offset(5);
                make.left.bottom.equalTo(self);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f).priorityHigh();
            }];
            
            GKImageView *imageView5 = [[GKImageView alloc] init];
            imageView5.contentMode = UIViewContentModeTop;
            imageView5.clipsToBounds = YES;
            [self addSubview:imageView5];
            [imageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView4);
                make.left.equalTo(imageView4.mas_right).offset(5);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            GKImageView *imageView6 = [[GKImageView alloc] init];
            imageView6.contentMode = UIViewContentModeTop;
            imageView6.clipsToBounds = YES;
            [self addSubview:imageView6];
            [imageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView4);
                make.left.equalTo(imageView5.mas_right).offset(5);
                make.width.height.mas_equalTo((SCREEN_WIDTH - 50.0f)/3.0f);
            }];
            
            _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, nil];
        }
            break;
        default:
        {
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.width.mas_equalTo(SCREEN_WIDTH - 40.0f);
                make.height.mas_equalTo(1).priorityLow();
            }];
            _imageViews = @[];
        }
            break;
    }
}

@end
