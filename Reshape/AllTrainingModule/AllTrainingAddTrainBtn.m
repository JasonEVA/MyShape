//
//  AllTrainingAddTrainBtn.m
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AllTrainingAddTrainBtn.h"
#import "UILabel+EX.h"
#import <Masonry/Masonry.h>

@implementation AllTrainingAddTrainBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.line];
        [self addSubview:self.addImg];
        [self addSubview:self.addLb];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.left.bottom.equalTo(self);
        }];
        
        [self.addImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
            
        }];
    
        [self.addLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
        }];
        
    }
    return self;
}

- (void)isAdded:(BOOL)isAdded
{
    if (isAdded) {
        [self.addImg setImage:[UIImage imageNamed:@"train_added"]];
        [self.addLb setText:@"已添加"];
        [self setEnabled:NO];

    } else {
        [self.addImg setImage:[UIImage imageNamed:@"alltrain_addtrain"]];
        [self.addLb setText:@"加入训练"];
        [self setEnabled:YES];

    }
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor whiteColor]];
    }
    return _line;
}

- (UILabel *)addLb
{
    if (!_addLb) {
        _addLb = [UILabel setLabel:_addLb text:@"加入训练" font:[UIFont themeFontOfSize:13] textColor:[UIColor whiteColor]];
    }
    return _addLb;
}

- (UIImageView *)addImg
{
    if (!_addImg) {
        _addImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alltrain_addtrain"]];
    }
    return _addImg;
}
@end
