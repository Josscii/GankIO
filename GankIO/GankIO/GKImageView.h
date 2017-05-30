//
//  GKImageView.h
//  GankIO
//
//  Created by Josscii on 16/10/13.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKImageView : UIImageView

- (void)startLoadingWithProgress:(double)progress;
- (void)endLoading;

@end
