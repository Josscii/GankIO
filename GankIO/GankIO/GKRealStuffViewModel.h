//
//  GKRealStuffViewModel.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface GKRealStuffViewModel : NSObject

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSArray *realStuffs;
@property (nonatomic, strong) RACSignal *requestDataSignal;

- (instancetype)initWithDate:(NSDate *)date;

@end
