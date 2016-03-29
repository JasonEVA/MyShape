//
//  ImageTitelView.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "ImageTitelView.h"
#import "UIFont+EX.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
@interface ImageTitelView()
@property (nonatomic, strong) UIImageView *myImageView;
@end


@implementation ImageTitelView

- (instancetype)initWithImage:(UIImage *)image titel:(NSString *)titel
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont themeFontOfSize:16];
        [self setTitleColor:[UIColor colorLightBlack_2e2e2e] forState:UIControlStateNormal];
        [self.myImageView setImage:image];
        [self setTitle:titel forState:UIControlStateNormal];
        [self addSubview:self.myImageView];
        
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(self);
            make.right.equalTo(self.titleLabel.mas_left).offset(-13);
        }];
        
    }
    return self;
}

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
    }
    return _myImageView;
}
@end
