//
//  MeFooterView.m
//  Shape
//
//  Created by jasonwang on 15/11/17.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeFooterView.h"
#import "UIColor+Hex.h"

#define Radius          self.frame.size.height / 2
#define LINEWITH1       0
#define LINEWITH2       3
#define lineDistance     82
@implementation MeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineDistance, 0)];
    [path addLineToPoint:CGPointMake(lineDistance, 40)];
    [path setLineWidth:1];
    [[UIColor lightGaryline_ebe9e6] setStroke];
    [path stroke];
    
    

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 addArcWithCenter:CGPointMake(lineDistance, 40) radius:7 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorWithR:215 g:209 b:198] setFill];
    [path2 setLineWidth:LINEWITH1];
    [path2 fill];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(lineDistance, 40) radius:3.5 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorWithR:152 g:143 b:126] setFill];
    [path1 setLineWidth:LINEWITH1];
    [path1 fill];
    
}
@end
