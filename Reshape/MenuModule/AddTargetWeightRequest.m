//
//  AddTargetWeightRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AddTargetWeightRequest.h"

@implementation AddTargetWeightRequest
- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"User/SetTargetWeight";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    AddTargetWeightResponse *reponse = [[AddTargetWeightResponse alloc] init];
    reponse.message = [super prepareResponse:data].message;
    return reponse;
}
@end

@implementation AddTargetWeightResponse


@end