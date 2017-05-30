//
//  GKNewGankRealStuffCell.h
//  GankIO
//
//  Created by Josscii on 16/10/12.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealStuff.h"
#import "GKImageView.h"

@protocol GKNewGankRealStuffCellDelegate <NSObject>

- (void)didSelectImageInCell:(UITableViewCell *)cell withImageView:(GKImageView *)imageView withIndex:(NSInteger)index;
- (void)didPressFavoriteButton:(UIButton *)button inCell:(UITableViewCell *)cell;

@end

@interface GKNewGankRealStuffCell : UITableViewCell

@property (nonatomic, weak) id<GKNewGankRealStuffCellDelegate> delegate;

- (void)configureCellWithRealStuff:(RealStuff *)rs;

@end
