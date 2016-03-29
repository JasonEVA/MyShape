//
//  RootViewManager.h
//  PalmDoctorPT
//
//  Created by jasonwang on 15/4/3.
//  Copyright (c) 2015年 jasonwang. All rights reserved.
//  程序入口控制单例

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeTabBarViewController.h"

@interface RootViewManager : NSObject

/**
 *  单例
 */
+ (RootViewManager *)share;

// 登录方式
- (void)loginQueue;

@end
