//
//  MyTrainDeleteVideoRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainDeleteVideoRequest.h"

@implementation MyTrainDeleteVideoRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"UserTrainingVideo/Delete";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainDeleteVideoResponse *response = [[MyTrainDeleteVideoResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    return response;
}
@end

@implementation MyTrainDeleteVideoResponse



@end