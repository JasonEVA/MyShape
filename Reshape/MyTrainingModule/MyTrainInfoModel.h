//
//  MyTrainInfoModel.h
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTrainInfoModel : NSObject
@property (nonatomic, copy) NSString *userName;	//用户名	String
@property (nonatomic, copy) NSString *headIcon;	//头像	String
@property (nonatomic, copy) NSString *location;	//所在地	String
@property (nonatomic) long long birthdateTimeStamp;//出生日期	DateTime
@property (nonatomic) NSInteger height;	//身高	Int
@property (nonatomic) NSInteger weight;	//体重	Double
@property (nonatomic) NSInteger gender;	//性别	Enum	1 (man):男
@property (nonatomic) NSInteger level;	//等级	Int
@property (nonatomic) NSInteger totalTrainingMinutes;	//总训练时长（分）	Int
@property (nonatomic) NSInteger totalTrainingTimes;	//总训练次数	Int
@property (nonatomic) NSInteger totalTrainingDays;	//总训练天数	Int
@property (nonatomic) NSInteger totalConsume;	//总训练消耗	Int
@property (nonatomic) NSInteger currentDays;	//持续训练天数	Int
@property (nonatomic) NSInteger maxDays;	//最大持续训练天数	Int
@end
