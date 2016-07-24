//
//  GKRealStuffCell.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffCell.h"
#import "UIColor+GKColors.h"

@interface GKRealStuffCell ()

@end

@implementation GKRealStuffCell

- (void)configreCellWithRealStuff:(RealStuff *)rs {
    UIColor *color = [UIColor colorWithRealStuffType:rs.type];
    
    self.realStuffTitleLabel.text = rs.desc;
    self.kindIndicatorView.backgroundColor = color;
}

@end
