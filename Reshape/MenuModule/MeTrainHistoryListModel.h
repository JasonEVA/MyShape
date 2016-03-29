//
//  MeTrainHistoryListModel.h
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MeTrainHistoryDetailModel;

@interface MeTrainHistoryListModel : NSObject
@property (nonatomic) NSInteger pageIndex;	//当前页数	String
@property (nonatomic) NSInteger totalPages;	//总页数	String
@property (nonatomic) NSInteger totalRecords;	//总条数	int
@property (nonatomic, copy)  NSArray<MeTrainHistoryDetailModel *>  *pageItems;	//数据集合	Array
@end
