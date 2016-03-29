//
//  MyTrainingRecordVoew.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingRecordVoew.h"
#import "UILabel+EX.h"
#import "UIFont+EX.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@implementation MyTrainingRecordVoew

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.progressView];
        [self addSubview:self.recordLb];
        [self addSubview:self.bestRecordLb];
        
        [self.recordLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(15);
            make.width.mas_equalTo(100);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.recordLb.mas_bottom).offset(7);
            make.width.height.mas_equalTo(120);
        }];
        
        [self.bestRecordLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressView.mas_bottom).offset(8);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)setMyData:(MyTrainInfoModel *)model
{
    [self.progressView setMyData:model];
    [self.bestRecordLb setAttributedText:[self getAttributWithInt:model.maxDays]];

}
//最长连续训练%ld天样式转换
- (NSAttributedString *)getAttributWithInt:(NSInteger)day
{
    NSString *costStr = [NSString stringWithFormat:@"最长连续训练%ld天",(long)day];
    NSRange costRange = [costStr rangeOfString:@"最长连续训练"];
    NSRange costRange1 = [costStr rangeOfString:@"天"];
    NSMutableAttributedString *costAttStr = [[NSMutableAttributedString alloc] initWithString:costStr];
    [costAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x747070] range:costRange];
    [costAttStr addAttribute:NSFontAttributeName value:[UIFont themeFontOfSize:15] range:costRange];
    [costAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x747070] range:costRange1];
    [costAttStr addAttribute:NSFontAttributeName value:[UIFont themeFontOfSize:15] range:costRange1];
    return costAttStr;
}

- (TrainRoundnessProgressBar *)progressView
{
    if (!_progressView) {
        _progressView = [[TrainRoundnessProgressBar alloc]init];
    }
    return _progressView;
}

- (UILabel *)recordLb
{
    if (!_recordLb) {
        _recordLb = [UILabel setLabel:_recordLb text:@"训练记录" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorMyLightGray_959595]];
    }
    return _recordLb;
}

- (UILabel *)bestRecordLb
{
    if (!_bestRecordLb) {
        _bestRecordLb = [UILabel setLabel:_bestRecordLb text:@"" font:[UIFont themeFontOfSize:25] textColor:[UIColor colorMyDarkGray_5a5a5a]];
        [_bestRecordLb setAttributedText:[self getAttributWithInt:0]];
    }
    return _bestRecordLb;
}
@end
