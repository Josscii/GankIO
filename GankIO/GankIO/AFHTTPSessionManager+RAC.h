//
//  AFHTTPSessionManager+RAC.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface AFHTTPSessionManager (RAC)

- (RACSignal *)rac_GET:(NSString *)URLString;

@end