//
//  ShareView.m
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "ShareView.h"
#import "UIFont+EX.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"
#import "ImageViewCollectionViewCell.h"

static NSString *const kShareCell = @"shareCell";
@interface ShareView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)  UILabel  *lbTitle; // 分享到
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, strong)  UIButton  *btnCancel; // 取消
@property (nonatomic, strong)  UIView    *line1; // <##>
@property (nonatomic, strong)  UIView    *line2; // <##>
@property (nonatomic, strong)  NSArray  *arrayImgeView; // <##>
@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self configElements];
    }
    return self;
}

- (void)configConstraints {
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.line1.mas_top);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.collectionView.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(90);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.line2.mas_bottom);
    }];
}
#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {

    [self addSubview:self.lbTitle];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.collectionView];
    [self addSubview:self.btnCancel];
    
    self.arrayImgeView = @[@"share_friendsCircle",@"share_weChat",@"share_qq",@"share_weibo",@"share_link"];
    [self configConstraints];
}

#pragma mark - Event Response

- (void)shareCancelClicked {
    if ([self.delegate respondsToSelector:@selector(shareViewDelegateCallBack_shareCancelClicked)]) {
        [self.delegate shareViewDelegateCallBack_shareCancelClicked];
    }
}
#pragma mark - Delegate

#pragma mark - UIColectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShareCell forIndexPath:indexPath];
    [cell setTag:(ShareViewTag)(share_friendsCircle + indexPath.row)];
    NSLog(@"%@",self.arrayImgeView[indexPath.row]);
    [cell setCellDataImageName:self.arrayImgeView[indexPath.row]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(shareViewDelegateCallBack_shareClickedWithTag:)]) {
        [self.delegate shareViewDelegateCallBack_shareClickedWithTag:(ShareViewTag)indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width / 5 - 0.1, self.frame.size.width / 5 - 0.1);
}
#pragma mark - Init

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel setLabel:_lbTitle text:@"分享到" font:[UIFont boldSystemFontOfSize:18] textColor:[UIColor whiteColor]];
        [_lbTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return _lbTitle;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsZero];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[ImageViewCollectionViewCell class] forCellWithReuseIdentifier:kShareCell];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setPagingEnabled:YES];
    }
    return _collectionView;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        [_line1 setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        [_line2 setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _line2;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setBackgroundColor:[UIColor clearColor]];
        [_btnCancel.titleLabel setFont:[UIFont themeFontOfSize:15]];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(shareCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}
@end
