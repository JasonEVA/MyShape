//
//  LoginResultModel.m
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "LoginResultModel.h"
#import <MJExtension/MJExtension.h>

@implementation LoginResultModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if (property.type.typeClass == [NSString class]) {
            oldValue = @"";
        }
    }
    return oldValue;
}
@end
