//
//  GKRealStuffCell.h
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealStuff.h"

@interface GKRealStuffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *realStuffTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *kindIndicatorView;

- (void)configreCellWithRealStuff:(RealStuff *)rs;

@end
