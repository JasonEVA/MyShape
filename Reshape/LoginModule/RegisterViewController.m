//
//  RegisterViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/30.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIColor+Hex.h"
#import "LoginInputView.h"
#import <Masonry/Masonry.h>
#import "UIImage+EX.h"
#import "GetCodeRequestDAL.h"
#import "RegisterRequestDAL.h"
#import "unifiedUserInfoManager.h"
#import "MeDetailsViewController.h"
#import "BaseNavigationViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FogetPasswordRequest.h"

@interface RegisterViewController ()<LoginInputViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) LoginInputView *phoneNum;  //电话号码框
@property (nonatomic, strong) LoginInputView *password;  //密码框
@property (nonatomic, strong) UIView *line;         //分割线
@property (nonatomic, strong) LoginInputView *verificationView;
@property (nonatomic, strong) UIButton *getVerificationBtn;
@property (nonatomic, strong) UIButton *finishBtn;

//倒计时
@property (nonatomic) NSInteger secondsCoundDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, copy)   NSMutableString *time;
@property (nonatomic, copy) NSString *verificationToken;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.isRegister ? @"注册" : @"忘记密码"];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self killTimer];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.password.textField resignFirstResponder];
    [self.phoneNum.textField resignFirstResponder];
    [self.verificationView.textField resignFirstResponder];
}
#pragma mark -private method
- (void)configElements {
    
    [self.view addSubview:self.password];
    [self.view addSubview:self.phoneNum];
    [self.view addSubview:self.verificationView];
    [self.view addSubview:self.getVerificationBtn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.finishBtn];
    
    [self configConstraints];
    
}

//倒计时方法，
- (void)timeFireMethod
{
    self.secondsCoundDown --;
    //更新按钮倒计时时间
    self.time = [NSMutableString stringWithFormat:@"(%lds)后重发",(long)self.secondsCoundDown];
    [self.getVerificationBtn setTitle:self.time forState:UIControlStateDisabled];
    
    if (self.secondsCoundDown == 0) {
        [self killTimer];
    }
    
    //NSLog(@"%ld",(long)self.secondsCoundDown);
    
    
}

- (void)killTimer
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    //设置按钮可点击
    [self.getVerificationBtn setEnabled:YES];
    
    [self.getVerificationBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
}

//检查数据完整性
- (BOOL)isDataCompletion
{
    bool isOK = NO;
            if (self.phoneNum.textField.text.length > 0 && self.password.textField.text.length > 0 && self.verificationView.textField.text.length > 0) {
            isOK = YES;
        }
    return isOK;
}


#pragma mark - event Response
- (void)finishClick
{
    if ([self isDataCompletion]) {
        if (self.isRegister) {
            //注册请求
            RegisterRequestDAL *request = [[RegisterRequestDAL alloc]init];
            request.phone = self.phoneNum.textField.text;
            request.password = self.password.textField.text;
            request.code = self.verificationView.textField.text;
            request.codeToken = self.verificationToken;
            [request requestWithDelegate:self];
        } else {
            //忘记密码请求
            FogetPasswordRequest *request = [[FogetPasswordRequest alloc] init];
            request.phone = self.phoneNum.textField.text;
            request.password = self.password.textField.text;
            request.code = self.verificationView.textField.text;
            request.codeToken = self.verificationToken;
            [request requestWithDelegate:self];
        }
        
        [self postLoading];
    } else {
        [self postError:@"数据不完整"];
    }
}

//获取验证码监听
- (void)getTestClick
{
    if (self.phoneNum.textField.text.length > 0) {
        
        //设置按钮不可点击
        [self.getVerificationBtn setEnabled:NO];
        //设置计时器
        self.secondsCoundDown = 60;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        //发出网络请求
        GetCodeRequestDAL *request = [[GetCodeRequestDAL alloc] init];
        [request prepareRequest];
        request.phone = self.phoneNum.textField.text;
        [request requestWithDelegate:self];
    }
    else
    {
        [self postError:@"请输入手机号" duration:1];
    }
    
    
}

- (void)LoginInputViewDelegateCallBack_statrEditing:(LoginInputView *)view
{
    CGRect frame = view.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)LoginInputViewDelegateCallBack_endEditing:(LoginInputView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
        
    }];
}

#pragma mark - request Delegate
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
    [self hideLoading];
    [self postError:response.message];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
    if ([response isKindOfClass:[GetCodeResponse class]]) {
        GetCodeResponse *result = (GetCodeResponse *)response;
        self.verificationToken = result.codeToken;
    }
    else if ([response isKindOfClass:[RegisterResponse class]])
    {
        RegisterResponse *result = (RegisterResponse *)response;
        [[[unifiedUserInfoManager alloc] init] saveLoginResultModel:result.loginModel];
        
        if (result.loginModel.token.length > 0) {
            // 创建数据库
            [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/%@/Shape.Sqlite",result.loginModel.phone]];
        }

        [self postSuccess:@"注册成功"];
        
        MeDetailsViewController *VC = [[MeDetailsViewController alloc] init];
        VC.isFirst = YES;
        BaseNavigationViewController *navVC = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
        [self presentViewController:navVC animated:YES completion:nil];
        
    } else if ([response isKindOfClass:[FogetPasswordResponse class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - updateViewConstraints

- (void)configConstraints
{
    [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(36);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNum.mas_bottom).offset(25);
        make.left.right.height.equalTo(self.phoneNum);
    }];
    
    [self.verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(25);
        make.left.height.equalTo(self.phoneNum);
        make.right.equalTo(self.view.mas_centerX).offset(8);
    }];
    
    [self.getVerificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.verificationView);
        make.right.equalTo(self.password);
        make.left.equalTo(self.verificationView.mas_right).offset(25);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.password);
        make.top.equalTo(self.verificationView.mas_bottom).offset(25);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(25);
        make.left.right.height.equalTo(self.password);
    }];

}

#pragma mark - init UI

- (LoginInputView *)phoneNum
{
    if (!_phoneNum) {
        _phoneNum = [[LoginInputView alloc]initWithImageName:@"login_user"hightLightImgName:@"" placeHoderText:@"输入手机号码"];
        [_phoneNum.textField setKeyboardType:UIKeyboardTypeNumberPad];
        [_phoneNum.layer setCornerRadius:10.0];
        [_phoneNum setDelegate:self];
    }
    return _phoneNum;
}

- (LoginInputView *)password
{
    if (!_password) {
        _password = [[LoginInputView alloc]initWithImageName:@"login_passwordicon" hightLightImgName:@"" placeHoderText:self.isRegister ? @"设置密码" : @"设置新密码"];
        [_password.textField setSecureTextEntry:YES];
        [_password.layer setCornerRadius:10.0];
        [_password setDelegate:self];
    }
    return _password;
}

- (LoginInputView *)verificationView
{
    if (!_verificationView) {
        _verificationView = [[LoginInputView alloc]initWithImageName:@"" hightLightImgName:@"" placeHoderText:@"输入验证码"];
        [_verificationView.layer setCornerRadius:10.0];
        [_verificationView.textField setKeyboardType:UIKeyboardTypeNumberPad];
        [_verificationView setDelegate:self];
    }
    return _verificationView;
}

- (UIButton *)getVerificationBtn
{
    if (!_getVerificationBtn) {
        _getVerificationBtn = [[UIButton alloc] init];
        [_getVerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerificationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x767676] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_getVerificationBtn.layer setCornerRadius:10.0];
        [_getVerificationBtn setClipsToBounds:YES];
        [_getVerificationBtn addTarget:self action:@selector(getTestClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVerificationBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc]init];
        [_line setBackgroundColor:[UIColor colorWithHex:0xcecece]];
    }
    return _line;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc]init];
        [_finishBtn setBackgroundImage:[UIImage imageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn.layer setCornerRadius:10.0];
        [_finishBtn setClipsToBounds:YES];
        [_finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
- (NSString *)verificationToken
{
    if (!_verificationToken) {
        _verificationToken = [[NSString alloc] init];
    }
    return _verificationToken;
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
