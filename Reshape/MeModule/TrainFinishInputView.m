//
//  TrainFinishInputView.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainFinishInputView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "StrengthLbView.h"
#import "unifiedUserInfoManager.h"
#import "LevelModel.h"

@interface TrainFinishInputView ()
@property (nonatomic, strong) StrengthLbView *lastView;
@property (nonatomic, strong) UIView *hideView;
@end

@implementation TrainFinishInputView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHex:0x0e0e0e alpha:0.5]];
        [self initComponent];
        [self configConstraints];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.hideView];
    [self.hideView addSubview:self.finishTitelLb];
    [self.hideView addSubview:self.imageView];
    [self.hideView addSubview:self.button];
    [self.hideView addSubview:self.line2];
    [self.hideView addSubview:self.line1];
}

- (void)click
{
    if ([self.delegate respondsToSelector:@selector(TrainFinishInputViewDelegate_callBack)]) {
        [self.delegate TrainFinishInputViewDelegate_callBack];
    }

}

#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

- (void)configConstraints
{
    [self.hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@310);
        make.centerY.equalTo(self);
    }];

    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hideView).offset(13);
        make.centerX.equalTo(self);
    }];
    
    [self.finishTitelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(6);
        make.centerX.equalTo(self.hideView);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hideView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.finishTitelLb.mas_bottom).offset(14);
    }];
    for (NSInteger i = 0; i < 5; i++) {
        StrengthLbView *view = [[StrengthLbView alloc] init];
        NSString *str = [[unifiedUserInfoManager share] getLevelInfo][i];
        [view setMyLevel:i+1 num:str.integerValue];

        [self.hideView addSubview:view];
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line1.mas_bottom).offset(13);
                make.centerX.equalTo(self.hideView);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lastView.mas_bottom).offset(13);
                make.left.equalTo(self.lastView);
                make.right.lessThanOrEqualTo(self.hideView);
            }];
        }
        
        self.lastView = view;
    }
    
    
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.hideView);
        make.height.equalTo(self.hideView).multipliedBy(0.124);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hideView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.button.mas_top);
    }];
    
}

#pragma mark - init UI

- (UILabel *)finishTitelLb
{
    if (!_finishTitelLb) {
        _finishTitelLb = [UILabel setLabel:_finishTitelLb text:@"就让我们瘦成一道闪电!" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHex:0xadadad]];
    }
    return _finishTitelLb;
}
- (UILabel *)imageView
{
    if (!_imageView) {
        _imageView = [UILabel setLabel:_finishTitelLb text:@"等级规则" font:[UIFont systemFontOfSize:20] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]init];
        [_button setTitle:@"我知道了" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithHex:0x6c6c6c] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        [_line1 setBackgroundColor:[UIColor lightGaryline_ebe9e6]];
    }
    return _line1;
}
- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        [_line2 setBackgroundColor:[UIColor lightGaryline_ebe9e6]];
    }
    return _line2;
}
- (UIView *)hideView
{
    if (!_hideView) {
        _hideView = [[UIView alloc] init];
        [_hideView setBackgroundColor:[UIColor whiteColor]];
        [_hideView.layer setCornerRadius:10];
    }
    return _hideView;
}
@end
