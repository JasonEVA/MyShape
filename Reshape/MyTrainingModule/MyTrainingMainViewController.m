//
//  MyTrainingMainViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MyTrainingMainViewController.h"
#import "RowButtonGroup.h"
#import "UIColor+Hex.h"
#import "UIFont+EX.h"
#import <Masonry/Masonry.h>
#import "ViewCollectionViewCell.h"
#import "MyTrainingVideoView.h"
#import "MyTrainingIconView.h"
#import "MyTrainingDurationView.h"
#import "MyTrainingRecordVoew.h"
#import "TrainingDetailViewController.h"
#import "MeDetailsViewController.h"
#import "MyTrainInfoModel.h"
#import "MyTrainInfoRequest.h"
#import "MyTrainingGetPageQueryRequest.h"
#import "TrainingListModel.h"
#import "MyTrainDeleteVideoRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "unifiedUserInfoManager.h"

typedef enum : NSUInteger {
    tag_myTraining,
} MyTrainingModuleTag;

typedef enum : NSUInteger {
    tag_trainingRecord,
    tag_trainingModule
} MyTrainingCollectionTag;

static NSString *const kTrainingRecord = @"trainingRecord";
static NSString *const kTrainingModule = @"trainingModule";

static NSInteger const kTrainingRecordCount = 1;
static NSInteger const kTrainingModuleCount = 1; // 我的训练模块，为以后做准备

static NSInteger const kPageSize = 10; // 每页条数

@interface MyTrainingMainViewController ()<RowButtonGroupDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MyTrainingVideoViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong)  UICollectionView  *trainingRecordCollection; //  训练记录，个人信息部分
//@property (nonatomic, strong)  UIPageControl  *pageControl; // 训练记录pageControl
@property (nonatomic, strong)  UICollectionView  *trainingModuleCollection; // 训练模块部分
@property (nonatomic, strong)  RowButtonGroup  *rowBtnGroup; // 训练模块按钮
@property (nonatomic, strong)  UIView  *lineBG; // 背景线
@property (nonatomic, strong)  UIView  *lineOrange; // 按钮上的线
@property (nonatomic, strong)  MyTrainingVideoView  *trainingVideoView; // 我的训练视频列表
@property (nonatomic, strong)  MyTrainingIconView *iconView;   //头像信息View
@property (nonatomic, strong)  MyTrainingDurationView *durationView;  //训练时长View
@property (nonatomic, strong)  MyTrainingRecordVoew *recordView;     //训练记录View
@property (nonatomic, strong)  UITapGestureRecognizer *tap;      //单击手势

@property (nonatomic, strong)  MyTrainInfoModel *myTrainInfoModel;   //我的训练信息Model

@property (nonatomic, strong)  NSMutableArray <TrainingListInfoModel *> *dataSource; // <##>
@property (nonatomic)  NSInteger  currentIndex; // 当前页
@property (nonatomic)  NSInteger  cellTag; // 总页数

@end

@implementation MyTrainingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Shape"];
    [self configElements];
    self.currentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 个人界面
    if ([[unifiedUserInfoManager share] loginStatus]) {
        [self startRequest];
        [self requestForMyList];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentIndex = 0;
}
- (void)configConstraints {
    [self.trainingRecordCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@222);
    }];
    
//    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.trainingRecordCollection);
//        make.bottom.equalTo(self.trainingRecordCollection).offset(-15);
//        make.height.equalTo(@10);
//        make.width.equalTo(@30);
//    }];
    
    [self.rowBtnGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.trainingRecordCollection.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [self.lineBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rowBtnGroup).offset(10);
        make.right.equalTo(self.rowBtnGroup).offset(-10);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.rowBtnGroup);
    }];
    
    [self.lineOrange mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.equalTo(self.lineBG);
        make.centerX.equalTo(self.rowBtnGroup.selectedBtn);
        make.width.equalTo(@75);
    }];

    [self.trainingModuleCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.rowBtnGroup.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
}
#pragma mark - Interface Method

#pragma mark - Private Method

- (void)updateCustomContraints {
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.trainingModuleCollection];
    [self.view addSubview:self.trainingRecordCollection];
    //[self.view addSubview:self.pageControl];
    [self.view addSubview:self.rowBtnGroup];
    [self.rowBtnGroup addSubview:self.lineBG];
    [self.lineBG addSubview:self.lineOrange];
    
    [self configConstraints];
}
//开始请求
- (void)startRequest
{
    MyTrainInfoRequest *request = [[MyTrainInfoRequest alloc] init];
    [request requestWithDelegate:self];
    [self postLoading];
}
//请求我的视频列表数据
- (void)requestForMyList
{
    MyTrainingGetPageQueryRequest *request1 = [[MyTrainingGetPageQueryRequest alloc] init];
    request1.skip = self.currentIndex * kPageSize;
    request1.take = kPageSize;
    [request1 requestWithDelegate:self];
    [self postLoading];
}

- (void)setMyData{
    [self.iconView setMyData:self.myTrainInfoModel];
    [self.durationView setMyData:self.myTrainInfoModel];
    [self.recordView setMyData:self.myTrainInfoModel];
}
#pragma mark - Event Response

- (void)tapClick
{
    MeDetailsViewController *VC  = [[MeDetailsViewController alloc] init];
    VC.isFirst = NO;
    VC.model = self.myTrainInfoModel;
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Delegate

- (void)MyTrainingVideoViewDelegateCallBack_cellClick:(NSIndexPath *)indexPath
{
    TrainingDetailViewController *VC = [[TrainingDetailViewController alloc] init];
    VC.added = YES;
    VC.videoID = self.dataSource[indexPath.row].trainingVideoId;
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)MyTrainingVideoViewDelegateCallBack_deleteClick:(TrainingListInfoModel *)model tag:(NSInteger)tag
{
    self.cellTag = tag;
    MyTrainDeleteVideoRequest *request  = [[MyTrainDeleteVideoRequest alloc] init];
    request.myId = model.trainingVideoId;
    [request requestWithDelegate:self];
    [self postLoading];
}

- (void)MyTrainingVideoViewDelegateCallBack_refresh
{
    [self requestForMyList];
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
    [self hideLoading];
    [self postError:response.message];
    [self.trainingVideoView.collectView.mj_footer endRefreshing];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
     NSLog(@"请求成功");
    [self hideLoading];
    if([response isKindOfClass:[MyTrainInfoResponse class]])
    {
        MyTrainInfoResponse *result = (MyTrainInfoResponse *)response ;
        self.myTrainInfoModel = result.model;
        [self setMyData];
        [self.trainingRecordCollection reloadData];
    } else if ([response isKindOfClass:[MyTrainingGetPageQueryResponse class]]) {
        MyTrainingGetPageQueryResponse *result = (MyTrainingGetPageQueryResponse *)response;
        if (self.currentIndex == 0) {
            [self.dataSource removeAllObjects];
        }
        //返回为空显示无更多
        if (result.modelArr.count == 0) {
            [self.trainingVideoView.collectView.mj_footer endRefreshingWithNoMoreData];
        } else {
            //添加数据源
            [self.dataSource addObjectsFromArray:result.modelArr];
            if (result.modelArr.count == kPageSize) {
                [self.trainingVideoView.collectView.mj_footer endRefreshing];
            } else {
                [self.trainingVideoView.collectView.mj_footer endRefreshingWithNoMoreData];
            }
            self.currentIndex ++;
            self.trainingVideoView.dataSource = self.dataSource;
            [self.trainingVideoView reloadCollectionView];
        }
    } else if ([response isKindOfClass:[MyTrainDeleteVideoResponse class]]) {
        //从数据源中移除数据
        [self.dataSource removeObjectAtIndex:self.cellTag];
        //再加载一条数据
        MyTrainingGetPageQueryRequest *request1 = [[MyTrainingGetPageQueryRequest alloc] init];
        request1.skip = self.currentIndex * kPageSize - 1;
        request1.take = 1;
        [request1 requestWithDelegate:self];
        [self postLoading];
        [self.trainingVideoView reloadCollectionView];
    }
   

}

#pragma mark - UIColectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == tag_trainingRecord) {
        return kTrainingRecordCount;
    } else {
        return kTrainingModuleCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == tag_trainingRecord) {
        ViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTrainingRecord forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [cell setMyCustomView:self.iconView];
                break;
            case 1:
                [cell setMyCustomView:self.durationView];
                break;
            case 2:
                [cell setMyCustomView:self.recordView];
                break;
            default:
                break;
        }
        return cell;
    } else {
        ViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTrainingModule forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell setMyCustomView:self.trainingVideoView];
        }
        return cell;
    }
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == tag_trainingRecord) {
            NSInteger currentIndex = (scrollView.contentOffset.x - self.view.frame.size.width * 0.5) / self.view.frame.size.width + 1;
        //[self.pageControl setCurrentPage:currentIndex];
        //    AerobicSideTag tag = (AerobicSideTag)currentIndex;
        //    [self.rowBtnGroup setBtnSelectedWithTag:tag];
    } else {
        NSLog(@"-------------->module");
    }

    
}

#pragma mark - rowBtnGroupDelegate
// 正反面点击委托
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self updateCustomContraints];
    
}
#pragma mark - Init

- (RowButtonGroup *)rowBtnGroup {
    if (!_rowBtnGroup) {
        _rowBtnGroup = [[RowButtonGroup alloc] initWithTitles:@[@"我的视频"] tags:@[@(tag_myTraining)] normalTitleColor:[UIColor colorMyLightGray_959595] selectedTitleColor:[UIColor themeOrange_ff5d2b] font:[UIFont themeFontOfSize:15]];
        [_rowBtnGroup setDelegate:self];
        [_rowBtnGroup setBackgroundColor:[UIColor themeBackground_f3f0eb]];
    }
    return _rowBtnGroup;
}

// 我的训练视频
- (UICollectionView *)trainingModuleCollection {
    if (!_trainingModuleCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20 - 1,self.view.frame.size.height - 222 - 180 - 1);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        _trainingModuleCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_trainingModuleCollection setDelegate:self];
        [_trainingModuleCollection setDataSource:self];
        [_trainingModuleCollection registerClass:[ViewCollectionViewCell class] forCellWithReuseIdentifier:kTrainingModule];
        [_trainingModuleCollection setPagingEnabled:YES];
        [_trainingModuleCollection setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [_trainingModuleCollection setTag:tag_trainingModule];
        [_trainingModuleCollection setShowsHorizontalScrollIndicator:NO];
    }
    return _trainingModuleCollection;
}

// 训练记录，个人信息
- (UICollectionView *)trainingRecordCollection {
    if (!_trainingRecordCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width ,222);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsZero];
        
        _trainingRecordCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_trainingRecordCollection setDelegate:self];
        [_trainingRecordCollection setDataSource:self];
        [_trainingRecordCollection registerClass:[ViewCollectionViewCell class] forCellWithReuseIdentifier:kTrainingRecord];
        [_trainingRecordCollection setPagingEnabled:YES];
        [_trainingRecordCollection setBackgroundColor:[UIColor whiteColor]];
        [_trainingRecordCollection setTag:tag_trainingRecord];
        [_trainingRecordCollection setShowsHorizontalScrollIndicator:NO];
    }
    return _trainingRecordCollection;
}

//- (UIPageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc] init];
//        _pageControl.numberOfPages = kTrainingRecordCount;
//        _pageControl.currentPage = 0;
//        _pageControl.pageIndicatorTintColor = [UIColor themeBackground_f3f0eb];
//        _pageControl.currentPageIndicatorTintColor = [UIColor themeOrange_ff5d2b];
//    }
//    return _pageControl;
//}

- (UIView *)lineBG {
    if (!_lineBG) {
        _lineBG = [[UIView alloc] init];
        [_lineBG setBackgroundColor:[UIColor whiteColor]];
    }
    return _lineBG;
}

- (UIView *)lineOrange {
    if (!_lineOrange) {
        _lineOrange = [[UIView alloc] init];
        [_lineOrange setBackgroundColor:[UIColor themeOrange_ff5d2b]];
    }
    return _lineOrange;
}

- (MyTrainingVideoView *)trainingVideoView {
    if (!_trainingVideoView) {
        _trainingVideoView = [[MyTrainingVideoView alloc] init];
        [_trainingVideoView setDelegate:self];
        _trainingVideoView.dataSource = self.dataSource;
    }
    return _trainingVideoView;
}
- (MyTrainingIconView *)iconView
{
    if (!_iconView) {
        _iconView = [[MyTrainingIconView alloc]init];
        [_iconView addGestureRecognizer:self.tap];
        [_iconView setBackgroundColor:[UIColor whiteColor]];
    }
    return _iconView;
}

- (MyTrainingDurationView *)durationView
{
    if (!_durationView) {
        _durationView = [[MyTrainingDurationView alloc]init];
        [_durationView setBackgroundColor:[UIColor whiteColor]];
    }
    return _durationView;
}

- (MyTrainingRecordVoew *)recordView
{
    if (!_recordView) {
        _recordView = [[MyTrainingRecordVoew alloc]init];
        [_recordView setBackgroundColor:[UIColor whiteColor]];
    }
    return _recordView;
}
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    }
    return _tap;
}

- (MyTrainInfoModel *)myTrainInfoModel
{
    if (!_myTrainInfoModel) {
        _myTrainInfoModel = [[MyTrainInfoModel alloc] init];
    }
    return _myTrainInfoModel;
}


- (NSMutableArray<TrainingListInfoModel *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
