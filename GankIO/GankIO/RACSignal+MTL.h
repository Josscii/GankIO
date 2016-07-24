//
//  RACSignal+MTL.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (MTL)

- (RACSignal *)mtl_mapToModelWithClass:(Class)klass;
- (RACSignal *)mtl_mapToArrayOfModelsWithClass:(Class)klass;

@end
