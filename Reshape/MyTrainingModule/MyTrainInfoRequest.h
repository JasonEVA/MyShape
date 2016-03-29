//
//  MyTrainInfoRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"
@class MyTrainInfoModel;

@interface MyTrainInfoRequest : BaseRequest

@end
@interface MyTrainInfoResponse : BaseResponse
@property (nonatomic, strong) MyTrainInfoModel *model;
@end
