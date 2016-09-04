//
//  GKDBManager.h
//  GankIO
//
//  Created by Josscii on 16/9/3.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface GKDBManager : NSObject

+ (instancetype)defaultManager;

- (RACSignal *)saveHistory:(NSString *)day;
- (RACSignal *)fetchHistory;

- (RACSignal *)saveRealStuffs:(NSArray *)realStuffs ofDay:(NSString *)day;
- (RACSignal *)fetchRealStuffsOfDay:(NSString *)day;

@end
