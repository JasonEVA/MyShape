//
//  AppDelegate.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewManager.h"
#import "UIColor+Hex.h"
#import <MagicalRecord/MagicalRecord.h>
#import "unifiedUserInfoManager.h"
#import "LoginResultModel.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "GetLevelRequest.h"
#import "NotifyDefine.h"
#import "BreakpointResumeRequest.h"
#import "TrainingDetailModel.h"
#import "unifiedFilePathManager.h"

@interface AppDelegate ()<BaseRequestDelegate,BreakpointResumeRequestDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)  TrainingDetailModel  *videoModelTemp; // <##>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[RootViewManager share] loginQueue];
    [self.window setBackgroundColor:[UIColor themeBackground_f3f0eb]];
    
    // 网络检测
    [self monitorNetwork];
    
    //首次启动请求等级信息
    [self getLevelInfo];
    
    // 增加监听
    [self addNotification];
    
    // 数据库初始化
    LoginResultModel *loginModel = [[unifiedUserInfoManager share] getLoginResultData];
    if (loginModel.token.length > 0) {
        // 创建数据库
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/%@/Shape.Sqlite",loginModel.phone]];
    } else {
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/Tourist/Shape.Sqlite"]];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // 清理APP
    [MagicalRecord cleanUp];

}

#pragma mark - Private Method

// 增加监听
- (void)addNotification {
    // 视频下载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVideo:) name:n_downloadVideo object:nil];

}

// 网络检测
- (void)monitorNetwork {
    // 网络状态标识
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    // 网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkstatues:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

}
// 网络下载提示
- (void)showCellularWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"当前使用正在使用数据流量，是否继续？" delegate:self cancelButtonTitle:@"停止" otherButtonTitles:@"继续", nil];
    [alert show];
}

// 下载视频
- (void)dowloadVideoWithVideoModel:(TrainingDetailModel *)model {
    BreakpointResumeRequest *request = [[BreakpointResumeRequest alloc] init];
    request.videoID = model.trainingVideoId;
    [request requestOperationDownloadFileDataWithDelegate:self URL:model.videoUrl savePath:[[unifiedFilePathManager share] getAllPathWithRelativePath:model.videoRelativeNativePath]];
}

//首次启动请求等级信息
- (void)getLevelInfo
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        GetLevelRequest *request = [[GetLevelRequest alloc] init];
        [request requestWithDelegate:self];
    }
}

#pragma mark - Notification
//网络监听
- (void)networkstatues:(NSNotification*)noti{
    NSArray *keys = noti.userInfo.allKeys;
    if(noti.userInfo && noti.userInfo.allKeys.count > 0 && [keys containsObject:AFNetworkingReachabilityNotificationStatusItem]){
        AFNetworkReachabilityStatus status=[[noti.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] intValue];
        NSLog(@"----网络状态:%ld",status);
        //有网络
//        if(stats>=AFNetworkReachabilityStatusReachableViaWWAN){
//            [DictServerCacheUtil cacheServerDictForCode:Dict_code_health_set complete:nil];
//        }
    }
    NSLog(@"noti.userInfo:%@",noti.userInfo);
}

// 下载视频
- (void)downloadVideo:(NSNotification *)noti {
    self.videoModelTemp = noti.object;
    if (([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) && [[unifiedUserInfoManager share] getSwitchStatusWithTag:tag_flow]) {
        [self showCellularWarning];
    } else {
        [self dowloadVideoWithVideoModel:self.videoModelTemp];
    }
    self.videoModelTemp = nil;
}

#pragma mark - BreakpointResume Deletate
- (void)requestBreakpointResumeWithRequest:(BreakpointResumeRequest *)request progress:(CGFloat)progress {
    NSDictionary *dict = @{@"videoID":request.videoID,@"progress":@(progress)};
    [[NSNotificationCenter defaultCenter] postNotificationName:n_downloadProgress object:dict];
}

- (void)requestBreakpointResumeComplete:(BreakpointResumeRequest *)request {
    NSLog(@"-------------->compelete");
}

#pragma mark - Delegate
- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    GetLevelResponse *result = (GetLevelResponse *)response;
    NSLog(@"%@",result.modelArr);
    NSMutableArray *mutArr = [[NSMutableArray alloc ]init];
    for (NSInteger i = 0; i < result.modelArr.count ; i++) {
        [mutArr addObject:[NSString stringWithFormat:@"%ld",(long)result.modelArr[i].limit]];
    }
    [[unifiedUserInfoManager share] saveLevelInfo:mutArr];
}
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 下载
        [self dowloadVideoWithVideoModel:self.videoModelTemp];
    }
}
@end
