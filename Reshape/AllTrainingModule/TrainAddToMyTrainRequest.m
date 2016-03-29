//
//  TrainAddToMyTrainRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainAddToMyTrainRequest.h"

static NSString *const kID = @"ID";

@implementation TrainAddToMyTrainRequest
- (void)prepareRequest {
    self.action = @"UserTrainingVideo/Add";
    self.params[kID] = self.myId;
    [super prepareRequest];
    
}
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainAddToMyTrainResponse *resonse = [[TrainAddToMyTrainResponse alloc] init];
    resonse.message = [super prepareResponse:data].message;
    return resonse;
}
@end

@implementation TrainAddToMyTrainResponse

@end