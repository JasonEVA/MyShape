//
//  TrainAddToMyTrainRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface TrainAddToMyTrainRequest : BaseRequest
@property (nonatomic, copy) NSString *myId;
@end

@interface TrainAddToMyTrainResponse : BaseResponse

@end