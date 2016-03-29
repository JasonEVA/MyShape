//
//  MeDetailsViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "MeDetailsViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+EX.h"
#import <Masonry.h>
#import "MeChangeIconTableViewCell.h"
#import "MeChangeInfoCell.h"
#import "BaseNavigationViewController.h"
#import "MeUploadHeadIconRequest.h"
#import "MeChangeUserInfoRequest.h"
#import "UIImageView+WebCache.h"
#import "MyDefine.h"
#import "NSString+Manager.h"
#import "TrainFinishInputView.h"
#import "unifiedUserInfoManager.h"
#define ROWHEIGHT       50
#define NODATA          @""

@interface MeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,InputCellDelegate,BaseRequestDelegate,TrainFinishInputViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) NSArray *titelArr;
@property (nonatomic, copy) NSArray *unitArr;
@property (nonatomic, strong) UIImage *myImage;
//@property (nonatomic, strong) MeGetUserInfoModel *model;

@property (nonatomic) keyboardType keyboardType;

@property (nonatomic, strong) TrainFinishInputView *inputView;
@end

@implementation MeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.isFirst ? @"补充信息" : @"账号信息"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:self.isFirst ? @"关闭" : @"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.navigationItem.rightBarButtonItem setEnabled:self.isFirst];

    self.titelArr = [NSArray arrayWithObjects:@"昵称",@"性别",@"身高",@"体重",@"生日",@"地址",@"等级", nil];
    self.unitArr = [NSArray arrayWithObjects:@"",@"",@"CM",@"KG",@"",@"",@"", nil];
    
    [self initComponent];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - private method
// 设置头像
- (void)pickImageisFromCamera:(BOOL)isFromCamera
{
    NSInteger sourceType;
    // 拍照
    if (isFromCamera)
    {
        // 判断是否有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [self postError:@"没有发现摄像头"];
            return;
        }
    }
    // 相册
    else
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setAllowsEditing:YES];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



//压缩图片
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark - event Response

- (void)logoutClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:n_logout object:nil];
}

//网络请求，上传数据
- (void)updateInfo
{
    //上传个人信息
    MeChangeUserInfoRequest *request = [[MeChangeUserInfoRequest alloc]init];
    request.model = self.model;
    [request requestWithDelegate:self];
    [self postLoading];
}
//右上角按钮点击
- (void)rightClick
{
    if (self.isFirst) {
        [self closeClick];
    } else {
        [self updateInfo];
    }
}

- (void)closeClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:n_showHome object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)TrainFinishInputViewDelegate_callBack
{
    [self.inputView setHidden:YES];
}

#pragma mark - InputCellDelegate

- (void)InputCellDelegateCallBack_endEditWithIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    MeChangeInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 1:
            self.model.userName = cell.txtFd.text;
            break;
        case 2:
        {
            if ([cell.txtFd.text isEqualToString:@"男"]) {
                 self.model.gender = 1;
            }else if ([cell.txtFd.text isEqualToString:@"女"])
            {
                 self.model.gender = 0;
            }
        }
            break;
        case 3:
            self.model.height = [cell.txtFd.text integerValue];
            break;
        case 4:
            self.model.weight = [cell.txtFd.text integerValue];
            break;
        case 5:
        {
            long long myDate = [cell.myDate timeIntervalSince1970];
            self.model.birthdateTimeStamp = myDate;
        }
            
            break;
        case 6:
            self.model.location = cell.txtFd.text;
            break;
            
        default:
            break;
    }
    [self.tableView setAllowsSelection:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.tableView.frame = frame;
        
    }];

}


- (void)InputCellDelegateCallBack_startEditWithIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    MeChangeInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell updatePickerView:self.model];
    
    [self.tableView setAllowsSelection:NO];
    
    CGRect frame = cell.frame;
    int offset = frame.origin.y + ROWHEIGHT * indexPath.row - (self.view.frame.size.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.tableView.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];

}


#pragma mark - UIActSheet Dalegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pickImageisFromCamera:NO];
    }
    else if(buttonIndex == 0)
    {
        [self pickImageisFromCamera:YES];
    }
}

#pragma mark - UIImagePickerController Dalegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  
    self.myImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(60, 60)];
    if (self.myImage) {
        //上传头像
        
        MeUploadHeadIconRequest *requestIcon = [[MeUploadHeadIconRequest alloc]init];
        [requestIcon prepareRequest];
        NSData *data = UIImagePNGRepresentation(self.myImage);
        [requestIcon requestWithDelegate:self data:data];
        [self postLoading];
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    if (picker) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isFirst ? 7 : 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    else
    {
        return ROWHEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *ID = @"Cell";
        MeChangeIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MeChangeIconTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
            }
        }
        if (self.myImage) {
            [cell.myImageView setImage:self.myImage];
        }
        else
        {
            [cell.myImageView sd_setImageWithURL:[NSString fullURLWithFileString:self.model.headIcon] placeholderImage:[UIImage imageNamed:@"me_iconplacehoder"]];

        }
        [cell.textLabel setTextColor:[UIColor colorWithHex:0x7f7f7f]];
         return cell;

    }
    else
    {
        static NSString *ID = @"myCell";
        MeChangeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MeChangeInfoCell alloc]initWithUnit:self.unitArr[indexPath.row - 1] reuseIdentifier:ID];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
            }
            [cell setDelegate:self];
        }
        
        cell.indexPath = indexPath;
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"me_info_icon%ld",(long)indexPath.row]]];
        [cell.textLabel setText:self.titelArr[indexPath.row - 1]];
        [cell.textLabel setTextColor:[UIColor colorWithHex:0x7f7f7f]];
       
            switch (indexPath.row) {
                    case 7:
                {
                     [cell needStrenth:self.model.level];
                }
                   
                    break;
                    case 1:
                {
                    [cell setTextFieldText:self.model.userName editing:YES];

                    
                }
                    break;
                case 2:
                {
                    if (self.model.userName == nil) {
                        [cell setTextFieldText:@"" editing:YES];
                    } else {
                        if (self.model.gender == 1) {
                            [cell setTextFieldText:@"男" editing:YES];
                        }else if (self.model.gender == 0)
                        {
                            [cell setTextFieldText:@"女" editing:YES];
                        }
                        
                    }
                    
                }
                    break;
                    case 3:
                {
                    [cell setTextFieldText:[NSString stringWithFormat:@"%ld",(long)self.model.height] editing:YES];
                    if (self.model.height == 0) {
                        [cell setTextFieldText:NODATA editing:YES];
                    }
                }
                    break;
                case 4:
                {
                    [cell setTextFieldText:[NSString stringWithFormat:@"%ld",(long)self.model.weight] editing:YES];
                    if (self.model.weight == 0) {
                        [cell setTextFieldText:NODATA editing:YES];
                    }

                }
                    break;
                case 5:
                {
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.model.birthdateTimeStamp];
                    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                    [dateFormate setDateFormat:@"yyyy-MM-dd"];

                    NSString *string = [dateFormate stringFromDate:date];
                    [cell setTextFieldText:string editing:YES];
                    if (self.model.birthdateTimeStamp == 0) {
                        [cell setTextFieldText:NODATA editing:YES];
                    }
            
                }
                    break;
                case 6:
                    {
                        if (self.model.location) {
                            [cell setTextFieldText:self.model.location editing:YES];
                        }
                        else
                        {
                            [cell setTextFieldText:NODATA editing:YES];
                        }
                    }
                    break;
                    
                default:
                    break;
            }

        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库选择", nil];
            [sheet showInView:self.view];
        }

    } else if (indexPath.row == 7) {
        [self.inputView setHidden:NO];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    [self.tableView addSubview:self.backView];
    return self.backView;
}

#pragma mark - initComponent
- (void)initComponent
{
    [self.view addSubview:self.tableView];
    [self.backView addSubview:self.button];
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputView];
    [self configConstraints];

}

#pragma mark - updateViewConstraints

- (void)configConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor themeBackground_f3f0eb]];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
            [_tableView setSeparatorColor:[UIColor colorWithHex:0xdbd7b0]];
        }
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width - 40 * 2, 44)];
        [_button setBackgroundImage:[UIImage imageWithColor:self.isFirst ? [UIColor themeOrange_ff5d2b] : [UIColor colorWithHex:0xed2121] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_button setTitle:self.isFirst ? @"立即保存" : @"退出当前账号" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:self.isFirst ? @selector(updateInfo) : @selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        [_button.layer setCornerRadius:5];
        [_button setClipsToBounds:YES];
    }
    return _button;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        [_backView setBackgroundColor:[UIColor clearColor]];
    }
    return _backView;
}

- (TrainFinishInputView *)inputView
{
    if (!_inputView) {
        _inputView = [[TrainFinishInputView alloc] init];
        [_inputView setHidden:YES];
        [_inputView setDelegate:self];
    }
    return _inputView;
}

- (MyTrainInfoModel *)model
{
    if (!_model) {
        _model = [[MyTrainInfoModel alloc] init];
    }
    return _model;
}


#pragma mark - request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
//    if ([response isKindOfClass:[MeGetUserInfoResponse class]]) {
//        MeGetUserInfoResponse *result = (MeGetUserInfoResponse *)response;
//        self.model = result.userInfoMogdel;
//        [self.tableView reloadData];
//    }
     if ([response isKindOfClass:[MeChangeUserInfoResponse class]])
    {
        if (self.isFirst) {
            [self closeClick];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    [self postError:response.message];
    NSLog(@"请求失败");
}
@end
