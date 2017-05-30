//
//  GKSourceTagView.h
//  NewGankHomeDemo
//
//  Created by Josscii on 16/10/10.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GKSourceKind) {
    GKSourceKindGitHub,
    GKSourceKindJianshu,
    GKSourceKindZhihu,
    GKSourceKindWeixin,
    GKSourceKindOther
};

@interface GKSourceTagView : UIView

@property (nonatomic, assign) GKSourceKind sourceKind;

@end
