//
//  CustomTabBar.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "CustomTabBar.h"
#import "UIFont+EX.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@implementation CustomTabBar

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectedImages:(NSArray<UIImage *> *)selectedImages
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor themeWhite_ffffff]];
        for (NSInteger i = 0; i < titles.count; i ++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateSelected];

            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont themeFontOfSize:15]];
            if (normalImages.count > i) {
                [btn setImage:normalImages[i] forState:UIControlStateNormal];
            }
            if (selectedImages.count > i) {
                [btn setImage:selectedImages[i] forState:UIControlStateSelected];
            }
            [self addSubview:btn];
            
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:[UIColor colorWithHex:0x626262]];
            [self addSubview:line];
            if (self.arrayButtons.count == 0) {
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.width.equalTo(self).multipliedBy(1 / (CGFloat)titles.count);
                }];
                [btn setSelected:YES];
                self.selectedButton = btn;
            } else {
                [line mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(self.arrayButtons.lastObject.mas_right);
                    make.height.equalTo(self).multipliedBy(0.8);
                    make.width.equalTo(@1);
                }];
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.arrayButtons.lastObject);
                    make.left.equalTo(line.mas_right);
                    make.right.equalTo(self);

                }];
            }
            [self.arrayButtons addObject:btn];
            
            
        }
    }
    return self;
}


- (NSMutableArray *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray array];
    }
    return _arrayButtons;
}


@end
