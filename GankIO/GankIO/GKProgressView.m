//
//  GKProgressView.m
//  GankIO
//
//  Created by Josscii on 16/10/13.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKProgressView.h"

@implementation GKProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGFloat startA = 3.0f/2.0f * M_PI;
    CGFloat endA = startA + M_PI * 2 * MIN(MAX(_progress, 0), 1);
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:12
                                                      startAngle:0
                                                        endAngle:M_PI * 2
                                                       clockwise:YES];
    bgPath.lineWidth = 7;
    [[UIColor lightGrayColor] setStroke];
    [bgPath stroke];
    
    UIBezierPath *pPath =  [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:12
                                                      startAngle:startA
                                                        endAngle:endA
                                                       clockwise:YES];
    pPath.lineWidth = 4;
    pPath.lineCapStyle = kCGLineCapRound;
    [[UIColor whiteColor] setStroke];
    [pPath stroke];
}

- (void)setProgress:(double)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
