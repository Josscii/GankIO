//
//  GKLoadingView.h
//  GankIO
//
//  Created by Josscii on 16/9/6.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKLoadingView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

- (void)startLoading;
- (void)stopLoading;

@end
