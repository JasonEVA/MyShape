//
//  AboutUsViewController.m
//  Reshape
//
//  Created by jasonwang on 15/12/10.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "AboutUsViewController.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"
#import "AboutUsDetailView.h"

#define SELEHEIGHT           self.view.frame.size.height
@interface AboutUsViewController ()
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *versionLb;
@property (nonatomic, strong) AboutUsDetailView *detailView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于我们"];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.versionLb];
    [self.backView addSubview:self.detailView];
    [self configConstraints];
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)configConstraints
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.backView).offset(SELEHEIGHT * 0.048);
    }];
    
    [self.versionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconView.mas_bottom).offset(8);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLb.mas_bottom).offset(25);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(350);
        make.bottom.equalTo(self.backView);
    }];
}
#pragma mark - init UI

- (UIScrollView *)backView
{
    if (!_backView) {
        _backView = [[UIScrollView alloc] init];
        [_backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
        [_backView setScrollEnabled:YES];
        [_backView setContentSize:CGSizeMake(self.view.frame.size.width, 550)];
        [_backView setShowsVerticalScrollIndicator:NO];
        [_backView setShowsHorizontalScrollIndicator:NO];
        //[_backView setDelegate:self];
        [_backView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _backView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_shape"]];
    }
    return _iconView;
}

- (UILabel *)versionLb
{
    if (!_versionLb) {
        _versionLb = [UILabel setLabel:_versionLb text:@"版本号:V1.0.0" font:[UIFont themeFontOfSize:12] textColor:[UIColor colorWithHex:0xa3a3a3]];
    }
    return _versionLb;
}

- (AboutUsDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[AboutUsDetailView alloc] init];
    }
    return _detailView;
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
