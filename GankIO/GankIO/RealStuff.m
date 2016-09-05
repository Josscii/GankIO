//
//  RealStuff.m
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "RealStuff.h"

@implementation RealStuff

#pragma mark - initializtion

- (instancetype)initWithDesc:(NSString *)desc
                        type:(NSString *)type
                         url:(NSString *)url
                         who:(NSString *)who
                  isFavorite:(NSInteger)isFavorite {
    self = [super init];
    if (self) {
        _desc = desc;
        _type = type;
        _url = url;
        _who = who;
        _isFavorite = isFavorite;
    }
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"desc": @"desc",
             @"type": @"type",
             @"url": @"url",
             @"who": @"who"
             };
}

#pragma mark - GKModelProtocol

+ (instancetype)modelWithResultSet:(FMResultSet *)s {
    NSString *desc = [s objectForColumnName:@"desc"];
    NSString *type = [s objectForColumnName:@"type"];
    NSString *url = [s objectForColumnName:@"url"];
    NSString *who = [s objectForColumnName:@"who"];
    NSInteger isFavorite = [s intForColumn:@"isFavorite"];
    return [[RealStuff alloc] initWithDesc:desc type:type url:url who:who isFavorite:isFavorite];
}

@end