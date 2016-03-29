//
//  TrainFinishInputView.h
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TrainFinishInputViewDelegate <NSObject>

- (void)TrainFinishInputViewDelegate_callBack;

@end

@interface TrainFinishInputView : UIView
@property (nonatomic, strong) UILabel *imageView;
@property (nonatomic, strong) UILabel *finishTitelLb;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, assign)  id <TrainFinishInputViewDelegate>  delegate; // 委托
@end
