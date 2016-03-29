//
//  MeChangeUserInfoRequest.m
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeChangeUserInfoRequest.h"

#define DICT_USERNAME           @"userName"
#define DICT_LOCATION           @"location"	//所在地	String	否
#define DICT_BIRTHDAY           @"birthdateTimeStamp"	    //出生_年	Int	否
#define DICT_HEIGHT             @"height"	//身高	Int	否	单位：CM
#define DICT_WEIGHT             @"weight"	//体重	Double	否	单位：KG
#define DICT_SEX                @"gender"   //性别
@implementation MeChangeUserInfoRequest

- (void)prepareRequest
{
    self.action = @"User/ChangeUserInfo";
    self.params[DICT_USERNAME] = self.model.userName;
    self.params[DICT_LOCATION] = self.model.location;
    self.params[DICT_BIRTHDAY] = [NSNumber numberWithLongLong:self.model.birthdateTimeStamp];
    self.params[DICT_HEIGHT] = [NSNumber numberWithInteger:self.model.height];;
    self.params[DICT_WEIGHT] = [NSNumber numberWithDouble:self.model.weight];;
    self.params[DICT_SEX] = [NSNumber numberWithInteger:self.model.gender];
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MeChangeUserInfoResponse *response = [[MeChangeUserInfoResponse alloc]init];
    response.message = [super prepareResponse:data].message;

    return response;
}
@end


@implementation MeChangeUserInfoResponse



@end
