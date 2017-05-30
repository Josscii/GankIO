//
//  RealStuff.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKAppConstants.h"
#import <Mantle/Mantle.h>
#import "GKProtocols.h"

@interface RealStuff : MTLModel <MTLJSONSerializing, GKModelProtocol>

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *who;
@property (nonatomic, assign) NSInteger isFavorite;
@property (nonatomic, copy) NSArray<NSString *> *images;

- (instancetype)initWithDesc:(NSString *)desc
                        type:(NSString *)type
                         url:(NSString *)url
                         who:(NSString *)who
                  isFavorite:(NSInteger)isFavorite
                      images:(NSArray *)images;

@end
