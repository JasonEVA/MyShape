//
//  MeTrainHistoryCell.h
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeTrainHistoryDetailView.h"
#import "MeTrainHistoryDetailModel.h"

@interface MeTrainHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) MeTrainHistoryDetailView *detailView;
@property (nonatomic, copy) NSIndexPath *indexPath;
- (void)setMyContent:(MeTrainHistoryDetailModel *)model indexPath:(NSIndexPath *)indexPath;
@end
