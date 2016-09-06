//
//  GKAppConstants.h
//  GankIO
//
//  Created by Josscii on 16/7/17.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

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

extern NSString *const GKDidPickAHistoryDayNotification;
extern NSString *const GKDidUnMarkRealStuffNotification;