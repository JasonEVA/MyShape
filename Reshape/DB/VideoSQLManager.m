//
//  VideoSQLManager.m
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "VideoSQLManager.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import "unifiedFilePathManager.h"
#import "TrainingDetailModel.h"

static NSString *const kTableVideo = @"Video";
@interface VideoSQLManager()
@property (nonatomic, strong)  FMDatabaseQueue  *DBQueue; // 数据库Queue
@property (nonatomic, strong)  NSString  *SQLPath; // 数据库路径
@end

@implementation VideoSQLManager

#pragma mark - Interface Method
+ (VideoSQLManager *)share {
    static VideoSQLManager *SQLManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SQLManager = [[VideoSQLManager alloc] init];
        [SQLManager updateUserAndCreateTables];
    });
    
    return SQLManager;
}

#pragma mark - insert

- (void)insertVideoInfoWithModel:(TrainingDetailModel *)model {
    [self.DBQueue inDatabase:^(FMDatabase *db) {
        BOOL isExist = [self queryVideoExistWithVideoID:model.trainingVideoId inDatabase:db];
        if (!isExist) {
            // 插入
            NSString *strSQL = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (%@,%@,%@,%@,%ld,%@,%@,%@,%@,%@,%ld,%@)",kTableVideo,
                                kTrainingVideoId,
                                kName,
                                kClassifyId,
                                kClassifyName,
                                kConsume,
                                kConsumeDescription,
                                kVideoDescription,
                                kVideoSourceURL,
                                kVideoNativeURL,
                                kDescriptionImage,
                                kVideoTotalSeconds,
                                kAuthor,
                                model.trainingVideoId,
                                model.name,
                                model.classifyId,
                                model.classifyName,
                                model.consume,
                                model.consumeDescription,
                                model.videoDescription,
                                model.video,
                                model.videoRelativeNativePath,
                                model.descriptionImage,
                                model.videoTotalSeconds,
                                model.author];
            // 创建表
            if (![db executeUpdate:strSQL])
            {
                NSAssert(0, @"---->video表插入失败");
            }
        }
    }];
}

#pragma mark - Pravite Method

// 生成路径并创建表
- (void)updateUserAndCreateTables {
    // 数据库文件路径 ,创建数据库
    self.SQLPath = [NSString stringWithFormat:@"%@/VideoInfo.sqlite",[[unifiedFilePathManager share] getDocumentSubfolderWithFolderName:@"Video"]];
    self.DBQueue = [FMDatabaseQueue databaseQueueWithPath:self.SQLPath];
    // 批量创建数据库和表（自动判断是否存在）
    [self createTables];
}

// 创建表
- (void)createTables
{
    [self.DBQueue inDatabase:^(FMDatabase *db) {
        NSString *strSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@ INTEGER primary key autoincrement,%@ TEXT,%@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT);" ,
                            kTableVideo,
                            kSQLID,
                            kTrainingVideoId,
                            kName,
                            kClassifyId,
                            kClassifyName,
                            kConsume,
                            kConsumeDescription,
                            kVideoDescription,
                            kVideoSourceURL,
                            kVideoNativeURL,
                            kDescriptionImage,
                            kVideoTotalSeconds,
                            kAuthor];
        // 创建表
        if (![db executeUpdate:strSQL])
        {
            NSAssert(0, @"---->video表创建失败");
        }

    }];
}

// 查询视频是否存在
- (BOOL)queryVideoExistWithVideoID:(NSString *)videoID inDatabase:(FMDatabase *)db {
    BOOL isExist = NO;
    NSString *strSQL = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@'",
                            kTableVideo,
                            kTrainingVideoId, videoID];
    FMResultSet *result = [db executeQuery:strSQL];
    while ([result next])
    {
        isExist = YES;
    }
    return isExist;
}
@end
