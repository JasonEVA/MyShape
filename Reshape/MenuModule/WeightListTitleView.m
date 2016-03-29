//
//  WeightListTitleView.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightListTitleView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"

#define lineDistance     70

@implementation WeightListTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setText:@"时间"];
        [timeLabel setTextColor:[UIColor colorWithHex:0x9f9f9f]];
        [timeLabel setFont:[UIFont themeFontOfSize:13]];
        
        UILabel *targetLabel = [[UILabel alloc] init];
        [targetLabel setTextColor:[UIColor colorWithHex:0x9f9f9f]];
        [targetLabel setText:@"目标体重线"];
        [targetLabel setFont:[UIFont themeFontOfSize:13]];

        
        [self addSubview:timeLabel];
        [self addSubview:targetLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.centerX.equalTo(self.mas_left).offset(35);
        }];
        
        [targetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel);
            make.right.equalTo(self.mas_centerX).offset(-10);
        }];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineDistance, 22)];
    [path addLineToPoint:CGPointMake(lineDistance, self.frame.size.height)];
    [path setLineWidth:3];
    [[UIColor colorWithHex:0xf5f5f5] setStroke];
    [path stroke];
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(lineDistance,22) radius:3.5 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorWithHex:0xd1d1d1] setFill];
    [path1 setLineWidth:0];
    [path1 fill];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 addArcWithCenter:CGPointMake(self.frame.size.width / 2 + 10,22) radius:3.5 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorWithHex:0xeeeeee] setFill];
    [path2 setLineWidth:0];
    [path2 fill];
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(self.frame.size.width / 2 + 10, 22)];
    [path3 addLineToPoint:CGPointMake(self.frame.size.width / 2 + 10, self.frame.size.height)];
    [path3 setLineWidth:3];
    CGFloat dashPattern[] = {3,1};// 3实线，1空白
    [path3 setLineDash:dashPattern count:1 phase:1];
    [[UIColor colorWithHex:0xeeeeee] setStroke];
    [path3 stroke];

}


@end
