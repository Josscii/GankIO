//
//  RealStuff.h
//  GankIO
//
//  Created by Josscii on 16/7/24.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKAppConstants.h"

@interface RealStuff : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) GKRealStuffKind *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *who;

@end
