//
//  MyTrainAddRecordRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainAddRecordRequest.h"

@implementation MyTrainAddRecordRequest
- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"UserTrainingVideo/AddRecord";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainAddRecordResponse *response = [[MyTrainAddRecordResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    return response;
}

@end

@implementation MyTrainAddRecordResponse



@end