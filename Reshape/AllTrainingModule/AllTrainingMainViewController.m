//
//  AllTrainingMainViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AllTrainingMainViewController.h"
#import <Masonry/Masonry.h>
#import "TrainingDetailViewController.h"
#import "AllTrainingMainTableViewCell.h"
#import "UIColor+Hex.h"
#import "TrainingInfoCollectionViewCell.h"
#import "TrainingListRequest.h"
#import "TrainingListModel.h"
#import "ShapeEnum.h"
#import <MJRefresh/MJRefresh.h>
#import "TrainingListInfoModel.h"
#import "TrainAddToMyTrainRequest.h"

static NSInteger const kPageSize = 10; // 每页条数
@interface AllTrainingMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,BaseRequestDelegate,TrainingInfoCollectionViewCellDelegate>

@property (nonatomic, strong)  UICollectionView *collectView;
@property (nonatomic, strong)  NSMutableArray <TrainingListInfoModel *> *dataSource; // <##>
@property (nonatomic)  NSInteger  currentIndex; // 当前页
@property (nonatomic)  NSInteger  totalPages; // 总页数
@property (nonatomic, strong) TrainingInfoCollectionViewCell *myCell;
@end

@implementation AllTrainingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Shape"];
    [self configElements];
    


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestListData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentIndex = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configConstraints {
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - event Response
- (void)addMoreClick
{
    [self requestListData];
    
}
#pragma mark - request Delegate


#pragma mark - updateViewConstraints


#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.collectView];
    self.currentIndex = 0;
    [self configConstraints];
}

// 列表数据请求
- (void)requestListData {
    TrainingListRequest *request = [[TrainingListRequest alloc] init];
    request.pageSize = kPageSize;
    request.pageIndex = self.currentIndex + 1;
    [request requestWithDelegate:self];
    [self postLoading];
    
}
#pragma mark - Delegate
- (void)TrainingInfoCollectionViewCellDelegateCallBack_addClickcell:(TrainingInfoCollectionViewCell *)cell{
    
    self.myCell = cell;
    TrainAddToMyTrainRequest *request = [[TrainAddToMyTrainRequest alloc] init];
    request.myId = cell.model.trainingVideoId;
    [request requestWithDelegate:self];
    [self postLoading];
    
}

- (void)TrainingInfoCollectionViewCellDelegateCallBack_deleteClick:(TrainingInfoCollectionViewCell *)cell
{
    
}
#pragma mark - Request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response {
    
    [self hideLoading];
    
    if ([response isKindOfClass:[TrainingListResponse class]]) {
        TrainingListResponse *result = (TrainingListResponse *)response;
        if (result.listModel.pageIndex == 1) {
            [self.dataSource removeAllObjects];
        }
        if (result.listModel.pageItems.count == 0) {
            [self.collectView.mj_footer endRefreshingWithNoMoreData];
        } else {
            self.currentIndex = result.listModel.pageIndex;
            self.totalPages = result.listModel.totalPages;
            [self.dataSource addObjectsFromArray:result.listModel.pageItems];
            if (result.listModel.pageItems.count == kPageSize && result.listModel.pageIndex < result.listModel.totalPages) {
                [self.collectView.mj_footer endRefreshing];
            } else {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.collectView reloadData];
        }
        
    } else if ([response isKindOfClass:[TrainAddToMyTrainResponse class]]) {
        NSLog(@"添加成功");
        [self.myCell.addBtn isAdded:YES];
        self.myCell.model.isSelected = YES;
    }
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response {
        [self hideLoading];
    [self postError:response.message];
    if ([response isKindOfClass:[TrainingListResponse class]]) {
        [self.collectView.mj_footer endRefreshing];
    } else if ([response isKindOfClass:[TrainAddToMyTrainResponse class]]) {
        NSLog(@"添加失败");
    }

}

#pragma mark - UIColectionView Delegate

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
    [cell changeType:type_beforeAdd];
    [cell setCellData:self.dataSource[indexPath.row]];
    [cell setDelegate:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDetailViewController *detailVC = [[TrainingDetailViewController alloc] init];
    detailVC.added = self.dataSource[indexPath.row].isSelected;
    detailVC.videoID = self.dataSource[indexPath.row].trainingVideoId;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Init

- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,230);
        layout.minimumLineSpacing = 0;
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (TrainingInfoCollectionViewCell *)myCell
{
    if (!_myCell) {
        _myCell = [[TrainingInfoCollectionViewCell alloc] init];
    }
    return _myCell;
}

@end
