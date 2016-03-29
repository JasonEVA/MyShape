//
//  MeTrainHistoryDetailModel.h
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeTrainHistoryDetailModel : NSObject

@property (nonatomic, copy)  NSString  *trainingVideoName;	//训练视频名	String
@property (nonatomic, copy)  NSString  *trainingVideoId;	//训练视频Id	5b6d63679d4c5b08
@property (nonatomic) NSInteger length;	//训练时长	Int	单位：分
@property (nonatomic) NSInteger consume;	//训练消耗	Int
@property (nonatomic, copy)  NSString  *recordTime;	//完成时间	DateTime
@property (nonatomic) long long recordTimeStamp;	//完成时间戳	Long	13位

@end
