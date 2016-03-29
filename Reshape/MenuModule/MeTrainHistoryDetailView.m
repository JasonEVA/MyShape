//
//  MeTrainHistoryDetailView.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeTrainHistoryDetailView.h"
#import "UILabel+EX.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

@implementation MeTrainHistoryDetailView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initComponent];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.titelLb];
    [self addSubview:self.costDistanceValue];
    [self addSubview:self.costDistanceTitel];
    [self addSubview:self.timeValue];
    [self addSubview:self.timeTitel];
    [self addSubview:self.imageView];
    [self configConstraints];
}

- (void)setMyContent:(MeTrainHistoryDetailModel *)model
{
    [self.titelLb setText:[NSString stringWithFormat:@"完成“%@”",model.trainingVideoName]];
    [self.costDistanceValue setText:[NSString stringWithFormat:@"%ld卡",(long)model.consume]];
    [self.timeValue setText:[NSString stringWithFormat:@"%ld分钟",(long)model.length]];
}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)configConstraints
{
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.right.lessThanOrEqualTo(self);
    }];
  
    [self.costDistanceTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.costDistanceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.costDistanceTitel.mas_right).offset(5);
        make.centerY.equalTo(self.costDistanceTitel);
        make.right.lessThanOrEqualTo(self.timeTitel.mas_left);
    }];
    
    [self.timeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTitel.mas_right).offset(5);
        make.centerY.equalTo(self.timeTitel);
        make.right.lessThanOrEqualTo(self);
    }];
    [self.timeTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.costDistanceTitel);
    }];
   
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];
}
#pragma mark - init UI

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"完成“零基础训练”" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHex:0x555555]];
    }
    return _titelLb;
}


- (UILabel *)costDistanceTitel
{
    if (!_costDistanceTitel) {
        _costDistanceTitel = [UILabel setLabel:_costDistanceTitel text:@"消耗:" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHex:0xa6a6a6]];
    }
    return _costDistanceTitel;
}
- (UILabel *)costDistanceValue
{
    if (!_costDistanceValue) {
        _costDistanceValue = [UILabel setLabel:_costDistanceValue text:@"327" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHex:0xa6a6a6]];
    }
    return _costDistanceValue;
}
- (UILabel *)timeTitel
{
    if (!_timeTitel) {
        _timeTitel = [UILabel setLabel:_timeTitel text:@"时长:" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHex:0xa6a6a6]];
    }
    return _timeTitel;
}
- (UILabel *)timeValue
{
    if (!_timeValue) {
        _timeValue = [UILabel setLabel:_timeValue text:@"00:30" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHex:0xa6a6a6]];
    }
    return _timeValue;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_trainhistory"]];
    }
    return _imageView;
}
@end
