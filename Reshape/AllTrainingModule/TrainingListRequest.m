//
//  TrainingListRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingListRequest.h"
#import "UrlInterfaceDefine.h"
#import "TrainingListModel.h"

static NSString *const kpageSize = @"pageSize"; // 	页容量	Int	非必填	默认为10
static NSString *const kpageIndex = @"pageIndex"; // 	页编号	Int	非必填	默认为1
@implementation TrainingListRequest

- (void)prepareRequest {
    self.action = @"TrainingVideo/GetPage";
    self.params[kpageSize] = @(self.pageSize);
    self.params[kpageIndex] = @(self.pageIndex);
    
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data {
    TrainingListResponse *response = [[TrainingListResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        TrainingListModel *model = [TrainingListModel mj_objectWithKeyValues:dict];
        response.listModel = model;
    }
    return response;
}

@end

@implementation TrainingListResponse


@end