//
//  MyTrainAddPraiseRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainAddPraiseRequest.h"

@implementation MyTrainAddPraiseRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"TrainingVideo/AddPraise";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainAddPraiseResponse *response = [[MyTrainAddPraiseResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    
    return response;
}
@end

@implementation MyTrainAddPraiseResponse



@end