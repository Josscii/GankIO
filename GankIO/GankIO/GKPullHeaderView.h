//
//  GKPullHeaderView.h
//  GankIO
//
//  Created by Josscii on 16/8/12.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKPullHeaderView : UIView

@property (nonatomic, strong) NSLayoutConstraint *viewHeightConstraint;

@property (nonatomic, copy) NSString *belowThresholdText;
@property (nonatomic, copy) NSString *overThresholdText;

@property (nonatomic, assign) BOOL overThreshold;

@end