//
//  TrainingInfoCollectionViewCell.m
//  Reshape
//
//  Created by jasonwang on 15/12/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingInfoCollectionViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"
#import <UIImageView+WebCache.h>
#import "TrainingListInfoModel.h"
#import "DateUtil.h"

#define FONT    13

@implementation TrainingInfoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titel];
        [self.backView addSubview:self.type];
        [self.backView addSubview:self.line];
        [self.backView addSubview:self.time];
        [self.backView addSubview:self.costLb];
        
        
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
            make.right.equalTo(self.contentView).offset(-105);
        }];
    }

    
    return self;
}
#pragma mark - Interface MEthod
- (void)setCellData:(TrainingListInfoModel *)model {
    
    self.model = model;
    NSURL *url = [[NSURL alloc] initWithString:model.descriptionImage];
    [self.backView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_bgImage"]];
    [self.type setText:[NSString stringWithFormat:@"#%@",model.classifyName]];
    [self.titel setText:model.name];
    [self.costLb setText:[NSString stringWithFormat:@"消耗:%@",model.consumeDescription]];
    [self.time setText:[DateUtil stringWithSecond:model.videoTotalSeconds]];
    [self.addBtn isAdded:model.isSelected];
    
}

//修改右下角图标类型
- (void)changeType:(TrainingCellType)type
{
    switch (type) {
        case type_beforeAdd:
        {
            [self.backView addSubview:self.addBtn];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titel);
                make.bottom.equalTo(self.costLb);
                make.right.equalTo(self.contentView);
                make.width.mas_equalTo(100);
            }];

        }
            break;
            case type_added:
        {
            [self.addBtn.addImg setImage:[UIImage imageNamed:@"train_added"]];
        }
            break;
        case type_delete:
        {
            [self.backView addSubview:self.deleteBtn];
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self.backView).offset(-15);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response
- (void)addClick{
    NSLog(@"点击了添加按钮");
    if ([self.delegate respondsToSelector:@selector(TrainingInfoCollectionViewCellDelegateCallBack_addClickcell:)]) {
        [self.delegate TrainingInfoCollectionViewCellDelegateCallBack_addClickcell:self];
    }
}
- (void)deleteClick
{
    NSLog(@"点击了删除");
    if ([self.delegate respondsToSelector:@selector(TrainingInfoCollectionViewCellDelegateCallBack_deleteClick:)]) {
        [self.delegate TrainingInfoCollectionViewCellDelegateCallBack_deleteClick:self];
    }
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
        _type = [UILabel setLabel:_type text:@"" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
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
        _time = [UILabel setLabel:_time text:@"" font:[UIFont themeFontOfSize:FONT] textColor:[UIColor whiteColor]];
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
        _backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alltrain_backimg"]];
        [_backView setUserInteractionEnabled:YES];
        [_backView setContentMode:UIViewContentModeScaleAspectFill];
        [_backView setBackgroundColor:[UIColor themeImageBackgroundColor]];

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

- (TrainingListInfoModel *)model
{
    if (!_model) {
        _model = [[TrainingListInfoModel alloc] init];
    }
    return _model;
}
@end

