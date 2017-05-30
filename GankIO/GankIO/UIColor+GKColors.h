//
//  UIColor+GKColors.h
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GKColors)

+ (UIColor *)colorWithRealStuffType:(NSString *)type;

+ (UIColor *)githubColor;
+ (UIColor *)jianshuColor;
+ (UIColor *)zhihuColor;
+ (UIColor *)weixinColor;
+ (UIColor *)commonBlogColor;
+ (UIColor *)contentSeparatorColor;
+ (UIColor *)titleColor;
+ (UIColor *)creatorColor;

@end
