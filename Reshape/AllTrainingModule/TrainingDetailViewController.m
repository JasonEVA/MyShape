//
//  TrainingDetailViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingDetailViewController.h"
#import <Masonry/Masonry.h>
#import "UIImage+EX.h"
#import "TrainingDetailIntroView.h"
#import "VideoPlayViewController.h"
#import "UIFont+EX.h"
#import "UIColor+Hex.h"
#import "LandscapeNavigationController.h"
#import <UIImageView+WebCache.h>
#import "ShareView.h"
#import "TrainingDetailRequest.h"
#import "TrainingDetailModel.h"
#import "MyTrainAddPraiseRequest.h"
#import "MyTrainAddShareRequest.h"
#import "DBUnifiedManager.h"
#import "TrainAddToMyTrainRequest.h"
#import "DownloadVideoRequest.h"
#import "unifiedFilePathManager.h"
#import "NotifyDefine.h"
#import "unifiedUserInfoManager.h"

@interface TrainingDetailViewController ()<ShareViewDelegate,TrainingDetailIntroViewDelegate,BaseRequestDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)  UIImageView  *imageView; // 视频截图
@property (nonatomic, strong)  UIButton  *imageViewMask; // 视频截图遮罩
@property (nonatomic, strong)  TrainingDetailIntroView  *introView; // 介绍部分
@property (nonatomic, strong)  UIButton  *btnAdd; // 加入训练，开始训练
@property (nonatomic, strong)  UILabel  *uploadUser; // <##>
@property (nonatomic, strong)  ShareView  *shareView; // 分享页面
@property (nonatomic, strong)  UIToolbar  *shareViewBG; // <##>
@property (nonatomic, strong)  UIImageView  *bottomBG; // 底部介绍页倒影背景

@property (nonatomic, strong)  MASConstraint  *shareViewConstraint; // <##>
@property (nonatomic, strong)  TrainingDetailModel  *detailModel; // <##>
@property (nonatomic)  BOOL  cached; // 是否已缓存
@end

@implementation TrainingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dowloadProgressNotification:) name:n_downloadProgress object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestTrainingDetail];
}

- (void)configConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.introView.mas_top);
    }];
    [self.imageViewMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.imageView);
    }];
    [self.bottomBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(210);
    }];

    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bottomBG);
    }];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageViewMask).offset(15);
        make.bottom.right.mas_equalTo(self.imageViewMask).offset(-15);
        make.height.mas_equalTo(@50);
    }];
    [self.uploadUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView).offset(15);
        make.right.mas_equalTo(self.imageView).offset(-15);
        make.height.mas_equalTo(30);
    }];
    [self.shareViewBG mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.introView);
        make.centerX.mas_equalTo(self.view);
        self.shareViewConstraint = make.top.mas_equalTo(self.view.mas_bottom);
    }];
    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.shareViewBG);
    }];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interface Method

- (void)setAdded:(BOOL)added {
    _added = added;
    if (!added) {
        [self.imageViewMask setHidden:NO];
        [self.btnAdd setImage:[UIImage imageNamed:@"trainingDetail_add"] forState:UIControlStateNormal];
        [self.btnAdd setTitle:@"加入训练" forState:UIControlStateNormal];

    } else {
        [self.imageViewMask setHidden:YES];
        [self.btnAdd setImage:[UIImage imageNamed:@"player_playYellow"] forState:UIControlStateNormal];
        [self.btnAdd setTitle:@"开始训练" forState:UIControlStateNormal];
    }
}

#pragma mark - Private Method

// 缓存视频
- (void)downloadVideo {
    if (!self.cached) {
        NSString *nativePath = [[unifiedFilePathManager share] getDocumentDirectoryWithFolderName:@"Video" fileName:self.detailModel.video];
        self.detailModel.videoRelativeNativePath = [[unifiedFilePathManager share] getRelativePathWithAllPath:nativePath];
        [[DBUnifiedManager share] saveVideoCacheInfoWithVideoModel:self.detailModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:n_downloadVideo object:self.detailModel];
    }
}

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.imageViewMask];
    [self.view addSubview:self.bottomBG];
    [self.view addSubview:self.introView];
    [self.imageView addSubview:self.btnAdd];
    [self.imageView addSubview:self.uploadUser];
    [self.view addSubview:self.shareViewBG];
    [self.shareViewBG addSubview:self.shareView];

    [self configConstraints];
}

// 分享显示隐藏
- (void)updateShareViewContraintShow:(BOOL)show {
    self.shareViewConstraint.offset = show ? -210 : 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 请求详情数据
- (void)requestTrainingDetail {
    TrainingDetailRequest *request = [[TrainingDetailRequest alloc] init];
    request.ID = self.videoID;
    [request requestWithDelegate:self];
    [self postLoading];
}

// 点赞
- (void)requestPraise {
    MyTrainAddPraiseRequest *request = [[MyTrainAddPraiseRequest alloc] init];
    request.myId = self.videoID;
    [request requestWithDelegate:self];

}

// 分享
- (void)requestShare {

    MyTrainAddShareRequest *request = [[MyTrainAddShareRequest alloc] init];
    request.myId = self.videoID;
    [request requestWithDelegate:self];

}

// 加入训练
- (void)requestAddToTraining {
    TrainAddToMyTrainRequest *request = [[TrainAddToMyTrainRequest alloc] init];
    request.myId = self.videoID;
    [request requestWithDelegate:self];
}

// 设置页面数据
- (void)configViewData {
    // 查询是否已经缓存
    TrainingDetailModel *modelTemp = [[DBUnifiedManager share] videoDetailModelWithVideoID:self.detailModel.trainingVideoId];
    if (modelTemp) {
        self.detailModel.downloadProgress = modelTemp.downloadProgress;
        self.detailModel.downloadComplete = modelTemp.downloadComplete;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.descriptionImage] placeholderImage:[UIImage imageNamed:@"default_bgImage"]];
    [self.uploadUser setText:[NSString stringWithFormat:@"  By:%@  ",self.detailModel.author]];
    [self.introView setTrainingDetailIntroData:self.detailModel];
    [self.bottomBG sd_setImageWithURL:[NSURL URLWithString:self.detailModel.descriptionImage] placeholderImage:nil];
    [self.navigationItem setTitle:self.detailModel.name];
    self.cached = self.detailModel.downloadComplete;
}

// 使用流量提示
- (void)showNetworkWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"当前使用正在使用数据流量，是否继续？" delegate:self cancelButtonTitle:@"停止" otherButtonTitles:@"继续", nil];
    [alert show];
}
#pragma mark - Event Response

// 遮罩点击播放视频
- (void)playVideo {
    
    if (([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) && !self.cached && [[unifiedUserInfoManager share] getSwitchStatusWithTag:tag_flow]) {
        [self showNetworkWarning];
    } else {
        [self switchToVideoPlayVC];
    }

}

// 进入播放页
- (void)switchToVideoPlayVC {
    NSLog(@"-------------->播放视频");
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc] init];
    videoPlayVC.cached = self.cached;
    videoPlayVC.detailModel = self.detailModel;
    videoPlayVC.added = self.added;
    LandscapeNavigationController *navi = [[LandscapeNavigationController alloc] initWithRootViewController:videoPlayVC];
    [self presentViewController:navi animated:NO completion:nil];

}
// 加入视频
- (void)addVideoClicked:(UIButton *)sender {
    NSLog(@"-------------->%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);

    if (self.added) {
        // 开始训练
        [self playVideo];
    } else {
        // 加入训练
        [self requestAddToTraining];
        
    }
}
#pragma mark - Notification
- (void)dowloadProgressNotification:(NSNotification *)noti {
    NSLog(@"-------------->%@",noti);
    NSDictionary *dict = noti.object;
    if ([dict[@"videoID"] isEqualToString:self.detailModel.trainingVideoId]) {
        CGFloat progress = [dict[@"progress"] floatValue];
        [self.introView setCacheProgress:progress];
        if (progress >= 1) {
            self.cached = YES;
            self.detailModel.downloadProgress = 1.0;
            self.detailModel.downloadComplete = YES;
            [[DBUnifiedManager share] saveVideoCacheInfoCompleteWithVideoID:self.detailModel.trainingVideoId];
        }

    }

}
#pragma mark - Delegate

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 使用流量播放视频
        [self switchToVideoPlayVC];
    }
}
#pragma mark - Request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response {
    [self hideLoading];
    if ([response isKindOfClass:[TrainingDetailResponse class]]) {
        TrainingDetailResponse *result = (TrainingDetailResponse *)response;
        self.detailModel = result.detailModel;
        [self configViewData];
    } else if ([response isKindOfClass:[MyTrainAddPraiseResponse class]]) {
        // 点赞
        self.detailModel.praise += 1;
        [self.introView setPraiseCount:self.detailModel.praise];
    } else if ([response isKindOfClass:[MyTrainAddShareResponse class]]) {
        // 分享
        self.detailModel.share += 1;
        [self.introView setShareCount:self.detailModel.share];
    } else if ([response isKindOfClass:[TrainAddToMyTrainResponse class]]) {
        // 加入训练
        self.added = YES;
        
        // 如果打开自动缓存开关则下载视频
        if ([[unifiedUserInfoManager share] getSwitchStatusWithTag:tag_autoCache]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:n_downloadVideo object:self.detailModel];
        }
    }
    
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response {
    [self postError:response.message];
}

#pragma mark - ShareViewDelegate

- (void)shareViewDelegateCallBack_shareClickedWithTag:(ShareViewTag)shareTag {
    [self updateShareViewContraintShow:NO];
    NSLog(@"-------------->%lu",(unsigned long)shareTag);

    // TODO:分享成功后想服务器请求
    [self requestShare];
}

- (void)shareViewDelegateCallBack_shareCancelClicked {
    [self updateShareViewContraintShow:NO];
    
}

#pragma mark - TrainingDetailIntroViewDelegate

- (void)trainingDetailIntroViewDelegateCallBack_clickedWithTag:(TrainingDetailEventTag)tag {
    switch (tag) {
        case tag_support:
            // 点赞
            [self requestPraise];
            break;
            
        case tag_share:
            // 分享

            [self updateShareViewContraintShow:YES];
            break;
            
        case tag_cache:
            // 缓存
            [self downloadVideo];
            break;
            
        default:
            break;
    }
}
#pragma mark - Init

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor themeImageBackgroundColor]];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageView;
}

- (UIButton *)imageViewMask {
    if (!_imageViewMask) {
        _imageViewMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageViewMask setBackgroundImage:[UIImage imageWithColor:[UIColor colorMaskBlack] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_imageViewMask setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_imageViewMask addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageViewMask;
}

- (TrainingDetailIntroView *)introView {
    if (!_introView) {
        _introView = [[TrainingDetailIntroView alloc] init];
        [_introView setDelegate:self];
    }
    return _introView;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAdd setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.8] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnAdd.titleLabel setFont:[UIFont themeFontOfSize:17]];
        [_btnAdd setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateNormal];
        [_btnAdd.layer setCornerRadius:3];
        [_btnAdd.layer setMasksToBounds:YES];
        [_btnAdd addTarget:self action:@selector(addVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (UILabel *)uploadUser {
    if (!_uploadUser) {
        _uploadUser = [[UILabel alloc] init];
        [_uploadUser setBackgroundColor:[UIColor grayColor]];
        [_uploadUser setText:@"  Shape官方  "];
        [_uploadUser setTextColor:[UIColor whiteColor]];
        [_uploadUser setFont:[UIFont systemFontOfSize:13]];
        [_uploadUser.layer setCornerRadius:15];
        [_uploadUser.layer setMasksToBounds:YES];
    }
    return _uploadUser;
}

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ShareView alloc] init];
        [_shareView setDelegate:self];
    }
    return _shareView;
}

- (UIToolbar *)shareViewBG {
    if (!_shareViewBG) {
        _shareViewBG = [[UIToolbar alloc] init];
        [_shareViewBG setBarStyle:UIBarStyleBlack];
    }
    return _shareViewBG;
}

- (UIImageView *)bottomBG {
    if (!_bottomBG) {
        _bottomBG = [[UIImageView alloc] init];
        [_bottomBG setClipsToBounds:YES];
        [_bottomBG setContentMode:UIViewContentModeScaleAspectFill];
        _bottomBG.transform = CGAffineTransformMakeScale(1.0, -1.0);
    }
    return _bottomBG;
}
@end
