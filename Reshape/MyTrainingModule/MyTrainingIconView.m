//
//  MyTrainingIconView.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingIconView.h"
#import "UIFont+EX.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "UILabel+EX.h"
#import "UIImageView+WebCache.h"

@implementation MyTrainingIconView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.shadeView];
        [self addSubview:self.nikeNameLbl];
        [self addSubview:self.strengView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(12);
            make.centerX.equalTo(self);
            make.height.width.mas_equalTo(100);
            
        }];
        
        [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(11);
            make.centerX.equalTo(self);
            make.height.width.mas_equalTo(102);
            
        }];
        [self.nikeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(12);
            make.centerX.equalTo(self);
            make.left.right.lessThanOrEqualTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        
        [self.strengView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nikeNameLbl.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setMyData:(MyTrainInfoModel *)model
{
    NSURL *url = [NSURL URLWithString:model.headIcon];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"me_iconplacehoder"]];
    [self.nikeNameLbl setText:model.userName];
    [self.strengView setTrainStrengLevel:model.level];
    
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_icon"]];
        [_iconView.layer setCornerRadius:50];
        [_iconView setClipsToBounds:YES];
    }
    return _iconView;
}

- (UIImageView *)shadeView
{
    if (!_shadeView) {
        _shadeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar_mask_write"]];
    }
    return _shadeView;
}


- (UILabel *)nikeNameLbl
{
    if (!_nikeNameLbl) {
        _nikeNameLbl = [UILabel setLabel:_nikeNameLbl text:@"用户名" font:[UIFont themeFontOfSize:18] textColor:[UIColor colorLightBlack_2e2e2e]];
        [_nikeNameLbl setTextAlignment:NSTextAlignmentCenter];
        
    }
    return _nikeNameLbl;
}

- (TrainStrengthView *)strengView
{
    if (!_strengView) {
        _strengView = [[TrainStrengthView alloc]init];
        [_strengView setUserInteractionEnabled:NO];
    }
    return _strengView;
}
@end
