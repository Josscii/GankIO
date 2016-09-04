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
                         who:(NSString *)who {
    self = [super init];
    if (self) {
        _desc = desc;
        _type = type;
        _url = url;
        _who = who;
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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.desc = [coder decodeObjectForKey:@"desc"];
        self.type = [coder decodeObjectForKey:@"type"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.who = [coder decodeObjectForKey:@"who"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.who forKey:@"who"];
}

@end