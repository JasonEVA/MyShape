//
//  WeightRoundView.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightRoundView.h"
#import "UILabel+EX.h"
#import <Masonry/Masonry.h>

@implementation WeightRoundView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.numLb];
        
        [self.numLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(self.frame.size.height / 2,self.frame.size.height / 2) radius:18 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor themeOrange_ff5d2b] setFill];
    [path1 setLineWidth:0];
    [path1 fill];
}

- (UILabel *)numLb
{
    if (!_numLb) {
        _numLb = [UILabel setLabel:_numLb text:@"44.3" font:[UIFont themeFontOfSize:13] textColor:[UIColor whiteColor]];
    }
    return _numLb;
}
@end
