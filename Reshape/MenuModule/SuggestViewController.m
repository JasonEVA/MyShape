//
//  SuggestViewController.m
//  Reshape
//
//  Created by jasonwang on 15/12/8.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "SuggestViewController.h"
#import "UIImage+EX.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "FeedbackRequest.h"

@interface SuggestViewController ()<UITextViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong)  UITextView *textView;
@property (nonatomic, strong)  UIButton *button;
@property (nonatomic, strong)  UILabel *placeHoderLb;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"意见反馈"];
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button];
    [self.view addSubview:self.placeHoderLb];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
    }];
    
    [self.placeHoderLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(11);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeHoderLb.text = @"写下您的宝贵意见......";
    }else{
        self.placeHoderLb.text = @"";
    }
}

- (void)finishClick
{
    FeedbackRequest *request = [[FeedbackRequest alloc] init];
    request.content = self.textView.text;
    [request requestWithDelegate:self];
    [self postLoading];
}


- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    [self postError:response.message];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [_textView setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [_textView setFont:[UIFont systemFontOfSize:20]];
        [_textView setDelegate:self];
//        [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _textView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"提交" forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_button.layer setCornerRadius:5];
        [_button setClipsToBounds:YES];
        [_button addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside
         ];    }
    return _button;
}

- (UILabel *)placeHoderLb
{
    if (!_placeHoderLb) {
        _placeHoderLb = [[UILabel alloc] init];
        [_placeHoderLb setText:@"写下您的宝贵意见......"];
        [_placeHoderLb setTextColor:[UIColor colorWithHex:0x828282]];
    }
    return _placeHoderLb;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
