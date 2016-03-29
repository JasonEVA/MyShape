//
//  GetLevelRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "GetLevelRequest.h"
#import <MJExtension/MJExtension.h>

@implementation GetLevelRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"Other/HierarchyRules";
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetLevelResponse *response = [[GetLevelResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.modelArr = [LevelModel mj_objectArrayWithKeyValuesArray:dict];
    }
    return response;
}
@end

@implementation GetLevelResponse



@end