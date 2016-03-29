//
//  FogetPasswordRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "FogetPasswordRequest.h"

@implementation FogetPasswordRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"Account/ForgetPassword";
}
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    FogetPasswordResponse *response = [[FogetPasswordResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    return response;
}

@end

@implementation FogetPasswordResponse


@end