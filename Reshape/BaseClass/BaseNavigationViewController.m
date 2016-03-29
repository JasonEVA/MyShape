//
//  BaseNavigationViewController.m
//  VMarket
//
//  Created by jasonwang on 15/8/3.
//
//

#import "BaseNavigationViewController.h"
#import "UIColor+Hex.h"
#import "UIStandardDefine.h"
#import "UIImage+EX.h"
#import "SwitchViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:<#(CGFloat)#>] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationBar setTintColor:[UIColor colorLightBlack_2e2e2e]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorLightBlack_2e2e2e], NSForegroundColorAttributeName, [UIFont systemFontOfSize:fontSize_18], NSFontAttributeName, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 带有navi的VC屏幕旋转依赖navi
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return YES;
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
