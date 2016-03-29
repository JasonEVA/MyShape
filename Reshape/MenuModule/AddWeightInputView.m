//
//  AddWeightInputView.m
//  Reshape
//
//  Created by jasonwang on 15/12/8.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AddWeightInputView.h"
#import "UILabel+EX.h"
#import <Masonry/Masonry.h>

@interface AddWeightInputView ()<UITextFieldDelegate>
@end
@implementation AddWeightInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHex:0x0e0e0e alpha:0.5]];
        [self addSubview:self.myView];
        UITapGestureRecognizer *hideViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewClick)];
        [self addGestureRecognizer:hideViewTap];
        
        [self.myView addSubview:self.titelLb];
        [self.myView addSubview:self.inputTxf];
        [self.myView addSubview:self.saveBtn];
        [self.myView addSubview:self.line];
        
        [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(34);
            make.right.equalTo(self).offset(-34);
            make.height.equalTo(@205);
            make.top.equalTo(self).offset(155 + 64);
        }];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myView).offset(18);
            make.centerX.equalTo(self.myView);
        }];
        
        [self.inputTxf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myView).offset(25);
            make.right.equalTo(self.myView).offset(-25);
            make.top.equalTo(self.titelLb.mas_bottom).offset(25);
            make.height.equalTo(@50);
        }];
        
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.myView);
            make.height.equalTo(@50);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.saveBtn.mas_top);
            make.height.equalTo(@1);
            make.right.equalTo(self.myView).offset(-20);
            make.left.equalTo(self.myView).offset(20);
        }];
    }
    return self;
}

- (void)hideViewClick
{
    [self setHidden:YES];
    [self.inputTxf resignFirstResponder];
}

- (void)resignFirstResponderClick
{
    [self.inputTxf resignFirstResponder];
}

- (void)saveClick
{
    if ([self.delegate respondsToSelector:@selector(AddWeightInputViewDelegateCallBack_saveClick)]) {
        [self.delegate AddWeightInputViewDelegateCallBack_saveClick];
    }
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"最新体重" font:[UIFont themeFontOfSize:20] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _titelLb;
}

- (UITextField *)inputTxf
{
    if (!_inputTxf) {
        _inputTxf = [[UITextField alloc] init];
        [_inputTxf setTextAlignment:NSTextAlignmentCenter];
        [_inputTxf.layer setBorderWidth:1];
        [_inputTxf.layer setBorderColor:[UIColor colorWithHex:0xe0e0e0].CGColor];
        [_inputTxf setPlaceholder:@"KG"];
        [_inputTxf setKeyboardType:UIKeyboardTypeNumberPad];
        [_inputTxf.layer setCornerRadius:5];
        [_inputTxf setDelegate:self];
        _inputTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _inputTxf;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor colorWithHex:0x8e8e8e] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return _saveBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor colorWithHex:0xe0e0e0]];
    }
    return _line;
}
- (UIView *)myView
{
    if (!_myView) {
        _myView = [[UIView alloc] init];
        [_myView setBackgroundColor:[UIColor whiteColor]];
        [_myView.layer setCornerRadius:5];
        UITapGestureRecognizer *resignFirstResponderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderClick)];
        [_myView addGestureRecognizer:resignFirstResponderTap];
    }
    return _myView;
}



@end
