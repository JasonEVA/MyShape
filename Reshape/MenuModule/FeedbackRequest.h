//
//  FeedbackRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/8.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"

@interface FeedbackRequest : BaseRequest
@property (nonatomic, copy) NSString *content;
@end

@interface FeedbackResponse : BaseResponse

@end