//
//  TrainingDetailModel.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingDetailModel.h"
#import "VideoCacheEntity.h"

@implementation TrainingDetailModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if (property.type.typeClass == [NSString class]) {
            oldValue = @"";
        }
    }
    return oldValue;
}


- (instancetype)initWithEntity:(VideoCacheEntity *)entity
{
    self = [super init];
    if (self) {
        // 从entity初始化
        self.trainingVideoId = entity.videoID;
        self.video = entity.fileName;
        self.classifyId = entity.classifyID;
        self.classifyName = entity.classifyName;
        self.consume = entity.consume.integerValue;
        self.consumeDescription = entity.consumeDescription;
        self.videoDescription = entity.videoDescription;
        self.videoUrl = entity.videoSourcePath;
        self.videoRelativeNativePath = entity.videoNativePath;
        self.descriptionImage = entity.videoScreenshotPath;
        self.videoTotalSeconds = entity.videoLength.integerValue;
        self.author = entity.author;
        self.name = entity.videoTheme;
        self.downloadComplete = entity.downloadCompleted.boolValue;
        self.downloadProgress = entity.downloadProgress.floatValue;
    }
    return self;
}

- (void)covertToEntity:(VideoCacheEntity *)entity {
    entity.videoID = self.trainingVideoId;
    entity.videoTheme = self.name;
    entity.classifyID = self.classifyId;
    entity.classifyName = self.classifyName;
    entity.consume = @(self.consume);
    entity.consumeDescription = self.consumeDescription;
    entity.videoDescription = self.videoDescription;
    entity.videoSourcePath = self.videoUrl;
    entity.videoNativePath = self.videoRelativeNativePath;
    entity.videoScreenshotPath = self.descriptionImage;
    entity.videoLength = @(self.videoTotalSeconds);
    entity.author = self.author;
    entity.fileName = self.video;
    entity.downloadProgress = @(self.downloadProgress);
    entity.downloadCompleted = @(self.downloadComplete);
}

@end
