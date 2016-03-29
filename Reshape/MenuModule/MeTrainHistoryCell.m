//
//  MeTrainHistoryCell.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeTrainHistoryCell.h"
#import "UILabel+EX.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

#define lineDistance     82
@implementation MeTrainHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self.contentView addSubview:self.dateLb];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.detailView];
        
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLb.mas_bottom).offset(5);
            make.centerX.equalTo(self.dateLb);
        }];
        
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(16);
            make.left.equalTo(self.dateLb.mas_right).offset(20);
        }];

    
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineDistance, 0)];
    [path addLineToPoint:CGPointMake(lineDistance, self.frame.size.height)];
    [path setLineWidth:1];
    [[UIColor lightGaryline_ebe9e6] setStroke];
    [path stroke];
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(lineDistance,48) radius:3.5 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor themeOrange_ff5d2b] setFill];
    [path1 setLineWidth:0];
    [path1 fill];
    
}

- (void)setMyContent:(MeTrainHistoryDetailModel *)model indexPath:(NSIndexPath *)indexPath
{
    [self.detailView setMyContent:model];
    self.indexPath = indexPath;
    //如果为第一行，隐藏上半段线
    if (self.indexPath.row == 0) {
        
        UIView *hideenView = [[UIView alloc]initWithFrame:CGRectMake(lineDistance - 2, 0, 4, 44.5)];
        [hideenView setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self.contentView addSubview:hideenView];
        
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.recordTimeStamp];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
    [dateFor setDateFormat:@"MM月dd日"];
    [self.dateLb setText:[dateFor stringFromDate:date]];
    [dateFor setDateFormat:@"HH:mm"];
    [self.timeLb setText:[dateFor stringFromDate:date]];
}

- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel setLabel:_dateLb text:@"08-01" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHex:0x515151]];
    }
    return _dateLb;
}

- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel setLabel:_timeLb text:@"19:20" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHex:0x888888]];
    }
    return _timeLb;
}

- (MeTrainHistoryDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[MeTrainHistoryDetailView alloc]init];
        _detailView.layer.cornerRadius = 5;
    }
    return _detailView;
}


- (NSIndexPath *)indexPath
{
    if (!_indexPath) {
        _indexPath = [[NSIndexPath alloc]init];
    }
    return _indexPath;
}
@end
