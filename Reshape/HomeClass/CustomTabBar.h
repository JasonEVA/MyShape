//
//  CustomTabBar.h
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBar : UITabBar

@property (nonatomic, strong)  NSMutableArray<UIButton *>  *arrayButtons; // button
@property (nonatomic, strong)  UIButton  *selectedButton; // 选中的button
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectedImages:(NSArray<UIImage *> *)selectedImages;

@end
