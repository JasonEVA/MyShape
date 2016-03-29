//
//  switchView.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//
#import "switchView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "UIFont+EX.h"

#define Radius          5
#define CENTERX         self.frame.size.width / 2
#define FONT            16


@interface switchView()

@property (nonatomic, strong) UIButton *titel;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation switchView

- (instancetype)initWithTitel:(NSString *)titel
{
    self = [super init];
    if (self) {
        self.selectBtn = self.openBtn;
        [self.titel setTitle:titel forState:UIControlStateNormal];
        if ([titel isEqualToString:@"清除缓存"]) {
            [self.line setHidden:YES];
            [self.openBtn setHidden:YES];
            [self.closeBtn setHidden:YES];
            [self.titel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [self.titel addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

        }

        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self addSubview:self.titel];
        [self addSubview:self.openBtn];
        [self addSubview:self.closeBtn];
        [self addSubview:self.line];
        
        [self.titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(55 + 2 * Radius);
            make.centerX.equalTo(self);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titel.mas_bottom).offset(15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self);
        }];
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.line);
            make.right.equalTo(self.line.mas_left).offset(-32);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.line);
            make.left.equalTo(self.line.mas_right).offset(32);
        }];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(CENTERX, Radius + 30) radius:Radius startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorGray_525252] setFill];
    [path fill];
}


- (void)click:(UIButton *)button
{
    if (![button isEqual:self.titel]) {
        [self.selectBtn setSelected:NO];
        
        if (button.tag == tag_open) {
            self.selectBtn = self.openBtn;
        }else
        {
            self.selectBtn = self.closeBtn;
        }
        
        [self.selectBtn setSelected:YES];
    }
    if ([self.delegate respondsToSelector:@selector(switchViewDelegateCallBack_click::)]) {
        [self.delegate switchViewDelegateCallBack_click:self.openBtn.selected:self];
    }
}
//根据保存信息设置开关状态
- (void)setSelectWithBool:(BOOL)isOpen
{
    if (isOpen) {
        [self.openBtn setSelected:YES];
        [self.closeBtn setSelected:NO];
        self.selectBtn =  self.openBtn;
    } else {
        [self.openBtn setSelected:NO];
        [self.closeBtn setSelected:YES];
        self.selectBtn =  self.closeBtn;
    }
}

- (UIButton *)titel
{
    if (!_titel) {
        _titel = [[UIButton alloc]init];
        [_titel setTitleColor:[UIColor colorGray_525252] forState:UIControlStateNormal];
        [_titel setTitle:@"使用流量时提醒我" forState:UIControlStateNormal];
        _titel.titleLabel.font = [UIFont themeFontOfSize:FONT];
    }
    return _titel;
}

- (UIButton *)openBtn
{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] init];
        [_openBtn setTitle:@"打开" forState:UIControlStateNormal];
        [_openBtn setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateSelected];
        [_openBtn setTitleColor:[UIColor colorMyLightGray_959595] forState:UIControlStateNormal];
        [_openBtn setSelected:YES];
         [_openBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_openBtn setTag:tag_open];
        _openBtn.titleLabel.font = [UIFont themeFontOfSize:FONT];
    }
    return _openBtn;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateSelected];
        [_closeBtn setTitleColor:[UIColor colorMyLightGray_959595] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setTag:tag_close];
         _closeBtn.titleLabel.font = [UIFont themeFontOfSize:FONT];
    }
    return _closeBtn;
}
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor lightGaryline_ebe9e6]];
    }
    return _line;
}
@end
