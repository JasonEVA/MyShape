//
//  WeightListView.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightListView.h"
#import "UIColor+Hex.h"
#import "UIFont+EX.h"
#import <Masonry/Masonry.h>

#import "WeightRoundView.h"

#define lineDistance     70
#define ROWHEIGHT        60
#define RATIO             1.5  //放大倍率
@implementation WeightListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

            }
    return self;
}

- (void)setViewWithData:(NSArray *)dataList targetWeight:(CGFloat)targetWeight{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.dataList = dataList;
    [self.allDataList addObjectsFromArray:self.dataList];
    [self.pointList removeAllObjects];
    for (NSInteger i = 0; i < dataList.count; i++) {
        WeightInfoModel *model = [[WeightInfoModel alloc] init];
        model = dataList[i];
        UILabel *timeLabel = [[UILabel alloc] init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.recordTimeStamp];
        NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
        [dateFor setDateFormat:@"MM/dd"];
        [timeLabel setText:[dateFor stringFromDate:date]];
        [timeLabel setTextColor:[UIColor colorWithHex:0x9f9f9f]];
        [timeLabel setFont:[UIFont themeFontOfSize:13]];
        
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15 + ROWHEIGHT * i);
            make.centerX.equalTo(self.mas_left).offset(35);
        }];
        CGPoint point = CGPointMake(10 + (model.weight - targetWeight) * RATIO + self.frame.size.width / 2, 10 + ROWHEIGHT * i + 18);
        [self.pointList addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //时间线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineDistance, 0)];
    [path addLineToPoint:CGPointMake(lineDistance, self.frame.size.height)];
    [path setLineWidth:3];
    [[UIColor colorWithHex:0xf5f5f5] setStroke];
    [path stroke];
    
    //目标体重虚线
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(self.frame.size.width / 2 + 10, 0)];
    [path3 addLineToPoint:CGPointMake(self.frame.size.width / 2 + 10, self.frame.size.height)];
    [path3 setLineWidth:3];
    CGFloat dashPattern[] = {3,1};// 3实线，1空白
    [path3 setLineDash:dashPattern count:1 phase:1];
    [[UIColor colorWithHex:0xeeeeee] setStroke];
    [path3 stroke];

    for (NSInteger i = 0; i < self.dataList.count; i++) {
        
        //日期节点
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 addArcWithCenter:CGPointMake(lineDistance,ROWHEIGHT * i + 25) radius:3.5 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
        [[UIColor colorWithHex:0xd1d1d1] setFill];
        [path1 setLineWidth:0];
        [path1 fill];
        
        if (i > 0) {
            //划线连接
            UIBezierPath *path4 = [UIBezierPath bezierPath];
            CGPoint point1 = CGPointMake([[self.pointList objectAtIndex:i - 1] CGPointValue].x, [[self.pointList objectAtIndex:i - 1] CGPointValue].y );
            CGPoint point2 = CGPointMake([[self.pointList objectAtIndex:i] CGPointValue].x, [[self.pointList objectAtIndex:i] CGPointValue].y);
            [path4 moveToPoint:point1];
            [path4 addLineToPoint:point2];
            [path4 setLineWidth:3];
            [[UIColor themeOrange_ff5d2b] setStroke];
            [path4 stroke];
        }
        
        //画出圆形体重
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        [path5 addArcWithCenter:[[self.pointList objectAtIndex:i] CGPointValue] radius:18 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
        [[UIColor themeOrange_ff5d2b] setFill];
        [path5 setLineWidth:0];
        [path5 fill];

        
    }
    //遮挡一部分线条
    for (NSInteger i = 0; i < self.dataList.count; i++) {
        UIBezierPath *path6 = [UIBezierPath bezierPath];
        [path6 addArcWithCenter:[[self.pointList objectAtIndex:i] CGPointValue] radius:21 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
        [[UIColor whiteColor] setStroke];
        [path6 setLineWidth:6];
        [path6 stroke];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
        [style setAlignment:NSTextAlignmentCenter];
        NSDictionary *dictAttributesCN = @{NSFontAttributeName:[UIFont themeFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};

        //体重数字
        [[NSString stringWithFormat:@"%.f",self.dataList[i].weight] drawInRect:CGRectMake([[self.pointList objectAtIndex:i] CGPointValue].x - 12, [[self.pointList objectAtIndex:i] CGPointValue].y - 8, 25, 15) withAttributes:dictAttributesCN];

    }
    
}

- (NSMutableArray *)pointList
{
    if (!_pointList) {
        _pointList = [[NSMutableArray alloc] init];
    }
    return _pointList;
}

- (NSMutableArray *)allDataList
{
    if (!_allDataList) {
        _allDataList = [[NSMutableArray alloc] init];
    }
    return _allDataList;
}
@end
