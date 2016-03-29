//
//  VideoPlayViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "VideoPlayView.h"
#import <Masonry/Masonry.h>
#import "UIImage+EX.h"
#import "VideoProgressView.h"
#import "VolumeProgressView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ShareView.h"
#import "UIColor+Hex.h"
#import "MyTrainAddPraiseRequest.h"
#import "MyTrainAddShareRequest.h"
#import "DBUnifiedManager.h"
#import "MyTrainAddRecordRequest.h"
#import "TrainingDetailModel.h"
#import "NotifyDefine.h"
#import "unifiedFilePathManager.h"
#import "UIViewController+Loading.h"

typedef enum : NSUInteger {
    tag_screenshot = 0,
    tag_support,
    tag_share,
    tag_cache,
    tag_airPlay
} RightItemTag;

typedef enum : NSUInteger {
    tag_default,
    tag_volume,
    tag_brightness,
    tag_progress,
} PanGestureDirection;

@interface VideoPlayViewController ()<VideoProgressViewDelegate,VolumeProgressViewDelegate,ShareViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) AVPlayer *player; // 播放器对象
@property (nonatomic, strong)  VideoPlayView  *container; // 播放器容器
@property (nonatomic, strong)  UIImageView  *maskView; // 遮罩
@property (nonatomic, strong)  VideoProgressView  *videoProgress; // 播放进度
@property (nonatomic, strong)  VolumeProgressView  *volumeProgress; // 音量
@property (nonatomic, strong)  UIButton  *btnPlay; // 播放按钮
@property (nonatomic, strong)  ShareView  *shareView; // 分享页面
@property (nonatomic, strong)  UIButton  *airPlayButtonContainer; // airplay按钮容器
@property (nonatomic, strong)  UIButton  *backButton; // 返回按钮
@property (nonatomic, strong)  UILabel  *shareTitle; // 分享时显示的title

@property (nonatomic)  CGFloat defaultBrightness; // 保存原始亮度，结束播放系统需要置为这个值
@property (nonatomic)  CGFloat videoLength; // 总时间
@property (nonatomic)  CMTime currentTime; // 当前时间
@property (nonatomic)  CGPoint  panGestureBeganPoint; // <##>
@property (nonatomic, strong)  NSMutableArray<UIBarButtonItem *>  *arrayItems; // <##>

@property (nonatomic)  PanGestureDirection  direction; // <##>

@property (nonatomic, strong)  MASConstraint  *videoProgressConstraint; // <##>
@property (nonatomic, strong)  MASConstraint  *shareViewConstraint; // <##>

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    [self.navigationItem setLeftBarButtonItem:item];
    NSArray *arrayImage = @[[UIImage imageNamed:@"player_camera"],[UIImage imageNamed:@"player_support"],[UIImage imageNamed:@"player_share"],[UIImage imageNamed:@"player_cache"],[UIImage imageNamed:@"player_airPlay"]];
    for (UIImage *image in arrayImage) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemsClicked:)];
        [item setTag:(RightItemTag)(tag_screenshot + self.arrayItems.count)];
        [self.arrayItems insertObject:item atIndex:0];
    }
    [self.navigationItem setRightBarButtonItems:self.arrayItems];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configElements];
    [self postLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.volumeProgress configVolume];
    [self.player play];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIScreen mainScreen].brightness = self.defaultBrightness;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"-------------->%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);
    
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}

- (void)configConstraints {
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.volumeProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView);
        make.left.equalTo(self.maskView.mas_left).offset(-65);
        make.width.mas_equalTo(@180);
        make.height.mas_equalTo(@55);
    }];
    [self.videoProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        self.videoProgressConstraint = make.top.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.maskView);
        make.height.equalTo(@50);
    }];
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
    }];
    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(450);
        make.height.mas_equalTo(225);
        make.centerX.equalTo(self.view);
        self.shareViewConstraint = make.top.equalTo(self.view.mas_bottom);
    }];
    [self.shareTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.shareView.mas_top);
    }];
    
}
#pragma mark - Interface Method

#pragma mark - Private Method

// 视频进度
- (void)updateVideoProgressContraintShow:(BOOL)show {
    self.videoProgressConstraint.offset = show ? -55 : 0;
        [self.view layoutIfNeeded];
}

// 分享显示隐藏
- (void)updateShareViewContraintShow:(BOOL)show {
    self.shareViewConstraint.offset = show ? -225 : 0;
    self.shareTitle.hidden = !show;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 亮度调节
- (void)configBrightnessUp:(BOOL)up {
    if (up) {
        [UIScreen mainScreen].brightness += 0.01;
    } else {
        [UIScreen mainScreen].brightness -= 0.01;
    }
}

// 暂停/开始播放
- (void)switchPlayerStatePlay:(BOOL)play {
    if (play) {
        [self.player play];
        [self.btnPlay setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        
    } else {
        [self.player pause];
        [self.btnPlay setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }

}

// 隐藏视频控件实现
- (void)hideVideoControlKit {
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.navigationController setNavigationBarHidden:YES animated:YES];
                         self.volumeProgress.hidden = YES;
                         [self updateVideoProgressContraintShow:NO];
                         self.btnPlay.hidden = YES;
                         [self.maskView setBackgroundColor:[UIColor clearColor]];
                     }];

}

// 显示视频控件
- (void)showVideoControlKit {
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.navigationController setNavigationBarHidden:NO animated:YES];
                         self.volumeProgress.hidden = NO;
                         [self updateVideoProgressContraintShow:YES];
                         self.btnPlay.hidden = NO;
                         [self.maskView setBackgroundColor:[UIColor colorMaskBlack]];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self hideVideoControlKitAfterDelay:2.0 animateWithDuration:1.0];
                         }
                     }];
}

// 隐藏视频控制控件
- (void)hideVideoControlKitAfterDelay:(NSTimeInterval)delay animateWithDuration:(NSTimeInterval)duration {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideVideoControlKit) withObject:nil afterDelay:delay];
}

// 显示视频控制控件
- (void)showControlKitAnimateWithDuration:(NSTimeInterval)duration {
    [self showVideoControlKit];
}

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.container];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.volumeProgress];
    [self.view addSubview:self.videoProgress];
    [self.view addSubview:self.btnPlay];
    [self.view addSubview:self.shareView];
    [self.view addSubview:self.shareTitle];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.volumeProgress.hidden = YES;
    self.btnPlay.hidden = YES;
    self.shareTitle.hidden = YES;
    
    [self.arrayItems[self.arrayItems.count - tag_support - 1] setEnabled:![[DBUnifiedManager share] queryPraiseInfoWithVideoID:self.detailModel.trainingVideoId]];
    [self.arrayItems[self.arrayItems.count - tag_cache - 1] setEnabled:!self.cached];

    self.defaultBrightness = [UIScreen mainScreen].brightness;
    // 添加播放器通知
    [self addNotification];

    [self configConstraints];
}


/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
- (AVPlayerItem *)getPlayItem:(NSInteger)videoIndex {
    NSURL *url;
    if (self.cached) {
        TrainingDetailModel *model = [[DBUnifiedManager share] videoDetailModelWithVideoID:self.detailModel.trainingVideoId];
        url=[NSURL fileURLWithPath:[[unifiedFilePathManager share] getAllPathWithRelativePath:model.videoRelativeNativePath]];
    } else {
        url = [NSURL URLWithString:self.detailModel.videoUrl];
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

// 点赞
- (void)requestPraise {
    MyTrainAddPraiseRequest *request = [[MyTrainAddPraiseRequest alloc] init];
    request.myId = self.detailModel.trainingVideoId;
    [request requestWithDelegate:self];
    
}

// 分享
- (void)requestShare {
    MyTrainAddShareRequest *request = [[MyTrainAddShareRequest alloc] init];
    request.myId = self.detailModel.trainingVideoId;
    [request requestWithDelegate:self];
    
}

// 结束训练，记录
- (void)requestFinishTraining {
    MyTrainAddRecordRequest *request = [[MyTrainAddRecordRequest alloc] init];
    request.myId = self.detailModel.trainingVideoId;
    [request requestWithDelegate:self];
}
#pragma mark - 通知
/**
 *  添加播放器通知
 */
- (void)addNotification {
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    [self updateShareViewContraintShow:YES];

    if (self.added) {
        [self requestFinishTraining];
    }
}
#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
- (void)addProgressObserver {
    __weak typeof(self) weakSelf = self;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGFloat currentTime =  CMTimeGetSeconds(time);
        strongSelf.currentTime = time;
//        NSLog(@"当前进度%.2fs.",currentTime);
        if (currentTime) {
            [strongSelf.videoProgress setVideoCurrentTime:currentTime totalTime:strongSelf.videoLength];
        }
    }];
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            self.videoLength = CMTimeGetSeconds(playerItem.duration);
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
        CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        [self.videoProgress setVideoCachedTime:totalBuffer totalTime:self.videoLength];
        [self hideLoading];
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
- (UIImage *)thumbnailImageRequest:(CMTime)timeBySecond{
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:self.player.currentItem.asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    //    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 600);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:timeBySecond actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    CGImageRelease(cgImage);
    
    return image;
}


#pragma mark - Event Response

- (void)cancel {
    [self switchPlayerStatePlay:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 播放暂停按钮
- (void)playButtonClicked {
    [self playAndPauseVideo];
}

// 视频播放暂停
- (void)playAndPauseVideo {
    if (self.player.rate == 0) {
        [self switchPlayerStatePlay:YES];
        
    } else {
        [self switchPlayerStatePlay:NO];
    }
}

// 导航栏按钮事件
- (void)barButtonItemsClicked:(UIBarButtonItem *)sender {
    [self switchPlayerStatePlay:NO];
    [self hideVideoControlKitAfterDelay:0 animateWithDuration:0];
    RightItemTag tag = (RightItemTag)sender.tag;
    switch (tag) {
        case tag_screenshot:
            // 截屏
        {
            [self.maskView setImage:[UIImage imageNamed:@"player_screenshot"]];
            UIImage *temp = [self thumbnailImageRequest:self.currentTime];
            UIImage *logoImage = [UIImage imageAddWatermarkToImage:temp maskImage:[UIImage imageNamed:@"me_icon"]];
            UIImageWriteToSavedPhotosAlbum(logoImage,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            
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
            [[NSNotificationCenter defaultCenter] postNotificationName:n_downloadVideo object:nil];
            break;
            
            
        case tag_airPlay:
            // airplay
            [self.container airPlayState] ? NSLog(@"正在使用airplay") : NSLog(@"未使用airplay") ;
            [self.airPlayButtonContainer sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
            
 
        default:
            break;
    }
}


// 显示/隐藏视频控制控件手势事件
- (void)videoViewTaped:(UITapGestureRecognizer *)gesture {
    if (self.navigationController.navigationBar.isHidden) {
        [self showControlKitAnimateWithDuration:0.4];
    } else {
        [self hideVideoControlKitAfterDelay:0.0 animateWithDuration:0.4];
    }
}

// 手指拖动事件
- (void)panGestureEventResponse:(UIPanGestureRecognizer *)gesture {
    CGPoint locationPoint = [gesture locationInView:self.view]; // 点击的位置
    CGPoint translatedPoint = [gesture translationInView:self.view];
    NSLog(@"gesture translatedPoint  is %@", NSStringFromCGPoint(translatedPoint));
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 确定方向
        // 处理绝对值
        NSInteger x = fabs(translatedPoint.x);
        NSInteger y = fabs(translatedPoint.y);
        
        if (x > y) {
            // 调整视频进度
            self.direction = tag_progress;
        } else {
            if (locationPoint.x > gesture.view.center.x) {
                // 右边，调整亮度
                self.direction = tag_brightness;

            } else {
                // 左边，调整声音
                self.direction = tag_volume;
            }
        }

    } else if (gesture.state == UIGestureRecognizerStateChanged) {
         // 变化位置
        switch (self.direction) {
            case tag_progress:
            {
                [self updateVideoProgressContraintShow:YES];
                [self.videoProgress switchVideoProgressForword:translatedPoint.x > 0 ? YES : NO];
                break;
            }
                
            case tag_volume:
            {
                [self.volumeProgress setHidden:NO];
                [self.volumeProgress switchVolumeProgressUp:translatedPoint.y < 0 ? YES : NO];
                break;
            }
                
            case tag_brightness:
            {
                [self configBrightnessUp:translatedPoint.y < 0 ? YES : NO];
                break;
            }
 
            default:
                break;
        }

    } else {
        [self hideVideoControlKitAfterDelay:2 animateWithDuration:0.4];
        // 重置方向
        self.direction = tag_default;

     }
}
#pragma mark - Delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if(error) {
        
        NSLog(@"-------------->失败");
    }else{
        NSLog(@"-------------->成功");
        [self updateShareViewContraintShow:YES];

    }
}

#pragma mark - ShareViewDelegate

- (void)shareViewDelegateCallBack_shareClickedWithTag:(ShareViewTag)shareTag {
    [self.maskView setImage:nil];
    [self updateShareViewContraintShow:NO];
    NSLog(@"-------------->%d",shareTag);
    // TODO:分享成功后想服务器请求
    [self requestShare];

}

- (void)shareViewDelegateCallBack_shareCancelClicked {
    [self.maskView setImage:nil];

    [self updateShareViewContraintShow:NO];

}

#pragma mark - VolumeDelegate

- (void)volumeProgressViewDelegateCallBack_volumePercentage:(CGFloat)volumePercentage {

}
#pragma mark - VideoDelegate

- (void)videoProgressViewDelegateCallBack_videoPercentage:(CGFloat)videoPercentage {
    [self switchPlayerStatePlay:NO];
    [self.player seekToTime:CMTimeMake((videoPercentage * self.videoLength), 1.0)];
}

#pragma mark - Request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response {
    if ([response isKindOfClass:[MyTrainAddPraiseResponse class]]) {
        [self postSuccess:@"点赞成功"];
        // 数据库记录
        [[DBUnifiedManager share] savePraiseInfoWithVideoID:self.detailModel.trainingVideoId praise:YES];
        [self.arrayItems[self.arrayItems.count - tag_support - 1] setEnabled:![[DBUnifiedManager share] queryPraiseInfoWithVideoID:self.detailModel.trainingVideoId]];

    } else if ([response isKindOfClass:[MyTrainAddShareResponse class]]) {
        // 分享
        
    }
    
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response {
    
}

#pragma mark - Init

- (VideoPlayView *)container {
    if (!_container) {
        _container = [[VideoPlayView alloc] initWithPlayer:self.player];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTaped:)];
        [_container addGestureRecognizer:gest];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEventResponse:)];
        [_container addGestureRecognizer:panGesture];
        [gest requireGestureRecognizerToFail:panGesture];
    }
    return _container;
}

- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        // 监控进度条
        [self addProgressObserver];
        
        // 监控playerItem状态
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}

- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];
    }
    return _maskView;
}

- (VideoProgressView *)videoProgress {
    if (!_videoProgress) {
        _videoProgress = [[VideoProgressView alloc] init];
        [_videoProgress setDelegate:self];
    }
    return _videoProgress;
}

- (VolumeProgressView *)volumeProgress {
    if (!_volumeProgress) {
        _volumeProgress = [[VolumeProgressView alloc] initWithVolumePercentage:0];
        [_volumeProgress setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        [_volumeProgress setDelegate:self];
    }
    return _volumeProgress;
}

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}

// airPlay按钮容器
- (UIButton *)airPlayButtonContainer {
    if (!_airPlayButtonContainer) {
        // airPlay傀儡，只为取出airPlay按钮，MPVolumeView需要加到当前的界面中才能显示
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 0, 0)];
        [self.view addSubview:volumeView];
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPButton"]){
                _airPlayButtonContainer = (UIButton *)view;
                break;
            }
        }

    }
    return _airPlayButtonContainer;
}

// 返回按钮
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; // 左对齐
        [_backButton setFrame:CGRectMake(0, 0, 220, 44)];
        [_backButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_backButton setTitle:self.detailModel.name forState:UIControlStateNormal];
        [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_backButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _backButton;
}

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ShareView alloc] init];
        [_shareView setDelegate:self];
    }
    return _shareView;
}

- (UILabel *)shareTitle {
    if (!_shareTitle) {
        _shareTitle = [[UILabel alloc] init];
        [_shareTitle setText:self.detailModel.name];
        [_shareTitle setFont:[UIFont systemFontOfSize:22]];
        [_shareTitle setTextColor:[UIColor whiteColor]];
        [_shareTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return _shareTitle;
}

- (NSMutableArray *)arrayItems {
    if (!_arrayItems) {
        _arrayItems = [NSMutableArray array];
    }
    return _arrayItems;
}
@end
