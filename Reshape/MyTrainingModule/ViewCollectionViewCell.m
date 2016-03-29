//
//  ViewCollectionViewCell.m
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "ViewCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@implementation ViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_f3f0eb]];
    }
    return self;
}
- (void)setMyCustomView:(UIView *)myView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:myView];
    [myView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
@end
