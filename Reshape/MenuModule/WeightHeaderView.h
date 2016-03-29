//
//  WeightHeaderView.h
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  体重头部view

#import <UIKit/UIKit.h>

@protocol WeightHeaderViewDelegate <NSObject>

- (void)WeightHeaderViewDelegate_addWeightClick;
- (void)WeightHeaderViewDelegate_changeTargetWeightClick;
@end

@interface WeightHeaderView : UIView
@property (nonatomic, strong)  UIButton  *weightGoal; // <##>
@property (nonatomic, weak) id <WeightHeaderViewDelegate> delegate;

@end
