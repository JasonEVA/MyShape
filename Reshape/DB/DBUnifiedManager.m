//
//  DBUnifiedManager.m
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "DBUnifiedManager.h"
#import <MagicalRecord/MagicalRecord.h>
//#import "DateUtil.h"
#import "PraiseInfoEntity.h"
#import "TrainingDetailModel.h"
#import "VideoCacheEntity.h"
#import "unifiedUserInfoManager.h"

@implementation DBUnifiedManager

+ (DBUnifiedManager *)share {
    static DBUnifiedManager *DBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBManager = [[self alloc] init];
    });
//    if (![[unifiedUserInfoManager share] loginStatus]) {
//        return nil;
//    }
    return DBManager;
}

#pragma mark - InterfaceMethod

#pragma mark - 点赞信息
- (void)savePraiseInfoWithVideoID:(NSString *)videoID praise:(BOOL)praise {
    PraiseInfoEntity *entity = [PraiseInfoEntity MR_createEntity];
    entity.praise = @(praise);
    entity.videoID = videoID;
    [self saveToPersistent];
}

- (BOOL)queryPraiseInfoWithVideoID:(NSString *)videoID {
    PraiseInfoEntity *entity = [PraiseInfoEntity MR_findFirstByAttribute:@"videoID" withValue:videoID];
    if (entity) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 视频缓存信息
- (void)saveVideoCacheInfoWithVideoModel:(TrainingDetailModel *)model {
    VideoCacheEntity *entity = [VideoCacheEntity MR_findFirstByAttribute:@"videoID" withValue:model.trainingVideoId];
    if (!entity) {
        entity = [VideoCacheEntity MR_createEntity];
    }
    [model covertToEntity:entity];

    [self saveToPersistent];
}

- (TrainingDetailModel *)videoDetailModelWithVideoID:(NSString *)videoID {
    VideoCacheEntity *entity = [VideoCacheEntity MR_findFirstByAttribute:@"videoID" withValue:videoID];
    if (!entity) {
        return nil;
    }
    TrainingDetailModel *model = [[TrainingDetailModel alloc] initWithEntity:entity];
    return model;
}

- (void)saveVideoCacheInfoCompleteWithVideoID:(NSString *)videoID {
    VideoCacheEntity *entity = [VideoCacheEntity MR_findFirstByAttribute:@"videoID" withValue:videoID];
    entity.downloadProgress = @1;
    entity.downloadCompleted = @YES;
    [self saveToPersistent];

}

- (void)clearVideoCacheData {
   [VideoCacheEntity MR_truncateAll];
    [self saveToPersistent];
}
#pragma mark - Private Method
// 保存数据
- (void)saveToPersistent {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
