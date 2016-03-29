//
//  MeChangeInfoCell.m
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeChangeInfoCell.h"
#import <Masonry/Masonry.h>
#import "TrainStrengthView.h"
#import "UIColor+Hex.h"
#import "DateUtil.h"


@implementation MeChangeInfoCell

- (instancetype)initWithUnit:(NSString *)unit reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self setMyData];
        [self.unitLb setText:unit];
        [self.contentView addSubview:self.unitLb];
        [self.txtFd setEnabled:YES];
        [self.txtFd setTextColor:[UIColor themeOrange_ff5d2b]];
        [self.txtFd setInputAccessoryView:self.toolBar];
        
        if (unit.length > 0) {
        [self.txtFd mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-40);
        }];
            [self.unitLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.txtFd.mas_right).offset(5);
                make.height.centerY.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)needStrenth:(NSInteger)level
{
    [self.txtFd setEnabled:NO];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_question"]];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    TrainStrengthView *strength = [[TrainStrengthView alloc] init];
    [strength setTrainStrengLevel:level];
    [self.contentView addSubview:strength];
    [strength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(iconView.mas_left).offset(-15);
    }];
}

- (void)updatePickerView:(MyTrainInfoModel *)model
{
    self.model = model;
    self.myDate = [NSDate dateWithTimeIntervalSince1970:model.birthdateTimeStamp];
        if (self.indexPath.row == 2) {
            if (model.gender == 1) {
                [self.sexPickView selectRow:0 inComponent:0 animated:YES];
            }
            else if (model.gender == 0)
            {
                [self.sexPickView selectRow:1 inComponent:0 animated:YES];
            }

        } else if (self.indexPath.row == 5) {
            [self.birthdayPickView setDate:self.myDate];
        }
    }

- (void)setTextFieldText:(NSString *)text editing:(BOOL)isEditing
{
    [super setTextFieldText:text editing:isEditing];
    if ([text isEqualToString:@""]) {
        //[self.txtFd setText:@"未填写"];
    }
    
}

- (void)MyToolBarDelegateCallBack_CancelClick
{
    if (self.indexPath.row == 1 || self.indexPath.row == 3 || self.indexPath.row == 4) {
        self.txtFd.text = self.string;
    } else if (self.indexPath.row == 5) {
        self.myDate = [NSDate dateWithTimeIntervalSince1970:self.model.birthdateTimeStamp];
    }
    [self.txtFd resignFirstResponder];
}

- (void)MyToolBarDelegateCallBack_SaveClick
{
    if (self.indexPath.row == 5) {
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
        [dateFormate setDateFormat:@"yyyy-MM-dd"];
        NSString *timeStr = [dateFormate stringFromDate:self.myDate];
        self.txtFd.text = timeStr;
    } else if (self.indexPath.row == 6) {
        //首次选择默认福建 福州
        //滚动滚轮，设置相应选中地区
        if (self.locationStr) {
            self.txtFd.text = self.locationStr;
        } else {
            //未滚动滚轮，选择默认福建 福州
            self.txtFd.text = @"福建 福州";
        }

    } else if (self.indexPath.row == 2) {
        if ([self.string isEqualToString:@""]) {
            self.txtFd.text = @"女";
        } else {
            self.txtFd.text = self.string;
        }
    }
    
    [self.txtFd resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.string = self.txtFd.text;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.string = self.txtFd.text;
    
        switch (self.indexPath.row) {
            case 1:
                [self.toolBar setMyTitel:@"更改用户名"];
                break;
            case 2:
                self.keyboardType = sexType;
                [self.txtFd setInputView:self.sexPickView];
                [self.toolBar setMyTitel:@"更改性别"];
                break;
            case 3:
            {
                [self.toolBar setMyTitel:@"更改身高"];
                [self.txtFd setKeyboardType:UIKeyboardTypeNumberPad];
                
            }
                break;
                case 4:
            {
                [self.toolBar setMyTitel:@"更改体重"];
                [self.txtFd setKeyboardType:UIKeyboardTypeNumberPad];
            }
                
                break;
            case 5:
            {
                self.keyboardType = birthdarType;
                [self.txtFd setInputView:self.birthdayPickView];
                [self.toolBar setMyTitel:@"更改生日"];
            }

                
                break;
            case 6:
            {
                self.keyboardType = localionType;
                NSInteger selectedProvinceIndex = [self.locationPickView selectedRowInComponent:0];
                NSString *seletedProvince = [self.provinceArray objectAtIndex:selectedProvinceIndex];
                self.cityArray = [self.locationDict objectForKey:seletedProvince];
                [self.txtFd setInputView:self.locationPickView];
                [self.toolBar setMyTitel:@"更改所在地"];
            }

                break;
            default:
                break;
        }
    return YES;
}
//设置PickerView数据源
- (void)setMyData
{
    /**
     *  性别
     */
    self.sexArr = [NSArray arrayWithObjects:@"男",@"女", nil];
    //城市
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    self.locationDict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
    self.provinceArray = [self.locationDict allKeys];
    self.cityArray = [self.locationDict objectForKey:@"福建"];
}

- (void)dateChange:(UIDatePicker *)datePicker
{
    self.myDate = datePicker.date;

}

#pragma mark - UIpickerView Delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    switch (self.keyboardType) {
        case sexType:
            num = self.sexArr.count;
            break;
        case localionType:
            if (component == 0) {
                num = self.provinceArray.count;
            }
            else
            {
                num = self.cityArray.count;
            }
            break;
        default:
            break;
    }
    
    return num;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger num = 0;
    switch (self.keyboardType) {
        case sexType:
            num = 1;
            break;
            
        case localionType:
            num = 2;
            break;
            
        default:
            break;
    }
    
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = nil;
    switch (self.keyboardType) {
        case sexType:
            string = self.sexArr[row];
            break;
            
        case localionType:
            if (component == 0) {
                string = [self.provinceArray objectAtIndex:row];
            }
            else
            {
                string = [self.cityArray objectAtIndex:row];
            }
            break;
            
        default:
            break;
    }
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.keyboardType) {
        case sexType:
            self.string = self.sexArr[row];
            break;
            
        case localionType:
        {
            NSString *seletedProvince = nil;
            NSString *seletedCity = nil;
            if (component == 0) {
                seletedProvince = [self.provinceArray objectAtIndex:row];
                self.cityArray = [self.locationDict objectForKey:seletedProvince];
                
                //重点！更新第二个轮子的数据
                [self.locationPickView reloadComponent:1];
                
                NSInteger selectedCityIndex = [self.locationPickView selectedRowInComponent:1];
                seletedCity = [self.cityArray objectAtIndex:selectedCityIndex];
            }
            else
            {
                NSInteger selectedProvinceIndex = [self.locationPickView selectedRowInComponent:0];
                seletedProvince = [self.provinceArray objectAtIndex:selectedProvinceIndex];
                seletedCity = [self.cityArray objectAtIndex:row];
                
            }
            NSString *msg = [NSString stringWithFormat:@"%@ %@", seletedProvince,seletedCity];
            self.locationStr = msg;
        }
            break;
        default:
            break;
    }
    
    
    
}

- (UIPickerView *)sexPickView
{
    if (!_sexPickView) {
        _sexPickView = [[UIPickerView alloc] init];
        [_sexPickView setDelegate:self];
        [_sexPickView setDataSource:self];
        [_sexPickView setBackgroundColor:[UIColor whiteColor]];
    }
    return _sexPickView;
}

- (UIPickerView *)locationPickView
{
    if (!_locationPickView) {
        _locationPickView = [[UIPickerView alloc] init];
        [_locationPickView setDelegate:self];
        [_locationPickView setDataSource:self];
        [_locationPickView setBackgroundColor:[UIColor whiteColor]];
    }
    return _locationPickView;
}

- (UIDatePicker *)birthdayPickView
{
    if (!_birthdayPickView) {
        _birthdayPickView = [[UIDatePicker alloc] init];
        [_birthdayPickView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [_birthdayPickView setDatePickerMode:UIDatePickerModeDate];
        [_birthdayPickView setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        [_birthdayPickView setMaximumDate:[NSDate date]];
        [_birthdayPickView setBackgroundColor:[UIColor whiteColor]];
        [_birthdayPickView addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _birthdayPickView;
}

- (MyToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[MyToolBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        [_toolBar setMyDelegate:self];
        
    }
    return _toolBar;}

- (UILabel *)unitLb
{
    if (!_unitLb) {
        _unitLb = [[UILabel alloc] init];
        [_unitLb setTextColor:[UIColor colorWithHex:0x7f7f7f]];
    }
    return _unitLb;
}
@end
