//
//  MeChangeInfoCell.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  个人信息修改CELL

#import "BaseInputTableViewCell.h"
#import "MyToolBar.h"
#import "MyTrainInfoModel.h"

typedef NS_ENUM(NSInteger,keyboardType){
    nameType,
    sexType,
    localionType,
    birthdarType
};

@interface MeChangeInfoCell : BaseInputTableViewCell<UIPickerViewDataSource,UIPickerViewDelegate,MyToolBarDelegate>
@property (nonatomic, strong) UIPickerView *sexPickView;
@property (nonatomic, strong) UIPickerView *locationPickView;
@property (nonatomic, strong) UIDatePicker *birthdayPickView;
@property (nonatomic, strong) MyToolBar *toolBar;

@property (nonatomic, copy) NSArray *sexArr;     //性别数据源
@property (nonatomic) NSMutableDictionary *locationDict;  //所在地数据源
@property (nonatomic, copy) NSArray *provinceArray;//省份的数组
@property (nonatomic, copy) NSArray *cityArray; //城市的数组，在接下来的代码中会有根据省份的选择进行数据更新的操作

@property (nonatomic) keyboardType keyboardType;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) NSDate *myDate;
@property (nonatomic, strong) UILabel *unitLb;
@property (nonatomic, copy) NSString *locationStr;  // 转动的地址
@property (nonatomic, strong) MyTrainInfoModel *model;


- (instancetype)initWithUnit:(NSString *)unit reuseIdentifier:(NSString *)reuseIdentifier;

- (void)needStrenth:(NSInteger)level;

- (void)updatePickerView:(MyTrainInfoModel *)model;

@end
