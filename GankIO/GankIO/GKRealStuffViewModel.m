//
//  GKRealStuffViewModel.m
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffViewModel.h"
#import "GKHttpClient.h"
#import "RealStuff.h"
#import "RACSignal+MTL.h"

@implementation GKRealStuffViewModel


- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        [self dataBinding];
    }
    
    return self;
}

- (void)dataBinding {
    self.requestDataSignal = [[[[GKHttpClient sharedClient] getGankDataFromDay:self.date] map:^id(id value) {
        NSMutableArray *realStuffs = [NSMutableArray array];
        NSDictionary *json = value;
        NSArray *categories = json[@"category"];
        NSDictionary *result = json[@"results"];
        for (NSString *cate in categories) {
            NSArray *rs = result[cate];
            [realStuffs addObjectsFromArray:rs];
        }
        return realStuffs;
    }] mtl_mapToArrayOfModelsWithClass:[RealStuff class]];
    
    RAC(self, realStuffs) = self.requestDataSignal;
}

@end
