//
//  GKRealStuffViewModel.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RealStuff.h"

@interface GKRealStuffViewModel : NSObject

@property (nonatomic, copy) NSArray *realStuffs;
@property (nonatomic, copy) NSArray *history;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) RACCommand *requestRealStuffCommand;
@property (nonatomic, strong) RACCommand *requestHistoryCommand;

- (void)loadHistory;
- (void)loadPreRealStuff;
- (void)loadNextRealStuff;
- (void)loadRandomRealStuff;
- (void)loadRealStuffAtOneDay:(NSInteger)day;

@end
