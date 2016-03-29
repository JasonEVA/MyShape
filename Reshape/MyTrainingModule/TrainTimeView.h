//
//  TrainTimeView.h
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  训练时长 日均 消耗 View

#import <UIKit/UIKit.h>
#import "MyTrainInfoModel.h"

@interface TrainTimeView : UIView
@property (nonatomic, strong) UILabel *allTimeLb;
@property (nonatomic, strong) UILabel *allTimeNum;
@property (nonatomic, strong) UILabel *eachDayLb;
@property (nonatomic, strong) UILabel *eachDayNum;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) UILabel *costNum;
- (void)setMyData:(MyTrainInfoModel *)model;
@end
