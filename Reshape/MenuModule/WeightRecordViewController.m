//
//  WeightRecordViewController.m
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightRecordViewController.h"
#import "WeightHeaderView.h"
#import <Masonry/Masonry.h>
#import "AddWeightInputView.h"
#import "UIColor+Hex.h"
#import "WeightListTitleView.h"
#import "WeightListView.h"
#import "AddWeightRequest.h"
#import "GetWeightListRequest.h"
#import "WeightListModel.h"
#import "AddTargetWeightRequest.h"
#import "WeightInfoModel.h"
#import <MJRefresh/MJRefresh.h>
#import "WeightListModel.h"
#import "unifiedUserInfoManager.h"

static NSInteger const kPageSize = 10; // 每页条数
@interface WeightRecordViewController ()<WeightHeaderViewDelegate,AddWeightInputViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong)  WeightHeaderView  *headerView; // <##>
@property (nonatomic, strong)  AddWeightInputView *addWeightInputView;
@property (nonatomic, strong)  UIScrollView *myScrollView;
@property (nonatomic, strong)  WeightListTitleView *weightListHeadView;
@property (nonatomic, strong)  WeightListView *weightListView;
@property (nonatomic)  NSInteger  currentIndex; // 当前页
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSMutableArray *allDataList;
@property (nonatomic) CGFloat targetWeight;
@property (nonatomic, strong) WeightListModel *listModel;
@end

@implementation WeightRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的体型"];

    [self configElements];
    if ([[unifiedUserInfoManager share] loginStatus]) {
        [self startRequest];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configConstraints {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(115);
    }];
    
    [self.addWeightInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];

    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.right.left.bottom.equalTo(self.view);
    }];
    
    [self.weightListHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.myScrollView);
        make.height.mas_equalTo(45);
    }];
    [self.weightListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightListHeadView.mas_bottom);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(kPageSize * 60);
    }];
        
}
#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.headerView];
    [self.navigationController.view addSubview:self.addWeightInputView];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView addSubview:self.weightListHeadView];
    [self.myScrollView addSubview:self.weightListView];
    [self configConstraints];
}

- (void)addMoreClick
{
    [self startRequest];
}

- (void)startRequest
{
    GetWeightListRequest *request = [[GetWeightListRequest alloc] init];
    request.pageSize = kPageSize;
    request.pageIndex = self.currentIndex + 1;
    [request requestWithDelegate:self];
    [self.navigationController postLoading];

}

- (void)setMyData
{
    if (self.currentIndex > 1) {
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, (60 * self.allDataList.count) + 50)];
        [self.weightListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weightListHeadView.mas_bottom);
            make.right.left.equalTo(self.view);
            make.height.mas_equalTo(self.allDataList.count * 60);
        }];

    }
    
    [self.headerView.weightGoal setTitle:[NSString stringWithFormat:@"%.f",self.targetWeight] forState:UIControlStateNormal];
    [self.weightListView setViewWithData:self.allDataList targetWeight:self.targetWeight];
}
- (void)restartData
{
    [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 60 * kPageSize + 50)];
    [self.allDataList removeAllObjects];
    self.currentIndex = 0;
    [self.weightListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightListHeadView.mas_bottom);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(kPageSize * 60);
    }];

}


#pragma mark - Event Response

#pragma mark - Delegate
- (void)WeightHeaderViewDelegate_addWeightClick
{
    [self.addWeightInputView.titelLb setText:@"最新体重"];
    [self.addWeightInputView.inputTxf becomeFirstResponder];
    [self.addWeightInputView setHidden:NO];
}
- (void)WeightHeaderViewDelegate_changeTargetWeightClick
{
    [self.addWeightInputView.titelLb setText:@"目标体重"];
    [self.addWeightInputView setHidden:NO];
    [self.addWeightInputView.inputTxf becomeFirstResponder];
}

- (void)AddWeightInputViewDelegateCallBack_saveClick
{
    if ([self.addWeightInputView.titelLb.text isEqualToString:@"最新体重"]) {
        if (self.addWeightInputView.inputTxf.text.length > 0) {
            if ([self.addWeightInputView.inputTxf.text floatValue] < 150 && [self.addWeightInputView.inputTxf.text floatValue] > 30) {
                AddWeightRequest *request = [[AddWeightRequest alloc] init];
                request.weight = [self.addWeightInputView.inputTxf.text floatValue];
                [request requestWithDelegate:self];
                [self.navigationController postLoading];
            } else {
                [self.navigationController postError:@"输入有误"];
            }
        } else {
            [self.navigationController postError:@"请输入体重"];
        }
    } else {
        if ([self.addWeightInputView.inputTxf.text floatValue] < 150 && [self.addWeightInputView.inputTxf.text floatValue] > 30) {
            AddTargetWeightRequest *request = [[AddTargetWeightRequest alloc] init];
            request.weight = [self.addWeightInputView.inputTxf.text floatValue];
            self.targetWeight = request.weight;
            [request requestWithDelegate:self];
            [self.navigationController postLoading];
        } else {
            [self.navigationController postError:@"输入有误"];
        }
    }
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self.navigationController hideLoading];
    [self.navigationController postError:response.message];
    NSLog(@"请求失败");
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self.navigationController hideLoading];
    NSLog(@"请求成功");
    if ([response isKindOfClass:[AddWeightResponse class]]) {
        [self.addWeightInputView setHidden:YES];
        [self.addWeightInputView.inputTxf resignFirstResponder];
        [self restartData];
        [self startRequest];
    } else if ([response isKindOfClass:[GetWeightListResponse class]]) {
        GetWeightListResponse *result = (GetWeightListResponse *)response;
        self.listModel = result.listModel;
        self.currentIndex = result.listModel.pageIndex;
        
        if (result.listModel.pageItems.count > 0) {
            if (result.listModel.pageItems.count == kPageSize && result.listModel.pageIndex < result.listModel.totalPages) {
                [self.myScrollView.mj_footer endRefreshing];
            } else {
                [self.myScrollView.mj_footer endRefreshingWithNoMoreData];
            }
            self.dataList = self.listModel.pageItems;
            [self.allDataList addObjectsFromArray:self.dataList];
            self.targetWeight = self.listModel.targetWeight;
            [self setMyData];
            
        } else {
            [self.myScrollView.mj_footer endRefreshingWithNoMoreData];
        }
    } else if ([response isKindOfClass:[AddTargetWeightResponse class]]) {
        [self.addWeightInputView setHidden:YES];
        [self.addWeightInputView.inputTxf resignFirstResponder];
        [self setMyData];
        
    }
    
}
#pragma mark - Init

- (WeightHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WeightHeaderView alloc] init];
        [_headerView setDelegate:self];
    }
    return _headerView;
}

- (AddWeightInputView *)addWeightInputView
{
    if (!_addWeightInputView) {
        _addWeightInputView = [[AddWeightInputView alloc] init];
        [_addWeightInputView setHidden:YES];
        [_addWeightInputView setDelegate:self];
    }
    return _addWeightInputView;
}

- (UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        [_myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 60 * kPageSize + 50)];
        [_myScrollView setShowsVerticalScrollIndicator:NO];
        _myScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreClick)];
    }
    return _myScrollView;
}
- (WeightListTitleView *)weightListHeadView
{
    if (!_weightListHeadView) {
        _weightListHeadView = [[WeightListTitleView alloc] init];
    }
    return _weightListHeadView;
}

- (WeightListView *)weightListView
{
    if (!_weightListView) {
        _weightListView = [[WeightListView alloc] init];
    }
    return _weightListView;
}
- (NSMutableArray *)allDataList
{
    if (!_allDataList) {
        _allDataList = [[NSMutableArray alloc] init];
    }
    return _allDataList;
}
- (WeightListModel *)listModel
{
    if (!_listModel) {
        _listModel = [[WeightListModel alloc] init];
    }
    return _listModel;
}
@end
