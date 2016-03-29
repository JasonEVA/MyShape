//
//  MyTrainingGetPageQueryRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingGetPageQueryRequest.h"
#import <MJExtension/MJExtension.h>

static NSString *const kSkip = @"skip";
static NSString *const kTake = @"take";

@implementation MyTrainingGetPageQueryRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"UserTrainingVideo/GetPageQuery";
    self.params[kSkip] = [NSNumber numberWithInteger:self.skip];
    self.params[kTake] = [NSNumber numberWithInteger:self.take];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MyTrainingGetPageQueryResponse *response = [[MyTrainingGetPageQueryResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.modelArr = [TrainingListInfoModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"pageItems"]];
    }

    return response;
}
@end

@implementation MyTrainingGetPageQueryResponse



@end