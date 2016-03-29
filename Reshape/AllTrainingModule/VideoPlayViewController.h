//
//  VideoPlayViewController.h
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrainingDetailModel;
@interface VideoPlayViewController : UIViewController

@property (nonatomic)  BOOL  cached; // 是否已经缓存
@property (nonatomic)  BOOL  added; // 是否已经加入训练

@property (nonatomic, strong)  TrainingDetailModel  *detailModel; // <##>

@end
