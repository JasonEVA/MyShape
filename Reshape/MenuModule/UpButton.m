//
//  UpButton.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "UpButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface UpButton()

@property (nonatomic, strong) UIImageView *MyImageView;
@end


@implementation UpButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.MyImageView];
        [self.MyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, 1)];
    [[UIColor lightGaryline_ebe9e6] setStroke];
    [path stroke];
}

- (UIImageView *)MyImageView
{
    if (!_MyImageView) {
        _MyImageView = [[UIImageView alloc]init];
        [_MyImageView setImage:[UIImage imageNamed:@"menu_up"]];
    }
    return _MyImageView;
}
@end
