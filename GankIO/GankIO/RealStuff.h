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

@interface RealStuff : MTLModel <MTLJSONSerializing>

- (instancetype)initWithDesc:(NSString *)desc
                        type:(NSString *)type
                         url:(NSString *)url
                         who:(NSString *)who;

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *who;

@end
