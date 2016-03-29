//
//  ShapeEnum.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#ifndef ShapeEnum_h
#define ShapeEnum_h

typedef enum : NSUInteger {
    tag_arm,
    tag_calf,
    tag_dorsal,
    tag_abdominal,
    tag_chest,
    tag_shoulder,
    tag_thigh
} MuscleTag;

typedef enum : NSUInteger {
    type_beforeAdd,//未添加
    type_added,    //已添加
    type_delete,   //删除
} TrainingCellType;

typedef enum : NSUInteger {
    tag_myBody, //我的体型
    tag_trainHistory,    //训练历史
    tag_switch,   //功能开关
    tag_suggest,  //意见反馈
    tag_aboutUs,  //关于我们
    tag_up,      //上拉按钮
} MenuListTag;

typedef enum : NSUInteger {
    tag_flow,        //流量提醒开关
    tag_autoCache,   //自动缓存开关
} SwitchTag;

typedef enum : NSUInteger {
    tag_open,//打开
    tag_close,//关闭
} SwitchBtnTag;



#endif /* ShapeEnum_h */
