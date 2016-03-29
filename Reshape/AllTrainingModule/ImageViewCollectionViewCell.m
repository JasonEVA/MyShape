//
//  ImageViewCollectionViewCell.m
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "ImageViewCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface ImageViewCollectionViewCell()
@property (nonatomic, strong)  UIImageView  *imageItem; // <##>
@end
@implementation ImageViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.imageItem];
        [self configConstraints];
    }
    return self;
}

- (void)configConstraints {
    [self.imageItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setCellDataImageName:(NSString *)name {
    [self.imageItem setImage:[UIImage imageNamed:name]];
}

- (UIImageView *)imageItem {
    if (!_imageItem) {
        _imageItem = [[UIImageView alloc] init];
        [_imageItem setContentMode:UIViewContentModeCenter];
    }
    return _imageItem;
}
@end
