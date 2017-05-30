//
//  GKRealStuffViewModel.m
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffViewModel.h"
#import "GKHttpClient.h"
#import "RACSignal+MTL.h"
#import "GKDBManager.h"
#import "RealStuff.h"

@interface GKRealStuffViewModel ()

@property (nonatomic, strong) RACSignal *requestHistorySignal;
@property (nonatomic, strong) RACSignal *requestRealStuffSignal;

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
    self.loadState = GKLoadStateNext;
    
    // history
    @weakify(self)
    self.requestHistoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        __block RACSignal *signal;
        [[[GKDBManager defaultManager] fetchHistory] subscribeNext:^(NSArray *x) {
            if (x.count == 0) {
                signal = self.requestHistorySignal;
            } else {
                signal = [RACSignal return:x];
            }
        } error:^(NSError *error) {
            signal = self.requestHistorySignal;
        }];
        return signal;
    }];
    
    RAC(self, history) = self.requestHistoryCommand.executionSignals.switchToLatest;
    
    // realstuff
    
    self.requestRealStuffCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __block RACSignal *signal;
        
        [[[GKDBManager defaultManager] selectRealStuffsOfDay:self.history[self.currentIndex]] subscribeNext:^(NSArray *x) {
            if (x.count == 0) {
                signal = self.requestRealStuffSignal;
            } else {
                signal = [RACSignal return:x];
            }
        } error:^(NSError *error) {
            signal = self.requestRealStuffSignal;
        }];
        
        return signal;
    }];
    
    RAC(self, realStuffs) = [self.requestRealStuffCommand.executionSignals.switchToLatest scanWithStart:@[] reduce:^id(NSArray *running, NSArray *next) {
        NSArray *result = nil;
        switch (self.loadState) {
            case GKLoadStateNext:
                if ([running containsObject:next]) {
                    result = running;
                } else {
                    result = [running arrayByAddingObject:next];
                }
                break;
            case GKLoadStatePre:
                if ([running containsObject:next]) {
                    result = running;
                } else {
                    result = [@[next] arrayByAddingObjectsFromArray:running];
                }
                break;
            case GKLoadStateRandom:
                result = @[next];
            default:
                break;
        }
        return result;
    }];
    
    // subscribe subject won't call signal block again, just add a subscriber to its list
    [self.requestHistoryCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        [self.requestRealStuffCommand execute:self.history[++self.currentIndex]];
        [self loadNextRealStuff];
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
        self.loadState = GKLoadStateNext;
        [self loadRealStuffAtOneDay:index];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GKHasReachedTheBottomNotification object:nil];
    }
}

- (void)loadPreRealStuff {
    NSInteger index = self.currentIndex;
    if (--index >= 0) {
        self.loadState = GKLoadStatePre;
        [self loadRealStuffAtOneDay:index];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GKHasReachedTheTopNotification object:nil];
    }
}

- (void)loadRandomRealStuff {
    NSInteger index = arc4random_uniform(self.history.count - 1.f);
    self.loadState = GKLoadStateRandom;
    [self loadRealStuffAtOneDay:index];
}

- (void)loadRealStuffAtOneDay:(NSInteger)day {
    self.currentIndex = day;
    [self.requestRealStuffCommand execute:nil];
}

// signals 需要 retry，在 2G 下很容易失败

- (RACSignal *)requestRealStuffSignal {
    return [[[[[[GKHttpClient sharedClient] getGankRealStuffForOneDay:self.history[self.currentIndex]] map:^id(NSDictionary *json) {
        NSArray *categories = json[@"category"];
        NSDictionary *result = json[@"results"];
        return [[categories.rac_sequence map:^id(NSString *cate) {
            return result[cate];
        }] foldLeftWithStart:@[] reduce:^id(NSArray *accumulator, id value) {
            return [accumulator arrayByAddingObjectsFromArray:value];
        }];
    }] retry:3] mtl_mapToArrayOfModelsWithClass:[RealStuff class]] doNext:^(NSArray<RealStuff *> *realStuffs) {
        for (RealStuff *rs in realStuffs) {
            if (rs.images == nil) {
                rs.images = @[];
            }
        }
        [[[GKDBManager defaultManager] saveRealStuffs:realStuffs ofDay:self.history[self.currentIndex]] subscribeNext:^(id x) {
            // NSLog(@"saved realstuffs successfully of %@", self.history[self.currentIndex]);
        }];
    }];
}

- (RACSignal *)requestHistorySignal {
    return [[[[[GKHttpClient sharedClient] getHistory] map:^id(id value) {
        NSArray *results = value[@"results"];
        return [[results.rac_sequence map:^id(NSString *dayString) {
            return [dayString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        }] array];
    }] retry:3] doNext:^(NSArray *history) {
        [history enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[[GKDBManager defaultManager] saveHistory:obj] subscribeNext:^(id x) {
                // NSLog(@"saved history successfully of %@", x);
            }];
        }];
    }];
}

@end
