//
//  GKNewGankRealStuffCell.m
//  GankIO
//
//  Created by Josscii on 16/10/12.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKNewGankRealStuffCell.h"
#import "Masonry/Masonry.h"
#import "GKGridImageView.h"
#import "GKSourceTagView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "UIColor+GKColors.h"

@interface GKNewGankRealStuffCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GKGridImageView *gridImageView;
@property (nonatomic, strong) UIView *contentSeparator;
@property (nonatomic, strong) GKSourceTagView *sourceTagView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *creatorLabel;

@end

@implementation GKNewGankRealStuffCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor titleColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40.0f;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    _gridImageView = [[GKGridImageView alloc] init];
    [self.contentView addSubview:_gridImageView];
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5.0f);
    }];
    
    _contentSeparator = [[UIView alloc] init];
    _contentSeparator.backgroundColor = [UIColor contentSeparatorColor];
    [self.contentView addSubview:_contentSeparator];
    [_contentSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gridImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.height.mas_equalTo(1);
    }];
    
    _sourceTagView = [[GKSourceTagView alloc] init];
    [self.contentView addSubview:_sourceTagView];
    [_sourceTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(_contentSeparator.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-8.0f);
    }];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:_likeButton];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(20);
        make.centerY.equalTo(_sourceTagView);
        make.left.equalTo(_sourceTagView.mas_right).offset(10);
    }];
    [_likeButton addTarget:self action:@selector(didPressFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _creatorLabel = [[UILabel alloc] init];
    _creatorLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_creatorLabel];
    [_creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(_sourceTagView);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelecteAImage:)];
    [_gridImageView addGestureRecognizer:gesture];
}

- (void)didSelecteAImage:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.gridImageView];
    for (GKImageView *view in self.gridImageView.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            NSInteger index = [self.gridImageView.subviews indexOfObject:view];
            if ([self.delegate respondsToSelector:@selector(didSelectImageInCell:withImageView:withIndex:)]) {
                [self.delegate didSelectImageInCell:self withImageView:view withIndex:index];
            }
        }
    }
}

- (void)didPressFavoriteButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didPressFavoriteButton:inCell:)]) {
        [self.delegate didPressFavoriteButton:button inCell:self];
    }
}

- (void)configureCellWithRealStuff:(RealStuff *)rs {
    self.titleLabel.text = rs.desc;
    self.creatorLabel.text = rs.who;
    self.sourceTagView.sourceKind = [self sourceKindWithUrlString:rs.url];
    [self configureLikeButton:rs.isFavorite];
    
    if ([rs.type isEqualToString:@"福利"]) {
        [self.gridImageView initializeImagesWithCount:1];
        NSString *s = [NSString stringWithFormat:@"%@?imageView2/4/w/320/format/png", rs.url];
        NSURL *url = [NSURL URLWithString:s];
        self.gridImageView.imageViews[0].contentMode = UIViewContentModeScaleAspectFill;
        [self.gridImageView.imageViews[0] sd_setImageWithURL:url];
    } else {
        [self.gridImageView initializeImagesWithCount:rs.images.count];
        for (int i = 0; i < rs.images.count; i++) {
            NSString *s = [NSString stringWithFormat:@"%@?imageView2/4/w/320/format/png", rs.images[i]];
            NSURL *url = [NSURL URLWithString:s];
            [self.gridImageView.imageViews[i] sd_setImageWithURL:url];
        }
    }
    
    // ?imageView2/4/w/320/format/png
}

- (GKSourceKind)sourceKindWithUrlString:(NSString *)urlString {
    GKSourceKind kind;
    if ([urlString containsString:@"jianshu"]) {
        kind = GKSourceKindJianshu;
    } else if ([urlString containsString:@"github"]) {
        kind = GKSourceKindGitHub;
    } else if ([urlString containsString:@"zhihu"]) {
        kind = GKSourceKindZhihu;
    } else if ([urlString containsString:@"weixin"]) {
        kind = GKSourceKindWeixin;
    } else {
        kind = GKSourceKindOther;
    }
    return kind;
}

- (void)configureLikeButton:(BOOL)like {
    if (!like) {
        [_likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        _likeButton.tintColor = [UIColor titleColor];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        _likeButton.tintColor = [UIColor redColor];
    }
}
@end
