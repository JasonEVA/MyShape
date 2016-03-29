//
//  VideoPlayView.m
//  Reshape
//
//  Created by jasonwang on 15/11/27.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "VideoPlayView.h"

@interface VideoPlayView()
@end

@implementation VideoPlayView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player {
    if (self = [super init]) {
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        [(AVPlayerLayer *)[self layer] player].usesExternalPlaybackWhileExternalScreenIsActive = YES;
    }
    return self;
}

- (void)setAirPlayMode:(BOOL)airPlay {
    [(AVPlayerLayer *)[self layer] player].allowsExternalPlayback = airPlay;
}

// airplay状态
- (BOOL)airPlayState {
    return [(AVPlayerLayer *)[self layer] player].externalPlaybackActive;
}
@end
