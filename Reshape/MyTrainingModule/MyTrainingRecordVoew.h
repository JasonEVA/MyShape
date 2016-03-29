//
//  MyTrainingRecordVoew.h
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainRoundnessProgressBar.h"
#import "MyTrainInfoModel.h"

@interface MyTrainingRecordVoew : UIView
@property (nonatomic, strong) TrainRoundnessProgressBar *progressView;
@property (nonatomic, strong) UILabel *recordLb;
@property (nonatomic, strong) UILabel *bestRecordLb;
- (void)setMyData:(MyTrainInfoModel *)model;

@end
