//
//  StrengthLbView.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainStrengthView.h"

@interface StrengthLbView : UIView
@property (nonatomic, strong) TrainStrengthView *strengthView;
@property (nonatomic, strong) UILabel *label;
- (void)setMyLevel:(NSInteger)Level num:(NSInteger)num;
@end
