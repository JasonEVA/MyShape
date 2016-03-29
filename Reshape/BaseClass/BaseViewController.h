//
//  BaseViewController.h
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  ViewController基类

#import "UIViewController+Loading.h"

@interface BaseViewController : UIViewController

/** 获得当前显示在屏幕上的页面 */
+ (UIViewController *)presentingVC;


@end
