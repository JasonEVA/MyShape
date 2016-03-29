//
//  WeightListModel.m
//  Reshape
//
//  Created by jasonwang on 15/12/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "WeightListModel.h"
#import <MJExtension/MJExtension.h>

@implementation WeightListModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if (property.type.typeClass == [NSString class]) {
            oldValue = @"";
        }
    }

    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pageItems" : [WeightInfoModel class]};
}

@end
