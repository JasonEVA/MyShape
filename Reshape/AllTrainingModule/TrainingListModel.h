//
//  TrainingListModel.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@class TrainingListInfoModel;

@interface TrainingListModel : NSObject
@property (nonatomic)  NSInteger  pageIndex; // 当前页数 int
@property (nonatomic)  NSInteger  totalPages; //	总页数	int
@property (nonatomic)  NSInteger  totalRecords; //	总条数	int
@property (nonatomic, strong)  NSArray<TrainingListInfoModel *>  *pageItems; //	数据集合	Array
@end
