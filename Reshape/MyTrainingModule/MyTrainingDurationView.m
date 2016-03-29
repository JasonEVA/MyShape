//
//  MyTrainingDurationView.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingDurationView.h"
#import "UILabel+EX.h"
#import "UIFont+EX.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@implementation MyTrainingDurationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.timeNumLb];
        [self addSubview:self.timeView];
        [self addSubview:self.unitLb];
        [self addSubview:self.durationLb];
        
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-48);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(42);
        }];
        
        [self.durationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        [self.timeNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.durationLb.mas_bottom).offset(13);
        }];
        [self.unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeNumLb).offset(-12);
            make.left.equalTo(self.timeNumLb.mas_right).offset(4);
        }];
    }
    return self;
}

- (void)setMyData:(MyTrainInfoModel *)model
{
    [self.timeNumLb setText:[NSString stringWithFormat:@"%ld",(long)model.totalTrainingMinutes]];
    [self.timeView setMyData:model];
}
- (TrainTimeView *)timeView
{
    if (!_timeView) {
        _timeView = [[TrainTimeView alloc]init];
    }
    return _timeView;
    
}

- (UILabel *)durationLb
{
    if (!_durationLb) {
        _durationLb = [UILabel setLabel:_durationLb text:@"训练时长" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorMyLightGray_959595]];
    }
    return _durationLb;
}

- (UILabel *)timeNumLb
{
    if (!_timeNumLb) {
        _timeNumLb = [UILabel setLabel:_timeNumLb text:@"0" font:[UIFont themeFontOfSize:65] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _timeNumLb;
}

- (UILabel *)unitLb
{
    if (!_unitLb) {
        _unitLb = [UILabel setLabel:_unitLb text:@"分钟" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorWithHex:0x747070]];
    }
    return _unitLb;
}
@end
