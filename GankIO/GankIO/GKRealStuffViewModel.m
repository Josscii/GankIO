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
    
    self.signal = RACObserve(self, history);
    
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
    
    self.requestHistoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[GKHttpClient sharedClient] getHistory] map:^id(id value) {
            NSArray *results = value[@"results"];
            return [[results.rac_sequence map:^id(NSString *dayString) {
                return [dayString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            }] array];
        }];
    }];
    
    RAC(self, history) = [self.requestHistoryCommand.executionSignals switchToLatest];
    
    [self.requestHistoryCommand execute:nil];
    
    [self loadNextRealStuff];
}
# pragma mark - 到底和到顶需要提示

- (void)loadNextRealStuff {
    [self.signal subscribeNext:^(id x) {
        [self.requestRealStuffCommand execute:self.history[++self.currentIndex]];
        self.title = self.history[self.currentIndex];
    }];
}

- (void)loadPreRealStuff {
    [self.signal subscribeNext:^(id x) {
        [self.requestRealStuffCommand execute:self.history[--self.currentIndex]];
    }];
}

@end
