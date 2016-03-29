//
//  TrainingDetailModel.h
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  训练详情model

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import <UIKit/UIKit.h>

@class VideoCacheEntity;

static NSString *const kSQLID = @"SQLID"; //	训练视频ID	String

static NSString *const kTrainingVideoId = @"trainingVideoId"; //	训练视频ID	String
static NSString *const kName = @"name"; //	训练名称	String
static NSString *const kClassifyId = @"classifyId"; //	分类ID	String
static NSString *const kClassifyName = @"classifyName"; //	分类名	String
static NSString *const kConsume = @"consume"; //	训练消耗	Int
static NSString *const kConsumeDescription = @"consumeDescription"; //	训练消耗描述	String
static NSString *const kVideoDescription = @"videoDescription"; //	视频介绍	String
static NSString *const kVideoSourceURL = @"videoSourceURL"; //	训练视频源路径	String
static NSString *const kVideoNativeURL = @"videoNativeURL"; //	训练视频本地路径	String
static NSString *const kDescriptionImage = @"descriptionImage"; //	训练视频背景图	String
static NSString *const kVideoTotalSeconds = @"videoTotalSeconds"; //	视频时长(秒)	Int
static NSString *const kAuthor = @"author"; //	作者	String
//static NSString *const kisSelected = @"isSelected"; //	当前账户是否已选	Boolean
//static NSString *const kshare = @"share"; //	已分享数	Int
//static NSString *const kpraise = @"praise"; //	已点赞数	Int


@interface TrainingDetailModel : NSObject

@property (nonatomic, strong)  NSString  *trainingVideoId; //	训练视频ID	String
@property (nonatomic, strong)  NSString  *name; //	训练名称	String
@property (nonatomic, strong)  NSString  *classifyId; //	分类ID	String
@property (nonatomic, strong)  NSString  *classifyName; //	分类名	String
@property (nonatomic)  NSInteger  consume; //	训练消耗	Int
@property (nonatomic, strong)  NSString  *consumeDescription; //	训练消耗描述	String
@property (nonatomic, strong)  NSString  *videoDescription; //	视频介绍	String
@property (nonatomic, strong)  NSString  *video; //	训练视频文件名	String
@property (nonatomic, strong)  NSString  *videoUrl; //	训练视频路径	String

@property (nonatomic, strong)  NSString  *descriptionImage; //	训练视频背景图	String
@property (nonatomic)  NSInteger  share; //	已分享数	Int
@property (nonatomic)  NSInteger  praise; //	已点赞数	Int
@property (nonatomic)  long  videoTotalSeconds; //	视频时长	TimeSpan
@property (nonatomic)  BOOL  isSelected; //	当前账户是否已选	bool
@property (nonatomic, strong)  NSString  *author; //	作者	String

// 数据库
@property (nonatomic, strong)  NSString  *videoRelativeNativePath; //	视频本地路径,相对路径
@property (nonatomic)  BOOL  downloadComplete; // 是否下载完成
@property (nonatomic)  CGFloat  downloadProgress; // 下载进度

- (instancetype)initWithEntity:(VideoCacheEntity *)entity;

- (void)covertToEntity:(VideoCacheEntity *)entity;

@end
