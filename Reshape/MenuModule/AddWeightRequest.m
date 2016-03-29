//
//  AddWeightRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AddWeightRequest.h"

static NSString *const kWeight = @"weight";

@implementation AddWeightRequest
- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"User/AddWeightRecord";
    self.params[kWeight] = [NSNumber numberWithFloat:self.weight];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    AddWeightResponse *respose = [[AddWeightResponse alloc] init];
    respose.message = [super prepareResponse:data].message;
    return respose;
}
@end

@implementation AddWeightResponse



@end
