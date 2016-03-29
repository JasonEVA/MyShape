//
//  NotifyDefine.h
//  Shape
//
//  Created by jasonwang on 15/10/14.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#ifndef NotifyDefine_h
#define NotifyDefine_h

static NSString *const n_logout = @"logout";
static NSString *const n_showHome = @"showHome";
static NSString *const n_showLogin = @"showLogin";
static NSString *const n_switchModule = @"switchModule";

// 视频下载
static NSString *const n_downloadVideo = @"downloadVideo";
static NSString *const n_downloadProgress = @"downloadProgress";

/**
 *  shapeModule
 */
static NSString *const n_trainingPart = @"trainingPart";
static NSString *const n_addAerobicData = @"addAerobicData";
static NSString *const n_updateAerobicData = @"updateAerobicData";

/**
 *  trainingModule
 */
static NSString *const n_pushToAddTraining = @"pushToAddTraining";
static NSString *const n_pushToStartTraining = @"pushToStartTraining";

#endif /* NotifyDefine_h */
