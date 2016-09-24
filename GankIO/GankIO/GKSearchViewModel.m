//
//  GKSearchViewModel.m
//  GankIO
//
//  Created by Josscii on 16/9/7.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKSearchViewModel.h"
#import "GKHttpClient.h"
#import "RACSignal+MTL.h"
#import "RealStuff.h"

#define COUNT_PER_PAGE 10

@interface GKSearchViewModel ()

@end

@implementation GKSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.currentPage = 1;
    
    @weakify(self)
    self.searchRealStuffsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[GKHttpClient sharedClient] searchRealStuffsWithKeyword:self.searchKey inCategory:self.category count:COUNT_PER_PAGE perPage:self.currentPage] map:^id(NSDictionary *json) {
            return json[@"results"];
        }] mtl_mapToArrayOfModelsWithClass:[RealStuff class]];
    }];
    
    RAC(self, realStuffs) = [self.searchRealStuffsCommand.executionSignals.switchToLatest scanWithStart:@[] reduce:^id(NSArray *running, NSArray *next) {
        return [running arrayByAddingObjectsFromArray:next];
    }];
}

@end
