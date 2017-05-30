//
//  GKSourceTagView.m
//  NewGankHomeDemo
//
//  Created by Josscii on 16/10/10.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKSourceTagView.h"
#import "Masonry/Masonry.h"
#import "UIColor+GKColors.h"

@interface GKSourceTagView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation GKSourceTagView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 2;
    
    _textLabel.font = [UIFont systemFontOfSize:10];
    _textLabel.textColor = [UIColor whiteColor];
    [self addSubview:_textLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setSourceKind:(GKSourceKind)sourceKind {
    switch (sourceKind) {
        case GKSourceKindGitHub:
            self.textLabel.text = @"Github";
            self.backgroundColor = [UIColor githubColor];
            break;
        case GKSourceKindZhihu:
            self.textLabel.text = @"知乎";
            self.backgroundColor = [UIColor zhihuColor];
            break;
        case GKSourceKindWeixin:
            self.textLabel.text = @"微信";
            self.backgroundColor = [UIColor weixinColor];
            break;
        case GKSourceKindJianshu:
            self.textLabel.text = @"简书";
            self.backgroundColor = [UIColor jianshuColor];
            break;
        default:
            self.textLabel.text = @"Blog";
            self.backgroundColor = [UIColor commonBlogColor];
            break;
    }
    _sourceKind = sourceKind;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(40.0f, 20.0f);
}

@end
