//
//  BaseRequest.m
//  PalmDoctorPT
//
//  Created by jasonwang on 15/4/7.
//  Copyright (c) 2015年 jasonwang. All rights reserved.
//

#import "BaseRequest.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedResultCodeManager.h"
#import "MyDefine.h"
#import "NSString+Manager.h"
#import "NSDictionary+SafeManager.h"
#import "LoginResultModel.h"

static NSString *const kMessage = @"message";

@implementation BaseResponse
-(void)showServerErrorMessage{
}

@end


@implementation BaseRequest

#pragma mark - Private Method
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 初始化变量
        self.params = [NSMutableDictionary dictionary];
    }
    return self;
}

// 整理必传数据
- (void)configCommonParams
{
}

// 用时间戳和索引值得到文件名 处理附件名字
- (NSString *)getFileNameWithTimeIntervalAndIndex:(NSInteger) index
{
    NSDate *date = [NSDate date];
    NSString *fileName = [NSString stringWithFormat:@"%013.0f%02ld", [date timeIntervalSince1970] * 1000.0, (long)(index % 100)];
    return fileName;
}



- (void)setAuthorizationToken:(AFHTTPRequestSerializer *)serializer {
    
        [serializer setValue:[[unifiedUserInfoManager share] getTokenWithStatus] forHTTPHeaderField:@"Authorization"];
   
}
#pragma mark - Interface Method


// 请求数据整理，子类实现
- (void)prepareRequest
{
    [self configCommonParams];
}

// 返回数据整理，子类实现
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    BaseResponse *res=[[BaseResponse alloc] init];
    res.data=data;
    
    res.message = [data safeValueForKey:kMessage];
    return res;
}

// 请求数据
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];

    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];

    PRINT_JSON_INPUT(self.params, [NSURL URLWithString:urlString]);
    
    [manager POST:urlString parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        [self requestFinished:responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        [self requestFailed:error.userInfo];

    }];
}

// 上传图片
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate data:(NSData *)imageData
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kURLAddress]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];
    
    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];
    
    [manager POST:urlString parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData > formData) {
        [formData appendPartWithFileData:imageData name:@"name" fileName:[NSString stringWithFormat:@"%@.png", [self getFileNameWithTimeIntervalAndIndex:0]] mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        [self requestFinished:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        [self requestFailed:error];
    }];
}

// Get请求
- (void)requestGetWithDelegate:(id<BaseRequestDelegate>)delegate
{
    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];
    [self requestGetWithDelegate:delegate URL:urlString parameters:self.params];
}

// Get请求
- (void)requestGetWithDelegate:(id<BaseRequestDelegate>)delegate URL:(NSString *)urlString parameters:(NSDictionary *)params
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];

    PRINT_JSON_INPUT(params, [NSURL URLWithString:urlString]);
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 成功
        [self requestFinished:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // 失败
        [self requestFailed:error.userInfo];
        
    }];
}

// 文件下载
- (void)requestFileDataWithDelegate:(id<BaseRequestDelegate>)delegate URL:(NSString *)urlString savePath:(NSString *)savePath {
    
    // 是否已下载
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager]; // default is not thread safe
    if ([fileManager fileExistsAtPath:savePath]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:savePath error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    // 代理设置
    self.delegate = delegate;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    if (fileSize > 0) {
        // 下载过则继续下载
        [request setValue:[NSString stringWithFormat:@"bytes=%llu-",fileSize] forHTTPHeaderField:@"Range"];
    }
    NSProgress *progress = nil;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [savePath stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullPath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
        NSLog(@"文件下载完毕---%@",filePath);
    }];
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    //3.启动任务
    [downloadTask resume];
}

//获取并计算当前文件的下载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSProgress *progress = (NSProgress *)object;
    CGFloat progressValue = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
    NSLog(@"%zd--%zd--%f",progress.completedUnitCount,progress.totalUnitCount,progressValue);
    //    [self.introView setCacheProgress:progressValue];
    if ([self.delegate respondsToSelector:@selector(requestWithProgress:)]) {
        [self.delegate requestWithProgress:progressValue];
    }
}
#pragma mark - Delegate
- (void)requestFinished:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucceed:withResponse:)])
    {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            PRINT_JSON_OUTPUT(responseObj);
            BOOL isSuccess = [[UnifiedResultCodeManager share] manageResultCode:responseObj];
            // 成功
            if (isSuccess)
            {
                BaseResponse *response = [BaseResponse new];
                response = [self prepareResponse:responseObj];
                // 整理返回数据
                [self.delegate requestSucceed:self withResponse:response];
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
                {
                    [self requestFailed:responseObj];
                }
            }
        }
    }
}

- (void)requestFailed:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
    {
        BaseResponse *response = [BaseResponse new];
        response = [self prepareResponse:responseObj];
        [self.delegate requestFail:self withResponse:response];
    }
}


- (void)httpFinishRequest:(HttpRequestResponse)finishRequest
           failureRequest:(HttpRequestResponse)failureRequest
{
    [self prepareRequest];
}

@end
