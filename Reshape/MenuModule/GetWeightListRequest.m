//
//  GetWeightListRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "GetWeightListRequest.h"
#import "WeightListModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kpageSize = @"pageSize"; // 	页容量	Int	非必填	默认为10
static NSString *const kpageIndex = @"pageIndex"; // 	页编号	Int	非必填	默认为1
@implementation GetWeightListRequest

- (void)prepareRequest {
    self.action = @"User/GetWeightRecordsPage";
    self.params[kpageSize] = @(self.pageSize);
    self.params[kpageIndex] = @(self.pageIndex);
    
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data {
    GetWeightListResponse *response = [[GetWeightListResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        WeightListModel *model = [WeightListModel mj_objectWithKeyValues:dict];
        response.listModel = model;
    }
    return response;
}

@end

@implementation GetWeightListResponse


@end
