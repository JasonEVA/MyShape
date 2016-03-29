//
//  MeDetailsViewController.h
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "BaseViewController.h"
#import "MyTrainInfoModel.h"
@interface MeDetailsViewController : BaseViewController
@property (nonatomic, strong) MyTrainInfoModel *model;
@property (nonatomic) BOOL isFirst;

@end
