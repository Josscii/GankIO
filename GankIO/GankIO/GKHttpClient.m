//
//  GKHttpClient.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKHttpClient.h"
#import "GKNetworkConstants.h"
#import "AFHTTPSessionManager+RAC.h"

@interface GKHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation GKHttpClient

+ (instancetype)sharedClient {
    static GKHttpClient *httpClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[GKHttpClient alloc] init];
    });
    return httpClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:GKBaseApiURL];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (RACSignal *)getGankRealStuffForOneDay:(NSString *)dayString {
    return [self.manager rac_GET:[NSString stringWithFormat:@"day/%@", dayString]];
}

- (RACSignal *)getHistory {
    return [self.manager rac_GET:GKHistoryURL];
}

- (RACSignal *)searchRealStuffsWithKeyword:(NSString *)key inCategory:(NSString *)category count:(NSInteger)count perPage:(NSInteger)page {
    NSString *url = [[GKSearchURL stringByAppendingString:[NSString stringWithFormat:@"%@/category/%@/count/%lu/page/%lu", key, category, (long)count, (long)page]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self.manager rac_GET:url];
}

@end
