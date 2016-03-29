//
//  GetWeightListRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"

@class WeightListModel;
@interface GetWeightListRequest : BaseRequest
@property (nonatomic)  NSInteger  pageSize; // <##>
@property (nonatomic)  NSInteger  pageIndex; // <##>
@end

@interface GetWeightListResponse : BaseResponse
@property (nonatomic, strong)  WeightListModel  *listModel; // <##>
@end