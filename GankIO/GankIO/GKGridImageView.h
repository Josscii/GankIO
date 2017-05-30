//
//  GKGridImageView.h
//  NewGankHomeDemo
//
//  Created by Josscii on 16/10/10.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImageView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface GKGridImageView : UIView

@property (nonatomic, copy) NSArray<GKImageView *> *imageViews;
@property (nonatomic, assign) NSInteger count;

- (void)initializeImagesWithCount:(NSInteger)count;

@end
