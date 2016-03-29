//
//  VideoSQLManager.h
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrainingDetailModel;

@interface VideoSQLManager : NSObject

/** 单例
 */
+ (VideoSQLManager *)share;

// 插入缓存视频信息
- (void)insertVideoInfoWithModel:(TrainingDetailModel *)model;
@end
