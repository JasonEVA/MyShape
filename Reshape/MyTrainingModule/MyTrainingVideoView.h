//
//  MyTrainingVideoView.h
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  我的训练视频列表

#import <UIKit/UIKit.h>
#import "TrainingListInfoModel.h"

@protocol MyTrainingVideoViewDelegate <NSObject>

- (void)MyTrainingVideoViewDelegateCallBack_cellClick:(NSIndexPath *)indexPath;
- (void)MyTrainingVideoViewDelegateCallBack_deleteClick:(TrainingListInfoModel *)model tag:(NSInteger)tag;
- (void)MyTrainingVideoViewDelegateCallBack_refresh;
@end

@interface MyTrainingVideoView : UIView
@property (nonatomic, weak) id <MyTrainingVideoViewDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray <TrainingListInfoModel *> *dataSource;
@property (nonatomic, strong)  UICollectionView *collectView;
- (void)reloadCollectionView;
@end

