//
//  WeightListModel.h
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightInfoModel.h"

@interface WeightListModel : NSObject
@property (nonatomic)  NSInteger  pageIndex; // 当前页数 int
@property (nonatomic)  NSInteger  totalPages; //	总页数	int
@property (nonatomic)  NSInteger  totalRecords; //	总条数	int
@property (nonatomic, strong)  NSArray<WeightInfoModel *>  *pageItems; //	数据集合	Array
@property (nonatomic)  CGFloat   targetWeight; //	目标体重	Double
@end
