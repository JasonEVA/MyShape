//
//  TrainingDetailIntroView.h
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
// 训练详情介绍页

#import <UIKit/UIKit.h>

@class TrainingDetailModel;
typedef enum : NSUInteger {
    tag_support,// 点赞
    tag_share,  // 分享
    tag_cache,  // 缓存
} TrainingDetailEventTag;

@protocol TrainingDetailIntroViewDelegate <NSObject>

- (void)trainingDetailIntroViewDelegateCallBack_clickedWithTag:(TrainingDetailEventTag)tag;

@end
@interface TrainingDetailIntroView : UIView

@property (nonatomic, weak)  id<TrainingDetailIntroViewDelegate>  delegate; // <##>

- (void)setTrainingDetailIntroData:(TrainingDetailModel *)model;

// 点赞
- (void)setPraiseCount:(NSInteger)count;

// 分享
- (void)setShareCount:(NSInteger)count;

// 缓存
- (void)setCacheProgress:(CGFloat)progress;

@end
