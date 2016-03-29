//
//  MyTrainingDurationView.h
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainTimeView.h"
#import "MyTrainInfoModel.h"

@interface MyTrainingDurationView : UIView
@property (nonatomic, strong) TrainTimeView *timeView;
@property (nonatomic, strong) UILabel *durationLb;
@property (nonatomic, strong) UILabel *timeNumLb;
@property (nonatomic, strong) UILabel *unitLb;
- (void)setMyData:(MyTrainInfoModel *)model;
@end
