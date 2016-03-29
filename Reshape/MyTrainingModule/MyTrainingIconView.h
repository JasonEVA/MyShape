//
//  MyTrainingIconView.h
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainStrengthView.h"
#import "MyTrainInfoModel.h"

@interface MyTrainingIconView : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *shadeView;
@property (nonatomic, strong) UILabel *nikeNameLbl;
@property (nonatomic, strong) TrainStrengthView *strengView;
- (void)setMyData:(MyTrainInfoModel *)model;
@end
