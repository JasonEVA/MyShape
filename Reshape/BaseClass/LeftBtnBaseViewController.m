//
//  LeftBtnBaseViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "LeftBtnBaseViewController.h"
#import "MenuView.h"
#import <Masonry/Masonry.h>
#import "SwitchViewController.h"
#import "MeTrainHistoryViewController.h"
#import "UIColor+Hex.h"
#import "WeightRecordViewController.h"
#import "SuggestViewController.h"
#import "ShapeEnum.h"
#import "AboutUsViewController.h"

@interface LeftBtnBaseViewController ()<MenuViewDelegate>
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) MASConstraint  *menuViewBottom;
@property (nonatomic) BOOL isShow;
@property (nonatomic, strong) UIBarButtonItem *leftBtn;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LeftBtnBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = NO;
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_left1"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick)];
    [self.imageView addGestureRecognizer:tap];
    self.leftBtn = [[UIBarButtonItem alloc] initWithCustomView:self.imageView];
    [self.navigationItem setLeftBarButtonItem:self.leftBtn];
    [self.tabBarController.view addSubview:self.menuView];
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.tabBarController.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        self.menuViewBottom = make.height.mas_equalTo(0);
    }];
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isShow)
    {
        [self.tabBarController.tabBar setHidden:YES];
        [self.menuView setHidden:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftClick
{
    if (self.isShow) {
        //在显示状态下，先隐藏底部栏，再上拉弹出框
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
        self.menuViewBottom.offset = 0;
        [self.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.view layoutIfNeeded];
        }];
    } else {
        //在非显示状态下，先下拉弹出框，再隐藏底部栏
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        self.menuViewBottom.offset = self.view.frame.size.height + 50;
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.tabBarController.tabBar setHidden:YES];

        }];
    }
    self.isShow = !self.isShow;
    
}


- (void)MenuViewDelegateCallBack_btnClicked:(MenuListTag)tag
{
    if (tag == tag_up) {
        
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
        self.menuViewBottom.offset = 0;
        [self.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.view layoutIfNeeded];
        }];
        self.isShow = !self.isShow;

    } else {
        UIViewController *VC = [[UIViewController alloc]init];
        switch (tag) {
//            case tag_myBody:
//            {
//                WeightRecordViewController *weightRecordVC = [[WeightRecordViewController alloc] init];
//                VC = weightRecordVC;
//            }
//                
//                break;
            case tag_trainHistory:
            {
                MeTrainHistoryViewController *historyVC = [[MeTrainHistoryViewController alloc]init];
                VC = historyVC;
            }
                
                break;
            case tag_switch:
            {
                SwitchViewController *switchVC = [[SwitchViewController alloc]init];
                VC = switchVC;
            }
                
                
                break;
            case tag_suggest:
            {
                SuggestViewController *suggestVC = [[SuggestViewController alloc] init];
                VC = suggestVC;
            }
                
                break;
                case tag_aboutUs:
            {
                AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
                VC = aboutUsVC;
            }
                break;
            default:
                break;
                
        }
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
        [self.menuView setHidden:YES];

    }
    

}

- (MenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[MenuView alloc] init];
        _menuView.clipsToBounds = YES;
        [_menuView setDelegate:self];
    }
    return _menuView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
