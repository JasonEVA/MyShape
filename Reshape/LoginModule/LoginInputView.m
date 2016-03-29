//
//  InputView.m
//  Shape
//
//  Created by jasonwang on 15/10/28.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "LoginInputView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UITextField+EX.h"

@interface LoginInputView()<UITextFieldDelegate>


@end

@implementation LoginInputView

- (instancetype)initWithImageName:(NSString *)imageName hightLightImgName:(NSString *)hightLightImgName placeHoderText:(NSString *)placeHoderText
{
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self.layer setBorderWidth:0.5f];
        [self.layer setBorderColor:[UIColor colorWithHex:0x7a7977].CGColor];
        [self addSubview:self.myImageView];
        [self addSubview:self.textField];
        if ([imageName isEqualToString:@""]) {
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-5);
                make.height.equalTo(self);
            }];
        }
        else{
            [self.myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self).offset(15);
                make.width.mas_equalTo(18);
            }];
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.myImageView.mas_right).offset(18);
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-5);
                make.height.equalTo(self);
            }];

        }
    
        
        [self.myImageView setImage:[UIImage imageNamed:imageName]];
        [self.myImageView setHighlightedImage:[UIImage imageNamed:hightLightImgName]];
        [self.textField setPlaceholder:placeHoderText];
        


    }
    return  self;
}

//设置选中方法
//- (void)setStatus:(BOOL)isSelect
//{
//    if (isSelect) {
//        [self.layer setBorderWidth:0.5f];
//        [self.textField setTextColor:[UIColor whiteColor]];
//        [self.myImageView setHighlighted:YES];
//    }
//    else
//    {
//        [self.layer setBorderWidth:0];
//        [self.textField setTextColor:[UIColor colorLightGray_898888]];
//        [self.myImageView setHighlighted:NO];
//
//    }
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(LoginInputViewDelegateCallBack_statrEditing:)]) {
        [self.delegate LoginInputViewDelegateCallBack_statrEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(LoginInputViewDelegateCallBack_endEditing:)]) {
        [self.delegate LoginInputViewDelegateCallBack_endEditing:self];
    }
    return YES;
}
#pragma mark - init UI

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc]init];
    }
    return _myImageView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField setTxfData:_textField placeholder:@"1" placeholderColor:[UIColor colorWithHex:0x7f7f7f] textColor:[UIColor colorGray_525252] delegate:self keyboard:UIKeyboardTypeDefault];
    }
    return _textField;
}

@end
