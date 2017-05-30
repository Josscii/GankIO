
//
//  GKImageView.m
//  GankIO
//
//  Created by Josscii on 16/10/13.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKImageView.h"
#import "GKProgressView.h"

@interface GKImageView ()

@property (nonatomic, strong) GKProgressView *progressView;

@end

@implementation GKImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _progressView = [[GKProgressView alloc] initWithFrame:self.bounds];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)startLoadingWithProgress:(double)progress {
    self.progressView.progress = progress;
    self.progressView.hidden = NO;
}

- (void)endLoading {
    self.progressView.hidden = YES;
}

@end
