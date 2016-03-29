//
//  AllTrainingMainTableViewCell.m
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AllTrainingMainTableViewCell.h"
#import "UILabel+EX.h"
#import "UIFont+EX.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

#define FONT    13

@implementation AllTrainingMainTableViewCell

- (instancetype)initWithIsAll:(BOOL)isAll reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titel];
        [self.backView addSubview:self.type];
        [self.backView addSubview:self.line];
        [self.backView addSubview:self.time];
        [self.backView addSubview:self.costLb];
        
        if (isAll) {
           [self.backView addSubview:self.addBtn];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titel);
                make.bottom.equalTo(self.costLb);
                make.right.equalTo(self.contentView);
                make.width.mas_equalTo(100);
            }];

        }
        else
        {
            [self.backView addSubview:self.deleteBtn];
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self.backView).offset(-15);
            }];
        }
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.costLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.costLb.mas_top).offset(-5);
            make.left.equalTo(self.costLb);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.type.mas_right).offset(5);
            make.centerY.equalTo(self.type);
        }];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).offset(5);
            make.centerY.equalTo(self.type);
        }];
        
        
        
        
        [self.titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.time.mas_top).offset(-8);
            make.left.equalTo(self.costLb);
        }];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response
- (void)addClick{
    NSLog(@"点击了添加按钮");
}
- (void)deleteClick
{
    NSLog(@"点击了删除");
}
#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI



- (UILabel *)titel
{
    if (!_titel) {
        _titel = [UILabel setLabel:_titel text:@"" font:[UIFont themeFontOfSize:18] textColor:[UIColor whiteColor]];
    }
    return _titel;
}

- (UILabel *)type
{
    if (!_type) {
        _type = [UILabel setLabel:_type text:@"#运动" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
    }
    return _type;
}

- (UILabel *)line
{
    if (!_line) {
        _line = [UILabel setLabel:_line text:@"/" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
    }
    return _line;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [UILabel setLabel:_time text:@"时长:05'30''" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
    }
    return _time;
}

- (UILabel *)costLb
{
    if (!_costLb) {
        _costLb = [UILabel setLabel:_costLb text:@"" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
    }
    return _costLb;
}

- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alltrain_backimg"]];
        [_backView setUserInteractionEnabled:YES];
    }
    return _backView;
}

- (AllTrainingAddTrainBtn *)addBtn
{
    if (!_addBtn) {
        _addBtn = [[AllTrainingAddTrainBtn alloc] init];
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"mytrain_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
@end
