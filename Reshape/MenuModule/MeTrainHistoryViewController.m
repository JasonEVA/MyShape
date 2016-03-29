//
//  MeTrainHistoryViewController.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  训练历史页面

#import "MeTrainHistoryViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MeTrainHistoryCell.h"
#import "MeTrainHistoryListModel.h"
#import "MeFooterView.h"
#import "MeGetTrainHistoryRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "unifiedUserInfoManager.h"

#define ROWHIGHT      80
#define kPageSize     10

@interface MeTrainHistoryViewController()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) MeFooterView *footView;
@property (nonatomic, strong) MeTrainHistoryListModel *model;
@property (nonatomic, copy) NSMutableArray<MeTrainHistoryDetailModel *> *trainHistoryList;
@property (nonatomic, strong) UILabel *noDataLb;
@property (nonatomic)  NSInteger  currentIndex; // 当前页


@end
@implementation MeTrainHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"播放历史"];
    [self.view setBackgroundColor:[UIColor themeBackground_f3f0eb]];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noDataLb];
    [self.tableView addSubview:self.footView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.noDataLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
    self.currentIndex = 0;
    if ([[unifiedUserInfoManager share] loginStatus]) {
        [self startRequest];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trainHistoryList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    MeTrainHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MeTrainHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell setMyContent:self.trainHistoryList[indexPath.row] indexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark -private method

- (void)startRequest
{
    MeGetTrainHistoryRequest *request = [[MeGetTrainHistoryRequest alloc]init];
    request.pageIndex = self.currentIndex + 1;
    request.pageSize = kPageSize;
    [request requestWithDelegate:self];
    [self postLoading];
}

- (void)addMoreClick
{
    [self startRequest];
}
#pragma mark - event Response


#pragma mark - request Delegate
-(void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
    [self hideLoading];
    [self postError:response.message];
    [self.tableView.mj_footer endRefreshing];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
    MeGetTrainHistoryResponse *result = (MeGetTrainHistoryResponse *)response;
    self.model = result .model;
    self.currentIndex = result.model.pageIndex;
    if (result.model.pageItems.count > 0) {
        [self.trainHistoryList addObjectsFromArray:result.model.pageItems];
        if (result.model.pageItems.count == kPageSize && result.model.pageIndex < result.model.totalPages) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.trainHistoryList.count > 0) {
        [self.tableView setHidden:NO];
        [self.noDataLb setHidden:YES];
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView setHidden:YES];
        [self.noDataLb setHidden:NO];
    }
    
}

#pragma mark - updateViewConstraints
#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
                [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setHidden:YES];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreClick)];
    }
    return _tableView;
}

- (MeFooterView *)footView
{
    if (!_footView) {
        _footView = [[MeFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ROWHIGHT)];
    }
    return _footView;
}

- (MeTrainHistoryListModel *)model
{
    if (!_model) {
        _model = [[MeTrainHistoryListModel alloc]init];
    }
    return _model;
}
- (UILabel *)noDataLb
{
    if (!_noDataLb) {
        _noDataLb = [[UILabel alloc] init];
        [_noDataLb setText:@"暂无播放记录"];
        _noDataLb.font = [UIFont systemFontOfSize:30];
        [_noDataLb setTextColor:[UIColor colorMyLightGray_959595]];
        [_noDataLb setHidden:NO];
    }
    return _noDataLb;
}

- (NSMutableArray<MeTrainHistoryDetailModel *> *)trainHistoryList
{
    if (!_trainHistoryList) {
        _trainHistoryList = [[NSMutableArray alloc] init];
    }
    return _trainHistoryList;
}
@end

