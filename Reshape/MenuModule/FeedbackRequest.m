//
//  FeedbackRequest.m
//  Reshape
//
//  Created by jasonwang on 15/12/8.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "FeedbackRequest.h"
static NSString *const kContent = @"content";

@implementation FeedbackRequest
- (void)prepareRequest
{
    [super prepareRequest];
    self.action = @"Feedback/Add";
    self.params[kContent] = self.content;
    
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    FeedbackResponse *response = [[FeedbackResponse alloc] init];
    response.message = [super prepareResponse:data].message;
    return response;
}
@end

@implementation FeedbackResponse



@end