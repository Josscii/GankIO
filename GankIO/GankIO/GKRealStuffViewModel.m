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

@interface GKRealStuffViewModel ()

@property (nonatomic, strong) RACSignal *signal;

@end

@implementation GKRealStuffViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.currentIndex = -1;
    
    self.requestHistoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[GKHttpClient sharedClient] getHistory] map:^id(id value) {
            NSArray *results = value[@"results"];
            return [[results.rac_sequence map:^id(NSString *dayString) {
                return [dayString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            }] array];
        }];
    }];
    
    RAC(self, history) = [self.requestHistoryCommand.executionSignals switchToLatest];
    
    self.requestRealStuffCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *dayString) {
        return [[[[GKHttpClient sharedClient] getGankRealStuffForOneDay:dayString] map:^id(NSDictionary *json) {
            NSArray *categories = json[@"category"];
            NSDictionary *result = json[@"results"];
            return [[categories.rac_sequence map:^id(NSString *cate) {
                return result[cate];
            }] foldLeftWithStart:@[] reduce:^id(NSArray *accumulator, id value) {
                return [accumulator arrayByAddingObjectsFromArray:value];
            }];
        }] mtl_mapToArrayOfModelsWithClass:[RealStuff class]];
    }];
    
    RAC(self, realStuffs) = [self.requestRealStuffCommand.executionSignals switchToLatest];
    
    // subscribe subject won't call signal block again, just add a subscriber to its list
    [[self.requestHistoryCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        [self.requestRealStuffCommand execute:self.history[++self.currentIndex]];
    }];
    
    RAC(self, title) = [RACObserve(self, currentIndex) map:^id(NSNumber *index) {
        return [self.history objectAtIndex:index.integerValue];
    }];
}
                             // next          // pre
// | 请求历史 ----> 请求最近的一期 ----> 判断是否到底 ----> 判断是否到顶

- (void)loadHistory {
    [self.requestHistoryCommand execute:nil];
}

#pragma mark - recode this to be more FRPish.

- (void)loadNextRealStuff {
    NSInteger index = self.currentIndex;
    if (++index < self.history.count) {
        [self loadRealStuffAtOneDay:index];
    } else {
        NSLog(@"已经到最后一页了");
    }
}

- (void)loadPreRealStuff {
    NSInteger index = self.currentIndex;
    if (--index >= 0) {
        [self loadRealStuffAtOneDay:index];
    } else {
        NSLog(@"已经到第一页了");
    }
}

- (void)loadRandomRealStuff {
    NSInteger index = arc4random_uniform(self.history.count - 1);
    [self loadRealStuffAtOneDay:index];
}

- (void)loadRealStuffAtOneDay:(NSInteger)day {
    [self.requestRealStuffCommand execute:self.history[day]];
    self.currentIndex = day;
}
@end
