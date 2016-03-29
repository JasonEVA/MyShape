//
//  TrainingListInfoModel.m
//  Reshape
//
//  Created by jasonwang on 15/12/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingListInfoModel.h"

@implementation TrainingListInfoModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if (property.type.typeClass == [NSString class]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

@end
