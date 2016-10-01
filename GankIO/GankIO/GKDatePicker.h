//
//  GKDatePicker.h
//  GankIO
//
//  Created by Josscii on 16/9/29.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKDatePicker : UIView

@property (nonatomic, copy) NSArray *historys;

- (instancetype)initWithSelectBlock:(void(^)(NSString *))selectBlock;

- (void)showAnimation;

@end
