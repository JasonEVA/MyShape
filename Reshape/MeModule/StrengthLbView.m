//
//  StrengthLbView.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "StrengthLbView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@implementation StrengthLbView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.strengthView];
        [self addSubview:self.label];
        
        [self.strengthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@90);
            
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.left.equalTo(self.strengthView.mas_right).offset(18);
        }];
    }
    return self;
}

- (void)setMyLevel:(NSInteger)Level num:(NSInteger)num
{
    [self.strengthView setTrainStrengLevel:Level];
    [self.label setText:[NSString stringWithFormat:@"消耗%ld卡路里",(long)num]];
}

- (TrainStrengthView *)strengthView
{
    if (!_strengthView) {
        _strengthView = [[TrainStrengthView alloc] init];
    }
    return _strengthView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setText:@"消耗2500卡路里"];
        [_label setTextColor:[UIColor colorWithHex:0x666666]];
    }
    return _label;
}
@end
