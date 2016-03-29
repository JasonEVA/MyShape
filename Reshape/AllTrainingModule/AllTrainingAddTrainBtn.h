//
//  AllTrainingAddTrainBtn.h
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTrainingAddTrainBtn : UIButton
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *addImg;
@property (nonatomic, strong) UILabel *addLb;
- (void)isAdded:(BOOL)isAdded;
@end
