//
//  LandscapeNavigationController.m
//  Reshape
//
//  Created by jasonwang on 15/12/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "LandscapeNavigationController.h"

@interface LandscapeNavigationController ()

@end

@implementation LandscapeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 带有navi的VC屏幕旋转依赖navi
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate{
    return YES;
}

@end
