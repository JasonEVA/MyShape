//
//  MenuView.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MenuView.h"
#import "ImageTitelView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "UpButton.h"

#define OFFSET      45

@interface MenuView()

@property (nonatomic, strong) ImageTitelView *lastObject;
@property (nonatomic, strong) UpButton *upButton;


@end


@implementation MenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self addSubview:self.upButton];
        NSArray *titelStr = [NSArray arrayWithObjects:@"播放历史",@"功能开关",@"意见反馈",@"关于我们", nil];
        NSMutableArray *imageArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i < titelStr.count; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_icon%ld",(long)i+1]];
            [imageArr addObject:image];
        }
        [self initUI:titelStr image:imageArr];
        [self configConstraints];
        
    }
    return self;
}

- (void)click:(ImageTitelView *)button
{
    if ([self.delegate respondsToSelector:@selector(MenuViewDelegateCallBack_btnClicked:)]) {
        [self.delegate MenuViewDelegateCallBack_btnClicked:button.tag + 1];
    }
    
}

- (void)initUI:(NSArray<NSString *> *)titel image:(NSArray<UIImage *> *)image
{
    for (NSInteger i = 0; i < titel.count; i++) {
        ImageTitelView *btn = [[ImageTitelView alloc]initWithImage:image[i] titel:titel[i]];
        [btn setTag:i];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(OFFSET);
                make.height.mas_equalTo(25);
                make.width.equalTo(self);
            }];
        }
        else
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.lastObject.mas_bottom).offset(OFFSET);
                make.height.mas_equalTo(25);
                make.width.equalTo(self);
            }];
        }
        self.lastObject = btn;
        
    }
}

- (void)configConstraints
{

    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(44);
    }];
}


- (UpButton *)upButton
{
    if (!_upButton) {
        _upButton = [[UpButton alloc]init];
        [_upButton setTag:4];
        [_upButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}


@end
