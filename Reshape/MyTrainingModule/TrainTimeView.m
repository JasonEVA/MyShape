//
//  TrainTimeView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainTimeView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

@implementation TrainTimeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initComponent];
        [self configConstraints];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.allTimeLb];
    [self addSubview:self.allTimeNum];
    [self addSubview:self.eachDayLb];
    [self addSubview:self.eachDayNum];
    [self addSubview:self.costLb];
    [self addSubview:self.costNum];
    
}

- (void)setMyData:(MyTrainInfoModel *)model
{
    [self.allTimeNum setAttributedText:[self getAttributWithInt:model.totalTrainingTimes unit:@"次"]];

    [self.eachDayNum setAttributedText:[self getAttributWithInt:model.totalTrainingDays unit:@"天"]];
    
    [self.costNum setAttributedText:[self getAttributWithInt:model.totalConsume unit:@"卡"]];
}
//内容样式转换
- (NSAttributedString *)getAttributWithInt:(NSInteger)num unit:(NSString *)unit{
    
    NSString *allStr = [NSString stringWithFormat:@"%ld%@",(long)num,unit];
    NSRange allRange = [allStr rangeOfString:unit];
    NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [allAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x747070] range:allRange];
    [allAttStr addAttribute:NSFontAttributeName value:[UIFont themeFontOfSize:15] range:allRange];
    return allAttStr;
}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)configConstraints
{
    [self.allTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    [self.allTimeNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.allTimeLb);
        make.top.equalTo(self.allTimeLb.mas_bottom).offset(13);
    }];
    [self.eachDayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
    [self.eachDayNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eachDayLb);
        make.top.equalTo(self.allTimeNum);
    }];
    
    [self.costLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
    [self.costNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allTimeNum);
        make.centerX.equalTo(self.costLb);
        make.right.lessThanOrEqualTo(self);
    }];
}
#pragma mark - init UI
- (UILabel *)allTimeLb
{
    if (!_allTimeLb) {
        _allTimeLb = [UILabel setLabel:_allTimeLb text:@"训练次数" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorMyLightGray_959595]];
    }
    return _allTimeLb;
}

- (UILabel *)allTimeNum
{
    if (!_allTimeNum) {
        _allTimeNum = [UILabel setLabel:_allTimeNum text:@"0" font:[UIFont systemFontOfSize:25] textColor:[UIColor colorMyDarkGray_5a5a5a]];
        [_allTimeNum setAttributedText:[self getAttributWithInt:0 unit:@"次"]];
    }
    return _allTimeNum;
}

- (UILabel *)eachDayLb
{
    if (!_eachDayLb) {
        _eachDayLb = [UILabel setLabel:_eachDayLb text:@"训练天数" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorMyLightGray_959595]];
    }
    return _eachDayLb;
}

- (UILabel *)eachDayNum
{
    if (!_eachDayNum) {
        _eachDayNum = [UILabel setLabel:_eachDayNum text:@"0" font:[UIFont systemFontOfSize:25] textColor:[UIColor colorMyDarkGray_5a5a5a]];
        [_eachDayNum setAttributedText:[self getAttributWithInt:0 unit:@"天"]];
    }
    return _eachDayNum;
}

- (UILabel *)costLb
{
    if (!_costLb) {
        _costLb = [UILabel setLabel:_costLb text:@"我的消耗" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorMyLightGray_959595]];
        [_costLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _costLb;
}

- (UILabel *)costNum
{
    if (!_costNum) {
        _costNum = [UILabel setLabel:_costNum text:@"0" font:[UIFont systemFontOfSize:25] textColor:[UIColor colorMyDarkGray_5a5a5a]];
        [_costNum setAttributedText:[self getAttributWithInt:0 unit:@"卡"]];
    }
    return _costNum;
}


@end

