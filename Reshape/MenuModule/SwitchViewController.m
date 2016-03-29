//
//  SwitchViewController.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "SwitchViewController.h"
#import "switchView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "unifiedUserInfoManager.h"
#import "ShapeEnum.h"
#import "unifiedFilePathManager.h"
#import "DBUnifiedManager.h"

#define HEIGHT      145

@interface SwitchViewController ()<switchViewDelegate>
@property (nonatomic, strong) switchView *flowView;
@property (nonatomic, strong) switchView *cleanCacheView;
@property (nonatomic, strong) switchView *autoCacheView;
@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor themeBackground_f3f0eb]];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"功能开关"];
    //读取开关状态
    [self.flowView setSelectWithBool:[[unifiedUserInfoManager share] getSwitchStatusWithTag:tag_flow]];
    [self.autoCacheView setSelectWithBool:[[unifiedUserInfoManager share] getSwitchStatusWithTag:tag_autoCache]];
    [self.view addSubview:self.flowView];
    [self.view addSubview:self.cleanCacheView];
    [self.view addSubview:self.autoCacheView];
    
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT);
        make.left.right.equalTo(self.view);
    }];
    
    [self.autoCacheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flowView.mas_bottom);
        make.height.mas_equalTo(HEIGHT);
        make.left.right.equalTo(self.view);
    }];
    
    [self.cleanCacheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.autoCacheView.mas_bottom);
        make.height.mas_equalTo(HEIGHT);
        make.left.right.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -private method

#pragma mark - event Response

#pragma mark - Delegate
- (void)switchViewDelegateCallBack_click:(BOOL)isOpen :(switchView *)switchView
{
    //分别保存开关状态
    if ([switchView isEqual:self.flowView]) {

        [[unifiedUserInfoManager share]saveSwitchStatusWithTag:tag_flow open:isOpen];
        if (isOpen) {
            NSLog(@"点击了流量提醒打开");
        } else {
            NSLog(@"点击了流量提醒关闭");
        }
    } else if ([switchView isEqual:self.autoCacheView]) {
        [[unifiedUserInfoManager share]saveSwitchStatusWithTag:tag_autoCache open:isOpen];
        if (isOpen) {
            NSLog(@"点击了自动缓存打开");
        } else {
            NSLog(@"点击了自动缓存关闭");
        }
    } else if ([switchView isEqual:self.cleanCacheView]) {
        NSLog(@"点击了清除缓存");
        // 删除缓存视频
        [[unifiedFilePathManager share] clearAllFileInDirectory:@"Video"];
        // 清除数据库
        [[DBUnifiedManager share] clearVideoCacheData];
        [self postSuccess:@"清除缓存成功！"];
    }
    
}

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (switchView *)flowView
{
    if (!_flowView) {
        _flowView = [[switchView alloc] initWithTitel:@"使用流量时提醒我"];
        [_flowView setDelegate:self];
        [_flowView setTag:tag_flow];
    }
    return _flowView;
}

- (switchView *)autoCacheView
{
    if (!_autoCacheView) {
        _autoCacheView = [[switchView alloc] initWithTitel:@"加入我的视频后自动缓存"];
        [_autoCacheView setDelegate:self];
        [_autoCacheView setTag:tag_autoCache];
    }
    return _autoCacheView;
}
- (switchView *)cleanCacheView
{
    if (!_cleanCacheView) {
        _cleanCacheView = [[switchView alloc] initWithTitel:@"清除缓存"];
        [_cleanCacheView setDelegate:self];
    }
    return _cleanCacheView;
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
