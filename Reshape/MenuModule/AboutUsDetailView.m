//
//  AboutUsDetailView.m
//  Reshape
//
//  Created by jasonwang on 15/12/10.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AboutUsDetailView.h"
#import "UILabel+EX.h"
#import <Masonry/Masonry.h>

@interface AboutUsDetailView()
@property (nonatomic, strong) UILabel *whatCanDoTitel;
@property (nonatomic, strong) UILabel *whatCanDoInfo;
@property (nonatomic, strong) UILabel *whatCanDoDetail;

@property (nonatomic, strong) UILabel *contactUsTitel;
@property (nonatomic, strong) UILabel *contactUsInfo;
@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *url;
@end

@implementation AboutUsDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:5];
        [self configElements];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    [self addSubview:self.whatCanDoDetail];
    [self addSubview:self.whatCanDoTitel];
    [self addSubview:self.whatCanDoInfo];
    [self addSubview:self.contactUsInfo];
    [self addSubview:self.contactUsTitel];
    [self addSubview:self.phoneNum];
    [self addSubview:self.url];
    [self configConstraints];
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)configConstraints
{
    [self.whatCanDoTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.whatCanDoInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whatCanDoTitel.mas_bottom).offset(9);
        make.left.equalTo(self.whatCanDoTitel);
    }];
    
    [self.whatCanDoDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whatCanDoInfo.mas_bottom).offset(14);
        make.left.equalTo(self.whatCanDoTitel);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.contactUsTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whatCanDoDetail.mas_bottom).offset(30);
        make.left.equalTo(self.whatCanDoTitel);
    }];
    
    [self.contactUsInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactUsTitel.mas_bottom).offset(9);
        make.left.equalTo(self.whatCanDoTitel);
    }];
    
    [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactUsInfo.mas_bottom).offset(14);
        make.left.equalTo(self.whatCanDoTitel);
    }];
    
    [self.url mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNum.mas_bottom).offset(7);
        make.left.equalTo(self.whatCanDoTitel);
    }];
}
#pragma mark - init UI

- (UILabel *)whatCanDoInfo
{
    if (!_whatCanDoInfo) {
        _whatCanDoInfo = [UILabel setLabel:_whatCanDoInfo text:@"它能让您瘦成一道闪电!" font:[UIFont themeFontOfSize:13] textColor:[UIColor colorWithHex:0xadadad]];
    }
    return _whatCanDoInfo;
}

- (UILabel *)whatCanDoTitel
{
    if (!_whatCanDoTitel) {
        _whatCanDoTitel = [UILabel setLabel:_whatCanDoTitel text:@"Shape能做什么" font:[UIFont themeFontOfSize:18] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _whatCanDoTitel;
}

- (UILabel *)whatCanDoDetail
{
    if (!_whatCanDoDetail) {
        _whatCanDoDetail = [UILabel setLabel:_whatCanDoDetail text:@"Shape是您身边出色的健身教练,Shape是您身边出色的健身教练,Shape是您身边出色的健身教练,Shape是您身边出色的健身教练,Shape是您身边出色的健身教练,Shape是您身边出色的健身教练,Shape是您身边出色的健身教练" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorWithHex:0x707070]];
        [_whatCanDoDetail setNumberOfLines:0];
    }
    return _whatCanDoDetail;
}

- (UILabel *)contactUsTitel
{
    if (!_contactUsTitel) {
        _contactUsTitel = [UILabel setLabel:_contactUsTitel text:@"联系我们" font:[UIFont themeFontOfSize:18] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _contactUsTitel;
}

- (UILabel *)contactUsInfo
{
    if (!_contactUsInfo) {
        _contactUsInfo = [UILabel setLabel:_contactUsInfo text:@"24小时,随时随地!" font:[UIFont themeFontOfSize:13] textColor:[UIColor colorWithHex:0xadadad]];
    }
    return _contactUsInfo;
}

- (UILabel *)phoneNum
{
    if (!_phoneNum) {
        _phoneNum = [UILabel setLabel:_phoneNum text:@"联系电话:400-559-558" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorWithHex:0x707070]];
    }
    return _phoneNum;
}

- (UILabel *)url
{
    if (!_url) {
        _url = [UILabel setLabel:_url text:@"市场合作:hi@shape.com" font:[UIFont themeFontOfSize:15] textColor:[UIColor colorWithHex:0x707070]];
    }
    return _url;
}

@end
