//
//  GKPullHeaderView.h
//  GankIO
//
//  Created by Josscii on 16/8/12.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GKPullHeaderState) {
    GKPullHeaderStateReady,
    GKPullHeaderStateLoaing,
    GKPullHeaderStateNone
};

@interface GKPullHeaderView : UIView

@property (nonatomic, strong) NSLayoutConstraint *viewHeightConstraint;

@property (nonatomic, copy) NSString *belowThresholdText;
@property (nonatomic, copy) NSString *overThresholdText;

@property (nonatomic, assign) BOOL overThreshold;

@property (nonatomic, assign) BOOL hold; // weather to hold, defaults to YES
@property (nonatomic, assign) GKPullHeaderState state; // defaults to None

@end