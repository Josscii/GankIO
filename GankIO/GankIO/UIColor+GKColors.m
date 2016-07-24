//
//  UIColor+GKColors.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "UIColor+GKColors.h"

@implementation UIColor (GKColors)

//App 前端 拓展资源 瞎推荐 福利 休息视频 all

+ (UIColor *)colorWithRealStuffType:(NSString *)type {
    if ([type isEqualToString:@"Android"]) {
        return [UIColor colorFromHexString:@"#A4C639"];
    } else if ([type isEqualToString:@"iOS"]) {
        return [UIColor colorFromHexString:@"#1D77EF"];
    } else if ([type isEqualToString:@"App"]) {
        return [UIColor colorFromHexString:@"#F9ED69"];
    } else if ([type isEqualToString:@"前端"]) {
        return [UIColor colorFromHexString:@"#F08A5D"];
    } else if ([type isEqualToString:@"瞎推荐"]) {
        return [UIColor colorFromHexString:@"#B83B5E"];
    } else if ([type isEqualToString:@"拓展资源"]) {
        return [UIColor colorFromHexString:@"#6A2C70"];
    } else if ([type isEqualToString:@"福利"]) {
        return [UIColor colorFromHexString:@"#F6416C"];
    } else if ([type isEqualToString:@"休息视频"]) {
        return [UIColor colorFromHexString:@"#29D2E4"];
    } else {
        return [UIColor colorFromHexString:@"#1D77EF"];
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
