//
//  GKFeatureViewModel.h
//  GankIO
//
//  Created by Josscii on 16/9/5.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface GKFeatureViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *realStuffs;
@property (nonatomic, strong) RACCommand *getFeaturedRealStuffsCommand;

@end
