//
//  GKSearchViewModel.h
//  GankIO
//
//  Created by Josscii on 16/9/7.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface GKSearchViewModel : NSObject

@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSArray *realStuffs;

@property (nonatomic, strong) RACCommand *searchRealStuffsCommand;

@end
