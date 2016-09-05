//
//  GKProtocols.h
//  GankIO
//
//  Created by Josscii on 16/9/5.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#include "FMDB/FMDB.h"

#ifndef GKProtocols_h
#define GKProtocols_h

@protocol GKModelProtocol <NSObject>

+ (instancetype)modelWithResultSet:(FMResultSet *)s;

@end


#endif /* GKProtocols_h */
