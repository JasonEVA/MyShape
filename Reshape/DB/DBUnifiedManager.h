//
//  DBUnifiedManager.h
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  数据库统一管理工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TrainingDetailModel;

@interface DBUnifiedManager : NSObject

+ (DBUnifiedManager *)share;
#pragma mark - InterfaceMethod

// 点赞分享
- (void)savePraiseInfoWithVideoID:(NSString *)videoID praise:(BOOL)praise;
- (BOOL)queryPraiseInfoWithVideoID:(NSString *)videoID;

// 视频缓存信息
- (void)saveVideoCacheInfoWithVideoModel:(TrainingDetailModel *)model;
- (TrainingDetailModel *)videoDetailModelWithVideoID:(NSString *)videoID;
- (void)saveVideoCacheInfoCompleteWithVideoID:(NSString *)videoID;
- (void)clearVideoCacheData;
@end
