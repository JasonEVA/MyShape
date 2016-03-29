//
//  AddWeightInputView.h
//  Reshape
//
//  Created by jasonwang on 15/12/8.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  添加体重弹出框

#import <UIKit/UIKit.h>

@protocol AddWeightInputViewDelegate <NSObject>

- (void)AddWeightInputViewDelegateCallBack_saveClick;

@end

@interface AddWeightInputView : UIView
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UITextField *inputTxf;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, weak) id <AddWeightInputViewDelegate> delegate;
@end
