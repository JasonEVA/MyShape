//
//  MyTrainingVideoView.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingVideoView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "AllTrainingMainTableViewCell.h"
#import "TrainingInfoCollectionViewCell.h"
#import "ShapeEnum.h"
#import <MJRefresh/MJRefresh.h>

@interface MyTrainingVideoView()<UICollectionViewDataSource,UICollectionViewDelegate,TrainingInfoCollectionViewCellDelegate>


@end

@implementation MyTrainingVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [self addSubview:self.collectView];
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadCollectionView
{
    [self.collectView reloadData];
}
#pragma mark - UITableView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    TrainingInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    [cell.layer setCornerRadius:8];
    //[cell setClipsToBounds:YES];
    [cell changeType:type_delete];
    [cell setCellData:self.dataSource[indexPath.row]];
    [cell setTag:indexPath.row];
    [cell setDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(MyTrainingVideoViewDelegateCallBack_cellClick:)]) {
        [self.delegate MyTrainingVideoViewDelegateCallBack_cellClick:indexPath];
    }

    
}
- (void)TrainingInfoCollectionViewCellDelegateCallBack_deleteClick:(TrainingInfoCollectionViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(MyTrainingVideoViewDelegateCallBack_deleteClick:tag:)]) {
        [self.delegate MyTrainingVideoViewDelegateCallBack_deleteClick:cell.model tag:cell.tag];
    }
}

- (void)addMoreClick{
    if ([self.delegate respondsToSelector:@selector(MyTrainingVideoViewDelegateCallBack_refresh)]) {
        [self.delegate MyTrainingVideoViewDelegateCallBack_refresh];
    }
}

#pragma mark - Init

- (UICollectionView *)collectView
{
    if (!_collectView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //[layout setSectionInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,160);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectView setDataSource:self];
        [_collectView setDelegate:self];
        [_collectView registerClass:[TrainingInfoCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        [_collectView setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [_collectView setShowsVerticalScrollIndicator:NO];
        _collectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreClick)];
        
    }
    return _collectView;
}

@end
