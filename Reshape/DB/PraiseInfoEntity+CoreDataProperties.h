//
//  PraiseInfoEntity+CoreDataProperties.h
//  Reshape
//
//  Created by jasonwang on 15/12/7.
//  Copyright © 2015年 jasonwang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PraiseInfoEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PraiseInfoEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *videoID;
@property (nullable, nonatomic, retain) NSNumber *praise;

@end

NS_ASSUME_NONNULL_END
