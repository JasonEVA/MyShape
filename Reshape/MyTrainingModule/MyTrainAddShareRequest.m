//
//  MyTrainAddShareRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainAddShareRequest.h"

@implementation MyTrainAddShareRequest
- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"TrainingVideo/AddShare";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainAddShareResponse *response = [[MyTrainAddShareResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    return response;
}

@end

@implementation MyTrainAddShareResponse



@end