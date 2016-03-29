//
//  MeUplloadHeadIconRequest.m
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeUploadHeadIconRequest.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

@implementation MeUploadHeadIconRequest
- (void)prepareRequest
{
    self.action = @"User/ChangeHeadIcon";
    [super prepareRequest];
}

@end

@implementation MeUploadHeadIconResponse


@end