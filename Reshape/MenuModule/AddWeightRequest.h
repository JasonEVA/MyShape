//
//  AddWeightRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"

@interface AddWeightRequest : BaseRequest
@property (nonatomic) CGFloat weight;
@end

@interface AddWeightResponse : BaseResponse

@end