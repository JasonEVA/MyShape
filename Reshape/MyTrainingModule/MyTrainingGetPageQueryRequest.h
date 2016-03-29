//
//  MyTrainingGetPageQueryRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainingListInfoModel.h"


@interface MyTrainingGetPageQueryRequest : BaseRequest
@property (nonatomic) NSInteger skip;
@property (nonatomic) NSInteger take;
@end

@interface MyTrainingGetPageQueryResponse : BaseResponse
@property (nonatomic, copy) NSMutableArray <TrainingListInfoModel *>*modelArr;

@end