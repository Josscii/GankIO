//
//  RACSignal+MTL.m
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "RACSignal+MTL.h"
#import "MTLModel+JSON.h"

@implementation RACSignal (MTL)

- (RACSignal *)mtl_mapToModelWithClass:(Class)klass {
    return [self map:^id(id value) {
        return [klass modelWithJSON:(NSDictionary *)value];
    }];
}

- (RACSignal *)mtl_mapToArrayOfModelsWithClass:(Class)klass {
    return [self map:^id(id value) {
        return [klass arrayOfModelsWithJSON:(NSArray *)value];
    }];
}

@end
