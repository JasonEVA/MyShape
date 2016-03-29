//
//  AllTrainingMainTableViewCell.h
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTrainingAddTrainBtn.h"

@interface AllTrainingMainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titel;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) AllTrainingAddTrainBtn *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
- (instancetype)initWithIsAll:(BOOL)isAll reuseIdentifier:(NSString *)reuseIdentifier;
@end
