//
//  MeChangeUserInfoRequest.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"
#import "MyTrainInfoModel.h"

@interface MeChangeUserInfoRequest : BaseRequest

@property (nonatomic, strong) MyTrainInfoModel *model;

@end

@interface MeChangeUserInfoResponse : BaseResponse

@end