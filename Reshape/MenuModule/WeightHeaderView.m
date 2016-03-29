//
//  WeightHeaderView.m
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightHeaderView.h"
#import "UILabel+EX.h"
#import "UIFont+EX.h"
#import "UIColor+Hex.h"
#import "UIImage+EX.h"
#import <Masonry/Masonry.h>

@interface WeightHeaderView()
@property (nonatomic, strong)  UILabel  *title; // <##>

@property (nonatomic, strong)  UIButton  *addNewWeight; // <##>

@end

@implementation WeightHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor themeOrange_ff5d2b]];
        [self configElements];
    }
    return self;
}

- (void)configConstraints {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(25);
    }];
    [self.weightGoal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom);
        make.width.mas_equalTo(160);
    }];
    [self.addNewWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(145);
    }];
}
#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self addSubview:self.title];
    [self addSubview:self.weightGoal];
    [self addSubview:self.addNewWeight];
    
    [self configConstraints];
}

#pragma mark - Event Response
- (void)addWeightClick
{
    if ([self.delegate respondsToSelector:@selector(WeightHeaderViewDelegate_addWeightClick)]) {
        [self.delegate WeightHeaderViewDelegate_addWeightClick];
    }
}
- (void)changeTardetClick
{
    if ([self.delegate respondsToSelector:@selector(WeightHeaderViewDelegate_changeTargetWeightClick)]) {
        [self.delegate WeightHeaderViewDelegate_changeTargetWeightClick];
    }
}
#pragma mark - Delegate

#pragma mark - Init

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel setLabel:_title text:@"目标体重 (KG)" font:[UIFont themeFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _title;
}

- (UIButton *)weightGoal {
    if (!_weightGoal) {
        _weightGoal = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weightGoal setBackgroundColor:[UIColor clearColor]];
        [_weightGoal setTitle:@"0" forState:UIControlStateNormal];
        [_weightGoal.titleLabel setFont:[UIFont boldSystemFontOfSize:45]];
        [_weightGoal setImage:[UIImage imageNamed:@"weight_wirteIcon"] forState:UIControlStateNormal];
        [_weightGoal setImageEdgeInsets:UIEdgeInsetsMake(20, 100, 0, 0)];
        [_weightGoal setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
        [_weightGoal addTarget:self action:@selector(changeTardetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weightGoal;
}

- (UIButton *)addNewWeight {
    if (!_addNewWeight) {
        _addNewWeight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNewWeight setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_addNewWeight setTitle:@"新增体重" forState:UIControlStateNormal];
        [_addNewWeight.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_addNewWeight setImage:[UIImage imageNamed:@"weight_addIcon"] forState:UIControlStateNormal];
        [_addNewWeight setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [_addNewWeight setTitleColor:[UIColor colorGray_525252] forState:UIControlStateNormal];
        [_addNewWeight.layer setCornerRadius:10];
        [_addNewWeight.layer setMasksToBounds:YES];
        [_addNewWeight addTarget:self action:@selector(addWeightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNewWeight;
}
@end
