//
//  GKAppConstants.h
//  GankIO
//
//  Created by Josscii on 16/7/17.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, GKRealStuffKind) {
    GKRealStuffKindAndroid,
    GKRealStuffKindiOS,
    GKRealStuffKindFrontEnd,
    GKRealStuffKindAll,
    GKRealStuffKindBlank,
    GKRealStuffKindApp,
    GKRealStuffKindWelfare,
    GKRealStuffKindVideo,
    GKRealStuffKindExtendResource
};

extern NSString *const GKPullToLoadPre;
extern NSString *const GKLoosenToLoadPre;