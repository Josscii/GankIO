//
//  GKFeatureViewModel.m
//  GankIO
//
//  Created by Josscii on 16/9/5.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKFeatureViewModel.h"
#import "GKDBManager.h"

@implementation GKFeatureViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.getFeaturedRealStuffsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GKDBManager defaultManager] selectFavoriteRealStuffs];
    }];
    
    RAC(self, realStuffs) = [[[self.getFeaturedRealStuffsCommand executionSignals] switchToLatest] map:^id(id value) {
        return [value mutableCopy];
    }];
}

@end
