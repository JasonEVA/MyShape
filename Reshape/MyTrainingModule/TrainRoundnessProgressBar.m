//
//  TrainRoundnessProgressBar.m
//  Shape
//
//  Created by jasonwang on 15/11/10.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainRoundnessProgressBar.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "UIFont+EX.h"

#define Radius          self.frame.size.height / 2
#define LINEWITH1       8
#define LINEWITH2       8

@interface TrainRoundnessProgressBar()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) CGFloat angale;
@end

@implementation TrainRoundnessProgressBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.label];
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(Radius,Radius) radius:Radius - LINEWITH1 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor themeBackground_f3f0eb] setStroke];
    [[UIColor clearColor] setFill];
    [path setLineWidth:LINEWITH1];
    [path stroke];
    [path fill];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 addArcWithCenter:CGPointMake(Radius,Radius) radius:Radius - LINEWITH2 startAngle:- M_PI_2 endAngle:- M_PI_2 + (2 * M_PI) * self.angale clockwise:YES];
        [[UIColor themeOrange_ff5d2b] setStroke];
        [[UIColor clearColor] setFill];
        [path1 setLineWidth:LINEWITH2];
        [path1 stroke];
        [path1 fill];
    
}
- (void)setMyAngale:(CGFloat)angale
{
    self.angale = angale;
    [self setNeedsDisplay];
}

- (void)setMyData:(MyTrainInfoModel *)model
{

    [self.label setAttributedText:[self getAttributWithInt:model.currentDays]];
    
    NSString *totalStr = [NSString
                          stringWithFormat:@"%ld",(long)model.currentDays];
    CGFloat totalFloat = [totalStr floatValue];
    
    NSString *completStr = [NSString
                            stringWithFormat:@"%ld",(long)model.maxDays];
    CGFloat completFloat = [completStr floatValue];
    self.angale = totalFloat / completFloat;

}

- (NSAttributedString *)getAttributWithInt:(NSInteger)day {
    
    NSString *allStr = [NSString stringWithFormat:@"%ld天",(long)day];
    NSRange allRange = [allStr rangeOfString:@"天"];
    NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [allAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x747070] range:allRange];
    [allAttStr addAttribute:NSFontAttributeName value:[UIFont themeFontOfSize:15] range:allRange];
    return allAttStr;
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        [_label setTextColor:[UIColor themeOrange_ff5d2b]];
        _label.font = [UIFont systemFontOfSize:40];
        [_label setAttributedText:[self getAttributWithInt:0]];
    }
    return _label;
}
@end
