//
//  TrainingDetailRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingDetailRequest.h"
#import "TrainingDetailModel.h"

static NSString *const kID = @"id";
@implementation TrainingDetailRequest
- (void)prepareRequest {
    self.action = @"TrainingVideo/GetDetail";
    self.params[kID] = self.ID;
    
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data {
    TrainingDetailResponse *response = [[TrainingDetailResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        TrainingDetailModel *model = [TrainingDetailModel mj_objectWithKeyValues:dict];
        response.detailModel = model;
    }
    return response;
}

@end

@implementation TrainingDetailResponse



@end