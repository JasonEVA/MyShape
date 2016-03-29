//
//  GetLevelRequest.h
//  Reshape
//
//  Created by jasonwang on 15/12/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"
#import "LevelModel.h"

@interface GetLevelRequest : BaseRequest

@end

@interface GetLevelResponse : BaseResponse

@property (nonatomic, copy) NSArray <LevelModel *> *modelArr;

@end