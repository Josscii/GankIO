//
//  GKHttpClient.h
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface GKHttpClient : NSObject

+ (instancetype)sharedClient;

- (RACSignal *)getHistory;
- (RACSignal *)getGankRealStuffForOneDay:(NSString *)dayString;

@end
