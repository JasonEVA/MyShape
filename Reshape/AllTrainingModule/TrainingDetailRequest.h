//
//  TrainingDetailRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
// 训练详情Request

#import "BaseRequest.h"
@class TrainingDetailModel;

@interface TrainingDetailRequest : BaseRequest
@property (nonatomic, strong)  NSString  *ID; // <##>
@end

@interface TrainingDetailResponse : BaseResponse
@property (nonatomic, strong)  TrainingDetailModel  *detailModel; // <##>
@end