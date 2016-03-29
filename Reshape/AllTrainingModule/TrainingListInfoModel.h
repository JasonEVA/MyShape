//
//  TrainingListInfoModel.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  训练列表信息model

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface TrainingListInfoModel : NSObject
@property (nonatomic, strong)  NSString  *trainingVideoId; //	训练视频Id	String
@property (nonatomic, strong)  NSString  *classifyName; //	分类名	String
@property (nonatomic, strong)  NSString  *name; //	训练名称	String
@property (nonatomic) BOOL isSelected; //	当前账户是否已选	String
@property (nonatomic, strong)  NSString  *consumeDescription; //	训练消耗描述	String
@property (nonatomic, strong)  NSString  *descriptionImage; //	训练背景图	String
@property (nonatomic) NSInteger videoTotalSeconds;  //时长
@end
