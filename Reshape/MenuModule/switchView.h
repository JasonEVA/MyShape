//
//  switchView.h
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapeEnum.h"

@class switchView;
@protocol switchViewDelegate <NSObject>

- (void)switchViewDelegateCallBack_click:(BOOL)isOpen :(switchView *)switchView;

@end


@interface switchView : UIView
- (instancetype)initWithTitel:(NSString *)titel;
@property (nonatomic, weak) id <switchViewDelegate> delegate;
//根据保存信息设置开关状态
- (void)setSelectWithBool:(BOOL)isOpen;
@end
