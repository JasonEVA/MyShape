//
//  TrainingListRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  训练列表页

#import "BaseRequest.h"

@class TrainingListModel;
@interface TrainingListRequest : BaseRequest
@property (nonatomic)  NSInteger  pageSize; // <##>
@property (nonatomic)  NSInteger  pageIndex; // <##>
@end

@interface TrainingListResponse : BaseResponse
@property (nonatomic, strong)  TrainingListModel  *listModel; // <##>
@end