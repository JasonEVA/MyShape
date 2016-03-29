//
//  TrainingInfoCollectionViewCell.h
//  Reshape
//
//  Created by jasonwang on 15/12/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTrainingAddTrainBtn.h"
#import "ShapeEnum.h"
@class TrainingListInfoModel;
@class TrainingInfoCollectionViewCell;

@protocol TrainingInfoCollectionViewCellDelegate <NSObject>

- (void)TrainingInfoCollectionViewCellDelegateCallBack_addClickcell:(TrainingInfoCollectionViewCell *)cell;

- (void)TrainingInfoCollectionViewCellDelegateCallBack_deleteClick:(TrainingInfoCollectionViewCell *)cell;

@end


@interface TrainingInfoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titel;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) AllTrainingAddTrainBtn *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) TrainingListInfoModel *model;

@property (nonatomic, weak) id <TrainingInfoCollectionViewCellDelegate> delegate;
//修改右下角图标类型
- (void)changeType:(TrainingCellType)type;
- (void)setCellData:(TrainingListInfoModel *)model;
@end
