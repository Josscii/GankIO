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

- (void)configreCellWithJSON:(NSDictionary *)dic {
    NSString *desc = dic[@"desc"];
    NSString *type = dic[@"type"];
    UIColor *color = [UIColor colorWithRealStuffType:type];
    
    self.realStuffTitleLabel.text = desc;
    self.kindIndicatorView.backgroundColor = color;
}

@end
