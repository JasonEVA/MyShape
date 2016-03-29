//
//  RegisterRequestDAL.m
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "RegisterRequestDAL.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

#define DICT_NAME          @"name"
#define DICT_PHONE         @"phone"
#define DICT_PASSWORD      @"password"
#define DICT_CODE          @"code"
#define DICT_CODETOKEN     @"verificationToken"

@implementation RegisterRequestDAL

- (void)prepareRequest
{
    self.action = @"Account/Register";
    self.params[DICT_NAME] = self.name;
    self.params[DICT_PHONE] = self.phone;
    self.params[DICT_PASSWORD] = self.password;
    self.params[DICT_CODE] = self.code;
    self.params[DICT_CODETOKEN] = self.codeToken;
    
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    RegisterResponse *response = [[RegisterResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        LoginResultModel *model = [LoginResultModel mj_objectWithKeyValues:dict];
        response.loginModel = model;
        
    }
    
    return response;
}


@end

@implementation RegisterResponse



@end
