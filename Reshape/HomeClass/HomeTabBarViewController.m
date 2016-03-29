//
//  HomeTabBarViewController.m
//  PalmDoctorPT
//
//  Created by jasonwang on 15/4/3.
//  Copyright (c) 2015年 jasonwang. All rights reserved.
//    

#import "HomeTabBarViewController.h"
#import "AllTrainingMainViewController.h"
#import "MyTrainingMainViewController.h"
#import "BaseNavigationViewController.h"
#import "UIColor+Hex.h"
#import "unifiedUserInfoManager.h"
#import "MyDefine.h"
#import "UIImage+EX.h"
#import "CustomTabBar.h"

static NSInteger const kCountModule = 2; // 模块数
static NSString *const iconShapeNormal = @"tab_shape_normal";
static NSString *const iconShapehighlight = @"tab_shape_highlight";
static NSString *const iconTrainingNormal = @"tab_myTraining_normal";
static NSString *const iconTrainingHighlight = @"tab_myTraining_highlight";

@interface HomeTabBarViewController ()
@property (nonatomic, strong)  AllTrainingMainViewController  *allTrainingMainVC; // <##>
@property (nonatomic, strong)  MyTrainingMainViewController  *myTrainingMianVC; // <##>

@property(nonatomic,retain) NSMutableArray *arrayNavi;
@property(nonatomic,retain) NSMutableArray *arrayItems;

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorDarkBlack_1f1f1fWithAlpha:0.9] size:CGSizeMake(1, 1)]];
    
    // 初始化底部栏和模块框架
    [self initTabBarComponents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToModule:) name:n_switchModule object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 普通需要竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark -- Private Method
// 初始化底部栏和模块框架
- (void)initTabBarComponents
{
    NSArray *arrayVC = @[self.allTrainingMainVC,self.myTrainingMianVC];
    for (UIViewController *vc in arrayVC) {
        // 主页模块
        BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.arrayNavi addObject:navi];
    }
    
    // 标题
    NSArray *arrItemTitle = @[@"全部视频",@"我的视频"];
    
    // 未选中图片
    NSArray *arrItemImageNormal = @[iconShapeNormal,iconTrainingNormal];
    // 选中图片
    NSArray *arrItemImageSelected = @[iconShapehighlight,iconTrainingHighlight];
    NSMutableArray *arrayNormal = [NSMutableArray arrayWithCapacity:kCountModule];
    NSMutableArray *arraySelected = [NSMutableArray arrayWithCapacity:kCountModule];
 
    for (NSInteger i = 0; i < kCountModule; i++)
    {
        UIImage *imageNormal = [[UIImage imageNamed:arrItemImageNormal[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelected = [[UIImage imageNamed:arrItemImageSelected[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [arrayNormal addObject:imageNormal];
        [arraySelected addObject:imageSelected];
        
        // item傀儡，只是用来起到切换页面作用
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:nil selectedImage:nil];
        
        tabBarItem.tag = i;
        
        [self.arrayItems addObject:tabBarItem];
        
        [(BaseNavigationViewController *)self.arrayNavi[i] setTabBarItem:tabBarItem];

    }
    CustomTabBar *tabBar = [[CustomTabBar alloc] initWithTitles:arrItemTitle normalImages:arrayNormal selectedImages:arraySelected];
    [self setValue:tabBar forKeyPath:@"tabBar"];

    [self setViewControllers:self.arrayNavi];
    
}

#pragma mark - Notification
// 切换模块
- (void)switchToModule:(NSNotification *)notification {
    NSInteger index = [notification.object integerValue];
    if (index >= self.viewControllers.count)
    {
        return;
    }
    [self setSelectedIndex:index];
    
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    CustomTabBar *myTabBar = (CustomTabBar *)tabBar;
    [myTabBar.selectedButton setSelected:NO];
    myTabBar.selectedButton = myTabBar.arrayButtons[item.tag];
    [myTabBar.selectedButton setSelected:YES];

    if (item == self.arrayItems.lastObject) {
        // 个人界面
        if (![[unifiedUserInfoManager share] loginStatus]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:n_showLogin object:nil];
        }
    }


}

#pragma mark - Init
- (MyTrainingMainViewController *)myTrainingMianVC {
    if (!_myTrainingMianVC) {
        _myTrainingMianVC = [[MyTrainingMainViewController alloc] init];
    }
    return _myTrainingMianVC;
}

- (AllTrainingMainViewController *)allTrainingMainVC {
    if (!_allTrainingMainVC) {
        _allTrainingMainVC = [[AllTrainingMainViewController alloc] init];
    }
    return _allTrainingMainVC;
}


- (NSMutableArray *)arrayNavi {
    if (!_arrayNavi) {
        _arrayNavi = [[NSMutableArray alloc] initWithCapacity:kCountModule];
    }
    return _arrayNavi;
}

- (NSMutableArray *)arrayItems {
    if (!_arrayItems) {
        _arrayItems = [[NSMutableArray alloc] initWithCapacity:kCountModule];
    }
    return _arrayItems;

}

@end
