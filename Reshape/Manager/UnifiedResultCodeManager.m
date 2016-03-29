//
//  UnifieldResultCodeManager.m
//  PalmDoctorDR
//
//  Created by Lars Chen on 15/4/15.
//  Copyright (c) 2015年 jasonwang. All rights reserved.
//

#import "UnifiedResultCodeManager.h"
#import "MyDefine.h"
#import "NSDictionary+SafeManager.h"
#import "unifiedUserInfoManager.h"

static NSString *const kCode = @"code";
static NSString *const kMessage = @"message";

@interface UnifiedResultCodeManager (){
    UIAlertView *alertView;
}

@end

@implementation UnifiedResultCodeManager

+(UnifiedResultCodeManager *)share
{
    static UnifiedResultCodeManager *resultCodeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resultCodeManager = [[UnifiedResultCodeManager alloc] init];

    });
    return resultCodeManager;
}

- (BOOL)manageResultCode:(NSDictionary *)dictResult
{
    NSInteger resultCode = [[dictResult safeValueForKey:kCode] integerValue];

    BOOL isSucess = NO;
    NSInteger module = resultCode / 1000;
    switch (module)
    {
        case 1:
            //
            
            break;
            
        case 2:
            // 操作成功
            isSucess = YES;
            break;
            
        case 3:
            // 重新登录
            [self errorNeedLoginWithCode:resultCode];
            break;
            
        case 4:
            // 错误
            break;
            
        default:
            // 失败
            break;
    }

    return isSucess;
}

#pragma mark - 分模块处理
// 操作成功但需要客户端进行操作1
- (void)successWithHandle:(NSInteger)code requestID:(NSString *)strId
{
}

// 操作失败
- (void)errorNeedLoginWithCode:(NSInteger)code
{
    NSString *message = @"请登录";
    switch (code) {
        case 3000:
            message = @"长时间未登录，请重新登录";
            break;
            
        case 3001:
            message = @"此操作需要登录，请登录";
            break;
            
        default:
            break;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloginWithMessage:) object:nil];
    [self performSelector:@selector(reloginWithMessage:) withObject:message afterDelay:1];
 }

- (void)reloginWithMessage:(NSString *)message {
    // 重新登录
    if(alertView){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView=nil;
    }
    alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:n_showLogin object:nil];
}
@end
