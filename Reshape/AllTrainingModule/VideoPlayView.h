//
//  VideoPlayView.h
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  视频播放页面

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView : UIView
- (instancetype)initWithPlayer:(AVPlayer *)player;

// 设置airplay
- (void)setAirPlayMode:(BOOL)airPlay;

// airplay状态
- (BOOL)airPlayState;
@end
