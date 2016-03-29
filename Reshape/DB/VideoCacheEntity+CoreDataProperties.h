//
//  VideoCacheEntity+CoreDataProperties.h
//  Reshape
//
//  Created by jasonwang on 15/12/11.
//  Copyright © 2015年 jasonwang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VideoCacheEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCacheEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *classifyID;
@property (nullable, nonatomic, retain) NSString *classifyName;
@property (nullable, nonatomic, retain) NSNumber *consume;
@property (nullable, nonatomic, retain) NSString *consumeDescription;
@property (nullable, nonatomic, retain) NSNumber *downloadCompleted;
@property (nullable, nonatomic, retain) NSNumber *downloadProgress;
@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSString *videoDescription;
@property (nullable, nonatomic, retain) NSString *videoID;
@property (nullable, nonatomic, retain) NSNumber *videoLength;
@property (nullable, nonatomic, retain) NSString *videoNativePath;
@property (nullable, nonatomic, retain) NSString *videoScreenshotPath;
@property (nullable, nonatomic, retain) NSString *videoSourcePath;
@property (nullable, nonatomic, retain) NSString *videoTheme;

@end

NS_ASSUME_NONNULL_END
