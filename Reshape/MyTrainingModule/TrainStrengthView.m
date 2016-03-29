//
//  TrainStrengthView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainStrengthView.h"
#import <Masonry.h>

@implementation TrainStrengthView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        for (NSInteger i = 0; i < 5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_light_disable"]];
            [self addSubview:imageView];
            if (i == 0) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                }];
            } else if(i == 4){
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.top.bottom.equalTo(self.light1);
                    make.left.equalTo(self.light1.mas_right).offset(5);
                    make.right.equalTo(self);
                }];
                
            } else {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.top.bottom.equalTo(self.light1);
                    make.left.equalTo(self.light1.mas_right).offset(5);
                }];

            }
            
            self.light1 = imageView;
            [self.imageViewArr addObject:imageView];

        }
    }
    return self;
}

- (void)setTrainStrengLevel:(NSInteger)strengthLevel
{
    for (NSInteger i = 0; i < 5; i++) {
        [self.imageViewArr
         [i] setImage:[UIImage imageNamed:@"train_light_disable"]];
    }

        for (NSInteger i = 0; i < strengthLevel; i++) {
        [self.imageViewArr
         [i] setImage:[UIImage imageNamed:@"train_light"]];
    }

}

- (NSMutableArray<UIImageView *> *)imageViewArr
{
    if (!_imageViewArr) {
        _imageViewArr = [[NSMutableArray alloc] init];
    }
    return _imageViewArr;
}


@end
