//
//  unifiedUserInfoManager.h
//  VMarket
//
//  Created by jasonwang on 15/8/7.
//
//

#import <Foundation/Foundation.h>
#import "ShapeEnum.h"

@class LoginResultModel;
//@class MeGetUserInfoModel;

@interface unifiedUserInfoManager : NSObject{
    NSUserDefaults *_defaults;
}

// 单例
+ (unifiedUserInfoManager *)share;

/**
 *  登录状态
 *
 *  @return 是否登录
 */
- (BOOL)loginStatus;

/* —————————————用户信息————————————— */

 
/**
 *  保存用户信息
 *
 *  @param model 用户信息model
 */
//- (void)saveUserInfoData:(MeGetUserInfoModel *)model;
/**
 *  获取用户信息model
 *
 *  @return 用户信息model
 */
//- (MeGetUserInfoModel *)getUserInfoModel;

/**
 *  保存登录结果信息
 *
 *  @param model 登录结果信息
 */
- (void)saveLoginResultModel:(LoginResultModel *)model;
/**
 *  取出登录结果信息
 *
 *  @return 登录结果信息
 */
- (LoginResultModel *)getLoginResultData;


/**
 *  退出登录删除用户信息
 */
- (void)removeUserInfo;

// 注册完成计算fatRange,只用一次
//- (NSString *)calculateFatRange;
/**
 *  根据登录状态返回Token
 *
 *  @return Token
 */
- (NSString *)getTokenWithStatus;


//保存开关状态
- (void)saveSwitchStatusWithTag:(SwitchTag)tag open:(BOOL)open;
//读取开关状态
- (BOOL)getSwitchStatusWithTag:(SwitchTag)tag;

//保存等级信息
- (void)saveLevelInfo:(NSArray *)array;

//获取登记信息
- (NSArray *)getLevelInfo;
@end
