//
//  WeightListView.h
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightInfoModel.h"
@interface WeightListView : UIView
@property (nonatomic, copy) NSArray <WeightInfoModel *>*dataList;
@property (nonatomic, copy) NSMutableArray *pointList;
@property (nonatomic, copy) NSMutableArray *allDataList;
- (void)setViewWithData:(NSArray *)dataList targetWeight:(CGFloat)targetWeight;
@end
