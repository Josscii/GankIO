//
//  GKDatePicker.m
//  GankIO
//
//  Created by Josscii on 16/9/29.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKDatePicker.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "GKAppConstants.h"

@interface GKDatePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSMutableArray*>*> *historyDic;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) UIButton *comfirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) void(^selectBlock)(NSString *);

@end

@implementation GKDatePicker

- (instancetype)initWithSelectBlock:(void(^)(NSString *))selectBlock {
    self = [super init];
    if (self) {
        _selectBlock = selectBlock;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    // configure
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    // containerView
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 5.0f;
    
    // shadow
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 180)];
    _containerView.layer.masksToBounds = NO;
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    _containerView.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_containerView];
    [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200].active = YES;
    [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180].active = YES;
    
    // picker
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_pickerView];
    [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200].active = YES;
   [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:162].active = YES;
    
    // title label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"选择日期";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_titleLabel];
    [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1 constant:20].active = YES;
    
    // comfirm button
    _comfirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_comfirmButton setTitle:@"选择" forState:UIControlStateNormal];
    _comfirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_comfirmButton];
    [NSLayoutConstraint constraintWithItem:_comfirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20].active = YES;
    [NSLayoutConstraint constraintWithItem:_comfirmButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1 constant:-30].active = YES;
    [_comfirmButton addTarget:self action:@selector(didSelectHistory) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_cancelButton];
    [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20].active = YES;
    [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1 constant:30].active = YES;
    
    [_cancelButton addTarget:self action:@selector(didCancel) forControlEvents:UIControlEventTouchUpInside];
}

// action

- (void)didSelectHistory {
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:2];
    NSString *day = self.historyDic[self.year][self.month][dayIndex];
    NSString *selectedHistory = [NSString stringWithFormat:@"%@/%@/%@", self.year, self.month, day];
    self.selectBlock(selectedHistory);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didCancel {
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showAnimation {
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.transform = transform;
    self.hidden = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.hidden = NO;
    }];
}

#pragma mark - delegate && datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.historyDic.allKeys.count;
            break;
        case 1:
            return self.historyDic[self.year].allKeys.count;
            break;
        case 2:
            return self.historyDic[self.year][self.month].count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.historyDic.allKeys[row];
            break;
        case 1:
            return self.historyDic[self.year].allKeys[row];
            break;
        case 2:
            return self.historyDic[self.year][self.month][row];
            break;
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.year = self.historyDic.allKeys[row];
        self.month = self.historyDic[self.year].allKeys[row];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
    } else if (component == 1) {
        self.month = self.historyDic[self.year].allKeys[row];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
    }
}

// handle historys

- (void)setHistorys:(NSArray *)historys {
    NSArray *nHistory = [[historys.rac_sequence map:^id(NSString *value) {
        return [value componentsSeparatedByString:@"/"];
    }] array];
    
    NSMutableSet *yearSet = [NSMutableSet set];
    for (NSArray *a in nHistory) {
        [yearSet addObject:a[0]];
    }
    
    NSMutableDictionary<NSString*, NSMutableSet*> *monthDic = [NSMutableDictionary dictionary];
    
    for (NSString *y in yearSet) {
        for (NSArray *a in nHistory) {
            if ([a containsObject:y]) {
                if (monthDic[y] == nil) {
                    monthDic[y] = [NSMutableSet set];
                }
                [monthDic[y] addObject:a[1]];
            }
        }
    }
    
    NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSMutableArray*>*> *result = [NSMutableDictionary dictionary];
    for (NSString *key in monthDic) {
        for (NSString *m in [monthDic valueForKey:key]) {
            for (NSArray *a in nHistory) {
                if ([a[0] isEqualToString:key] && [a[1] isEqualToString:m]) {
                    if (result[key] == nil) {
                        result[key] = [NSMutableDictionary dictionary];
                    }
                    if (result[key][m] == nil) {
                        result[key][m] = [NSMutableArray array];
                    }
                    [result[key][m] addObject:a[2]];
                }
            }
        }
    }
    
    _historyDic = result;
    _year = result.allKeys.firstObject;
    _month = result[_year].allKeys.firstObject;
    _historys = historys;
}

@end
