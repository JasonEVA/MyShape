//
//  MyTrainInfoRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainInfoRequest.h"
#import "MyDefine.h"
#import <MJExtension/MJExtension.h>
#import "MyTrainInfoModel.h"

@implementation MyTrainInfoRequest
- (void)prepareRequest
{
    self.action = @"User/GetUserInfo";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainInfoResponse *response = [[MyTrainInfoResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        MyTrainInfoModel *model = [MyTrainInfoModel mj_objectWithKeyValues:dict];
        response.model = model;
    }
    return response;
}
@end

@implementation MyTrainInfoResponse


@end
