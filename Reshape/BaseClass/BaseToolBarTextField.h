//
//  BaseToolBarTextField.h
//  Shape
//
//  Created by jasonwang on 15/10/28.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  带有toolbar的textfield

#import <UIKit/UIKit.h>
#import "MyToolBar.h"



@interface BaseToolBarTextField : UITextField

@property (nonatomic, strong)  MyToolBar  *toolBar; // <##>
@property (nonatomic, weak)  id <MyToolBarDelegate>  toolBarDeletate; // <##>

- (instancetype)initWithToolBar:(BOOL)hasToolBar backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment tag:(NSInteger)tag text:(NSString *)text inputView:(id)inputView;
// 设置toolbartitle
- (void)setToolBarTitle:(NSString *)toolBarTitle;
@end
