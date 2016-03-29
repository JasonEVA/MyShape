//
//  LoginViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginInputView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UILabel+EX.h"
#import "RegisterViewController.h"
#import "UIImage+EX.h"
#import "LoginRequestDAL.h"
#import "unifiedUserInfoManager.h"
#import <MagicalRecord/MagicalRecord.h>
#define ViewHeight  self.view.frame.size.height

@interface LoginViewController()<UIScrollViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) LoginInputView *phoneNum;  //电话号码框
@property (nonatomic, strong) LoginInputView *password;  //密码框
@property (nonatomic, strong) UIButton *loginBtn;     //登录按钮
@property (nonatomic, strong) UIView *line;         //分割线
@property (nonatomic, strong) UIButton *forgetPassword;  //忘记密码
@property (nonatomic, strong) UIButton *myRegister;     //注册
@property (nonatomic, strong) UIView *thirdView;      //第三方的View
@property (nonatomic, strong) UIButton *weixinLoginBtn;    //微信登录
@property (nonatomic, strong) UIButton *closeBtn;        //先逛逛
@property (nonatomic, strong) UIView *line1;          //分割线

@property (nonatomic, strong) UIScrollView *bgView;   //背景图
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UITapGestureRecognizer *tapTouch;

@end

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    [rightBtn setTintColor:[UIColor themeOrange_ff5d2b]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.bgView];
    
    //[self.bgView addSubview:self.thirdView];
    [self.bgView addSubview:self.logoView];
    [self.bgView addSubview:self.password];
    [self.bgView addSubview:self.phoneNum];
    [self.bgView addSubview:self.loginBtn];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.forgetPassword];
    [self.bgView addSubview:self.myRegister];
    
//    [self.thirdView addSubview:self.line1];
//    [self.thirdView addSubview:self.weixinLoginBtn];
//    [self.thirdView addSubview:self.closeBtn];
    
    [self configViewConstraints];
}

- (void)configViewConstraints
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bgView).offset(ViewHeight * 0.04);
    }];
    
    [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(ViewHeight * 0.04);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNum.mas_bottom).offset(25);
        make.left.right.height.equalTo(self.phoneNum);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(25);
        make.left.right.height.equalTo(self.phoneNum);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.forgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.right.equalTo(self.line.mas_left).offset(-35);
    }];
    
    [self.myRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.left.equalTo(self.line.mas_right).offset(35);
    }];
    
//    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(ViewHeight * 0.27);
//        make.top.equalTo(self.forgetPassword.mas_bottom).offset(40);
//        make.bottom.equalTo(self.bgView);
//
//    }];
    
//    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).offset(-30);
//        make.left.equalTo(self.view).offset(30);
//        make.height.mas_equalTo(1);
//        make.centerY.equalTo(self.thirdView);
//    }];
//    
//    [self.weixinLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.thirdView).offset(- ViewHeight * 0.27 * 0.25);
//        make.height.mas_equalTo(75);
//        make.width.mas_equalTo(400);
//    }];
//    
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.thirdView).offset(ViewHeight * 0.27 * 0.25);
//        make.height.mas_equalTo(75);
//        make.width.mas_equalTo(400);
//    }];

}

//检查数据完整性
- (BOOL)isDataCompletion
{
    bool isOK = NO;
   
        if (self.phoneNum.textField.text.length > 0 && self.password.textField.text.length > 0) {
            isOK = YES;
        }
    return isOK;
}

#pragma mark - event Response
//登录点击
- (void)loginClick
{
    if ([self isDataCompletion]) {
        //登录按钮监听
        NSLog(@"点击登录了");
        LoginRequestDAL *request = [[LoginRequestDAL alloc]init];
        [request prepareRequest];
        request.phone = self.phoneNum.textField.text;
        request.password = self.password.textField.text;
        [request requestWithDelegate:self];
        [self postLoading];

    } else {
        [self postError:@"数据不完整"];
    }
}
//忘记密码
- (void)forgetClick
{
    RegisterViewController *VC = [[RegisterViewController alloc] init];
    VC.isRegister = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
//立即注册
- (void)registerClick
{
    RegisterViewController *VC = [[RegisterViewController alloc] init];
    VC.isRegister = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

//关闭
- (void)closeClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resignFirstRsp
{
    //隐藏键盘
    [self.phoneNum.textField resignFirstResponder];
    [self.password.textField resignFirstResponder];
    
}

#pragma mark - request Delegate
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
    [self hideLoading];
     LoginResponse *result = (LoginResponse *)response;
    [self postError:result.message];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
    LoginResponse *result = (LoginResponse *)response;
    [[[unifiedUserInfoManager alloc] init] saveLoginResultModel:result.resultModel];
    LoginResultModel *loginModel = [[unifiedUserInfoManager share] getLoginResultData];
    if (loginModel.token.length > 0) {
        // 创建数据库
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/%@/Shape.Sqlite",loginModel.phone]];
    }

    [self postSuccess:@"登录成功"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - updateViewConstraints

#pragma mark - init UI


- (LoginInputView *)phoneNum
{
    if (!_phoneNum) {
        _phoneNum = [[LoginInputView alloc]initWithImageName:@"login_user"hightLightImgName:@"" placeHoderText:@"手机号码"];
        [_phoneNum.textField setKeyboardType:UIKeyboardTypeNumberPad];
        [_phoneNum.layer setCornerRadius:10.0];
    }
    return _phoneNum;
}

- (LoginInputView *)password
{
    if (!_password) {
        _password = [[LoginInputView alloc]initWithImageName:@"login_passwordicon" hightLightImgName:@"" placeHoderText:@"密码"];
        [_password.textField setSecureTextEntry:YES];
        [_password.layer setCornerRadius:10.0];
    }
    return _password;
}


- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn.layer setCornerRadius:10.0];
        [_loginBtn setClipsToBounds:YES];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc]init];
        [_line setBackgroundColor:[UIColor colorWithHex:0xcecece]];
    }
    return _line;
}

- (UIButton *)forgetPassword
{
    if (!_forgetPassword) {
        _forgetPassword = [[UIButton alloc]init];
        [_forgetPassword setTitleColor:[UIColor colorWithHex:0x737373] forState:UIControlStateNormal];
        [_forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPassword addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
         [_forgetPassword setTitleColor:[UIColor colorLightBlack_2e2e2e] forState:UIControlStateHighlighted];
    }
    return _forgetPassword;
}

- (UIButton *)myRegister
{
    if (!_myRegister) {
        _myRegister = [[UIButton alloc]init];
        [_myRegister setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateNormal];
        [_myRegister setTitleColor:[UIColor colorLightBlack_2e2e2e] forState:UIControlStateHighlighted];
        [_myRegister setTitle:@"立即注册" forState:UIControlStateNormal];
        [_myRegister addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myRegister;
}


- (UIView *)thirdView
{
    if (!_thirdView) {
        _thirdView = [[UIView alloc] init];
        [_thirdView setBackgroundColor:[UIColor colorWithHex:0xe6e2db]];
    }
    return _thirdView;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        [_line1 setBackgroundColor:[UIColor colorWithHex:0xc3bfb8]];
    }
    return _line1;
}

- (UIButton *)weixinLoginBtn
{
    if (!_weixinLoginBtn) {
        _weixinLoginBtn = [[UIButton alloc] init];
        [_weixinLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_weixinLoginBtn setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
        [_weixinLoginBtn setTitle:@"用微信登录" forState:UIControlStateNormal];
        [_weixinLoginBtn setTitleColor:[UIColor colorWithHex:0x737373] forState:UIControlStateNormal];
        [_weixinLoginBtn setTitleColor:[UIColor colorLightBlack_2e2e2e] forState:UIControlStateHighlighted];
    }
    return _weixinLoginBtn;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_closeBtn setImage:[UIImage imageNamed:@"login_arrow"] forState:UIControlStateNormal];
        [_closeBtn setTitle:@"先逛逛再说" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithHex:0x737373] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setTitleColor:[UIColor colorLightBlack_2e2e2e] forState:UIControlStateHighlighted];
    }
    return _closeBtn;
}

- (UIScrollView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
        [_bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
        [_bgView addGestureRecognizer:self.tapTouch];
        [_bgView setScrollEnabled:YES];
        [_bgView setContentSize:CGSizeMake(self.view.frame.size.width, 570)];
        [_bgView setShowsVerticalScrollIndicator:NO];
        [_bgView setShowsHorizontalScrollIndicator:NO];
        [_bgView setDelegate:self];
        [_bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _bgView;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_shape"]];
    }
    return _logoView;
}

- (UITapGestureRecognizer *)tapTouch
{
    if (!_tapTouch) {
        _tapTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstRsp)];
    }
    return _tapTouch;
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
