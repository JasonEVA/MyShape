//
//  TrainingDetailIntroView.m
//  Reshape
//
//  Created by jasonwang on 15/11/26.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import "TrainingDetailIntroView.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"
#import "UIFont+EX.h"
#import "UIColor+Hex.h"
#import "TrainingDetailModel.h"
#import "DateUtil.h"
#import "DBUnifiedManager.h"

@interface TrainingDetailIntroView()
@property (nonatomic, strong)  UIToolbar  *BG; // <##>
@property (nonatomic, strong)  UILabel  *title; // 标题
@property (nonatomic, strong)  UIView  *line; // 分割线
@property (nonatomic, strong)  UILabel  *videoTag; // 运动标签
@property (nonatomic, strong)  UILabel  *lengthTitle; // 时长title
@property (nonatomic, strong)  UILabel  *lengthValue; // 时长Value
@property (nonatomic, strong)  UILabel  *consumeTitle; // 消耗title
@property (nonatomic, strong)  UILabel  *consumeValue; // 消耗value
@property (nonatomic, strong)  UITextView  *intro; // 介绍
@property (nonatomic, strong)  NSMutableArray<UIButton *>  *arrayButtons; // <##>
@property (nonatomic, strong)  NSString  *videoID; // <##>
@end

static NSInteger const kButtonCount = 3;
static CGFloat const kFontSize = 12;

@implementation TrainingDetailIntroView

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
    
    [self.BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    [self.videoTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.line.mas_bottom).offset(15);
    }];
    [self.lengthTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoTag.mas_right).offset(5);
        make.centerY.equalTo(self.videoTag);
    }];
    [self.lengthValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lengthTitle.mas_right);
        make.centerY.equalTo(self.videoTag);
    }];
    [self.consumeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lengthValue.mas_right).offset(5);
        make.centerY.equalTo(self.videoTag);
    }];
    [self.consumeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.consumeTitle.mas_right);
        make.centerY.equalTo(self.videoTag);
    }];
    [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.videoTag.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.arrayButtons.firstObject.mas_top);
    }];
    for (NSInteger i = 0; i < kButtonCount; i ++) {
        UIButton *btn = self.arrayButtons[i];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.title);
                make.bottom.equalTo(self).offset(-30);
            }];
        } else if (i == kButtonCount - 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.bottom.equalTo(self.arrayButtons[i - 1]);
            }];

        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.arrayButtons[i - 1].mas_right).offset(40);
                make.bottom.equalTo(self.arrayButtons[i - 1]);
            }];
        }
    }
}

#pragma mark - Interface Method

- (void)setTrainingDetailIntroData:(TrainingDetailModel *)model {
    self.videoID = model.trainingVideoId;

    [self.title setText:model.name];
    [self.videoTag setText:[NSString stringWithFormat:@"#%@",model.classifyName]];
    [self.lengthValue setText:[DateUtil stringWithSecond:model.videoTotalSeconds]];
    [self.consumeValue setText:[NSString stringWithString:model.consumeDescription]];
    [self.intro setText:model.videoDescription];
    [self.arrayButtons[tag_support] setTitle:[NSString stringWithFormat:@"%ld",(long)model.praise] forState:UIControlStateNormal];
    [self.arrayButtons[tag_share] setTitle:[NSString stringWithFormat:@"%ld",(long)model.share] forState:UIControlStateNormal];
    [self.arrayButtons[tag_support] setEnabled:![[DBUnifiedManager share] queryPraiseInfoWithVideoID:self.videoID]];
    [self setCacheProgress:model.downloadProgress];
}

- (void)setPraiseCount:(NSInteger)count {
    // 数据库记录
    [[DBUnifiedManager share] savePraiseInfoWithVideoID:self.videoID praise:YES];
    [self.arrayButtons[tag_support] setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
    [self.arrayButtons[tag_support] setEnabled:NO];
}

- (void)setShareCount:(NSInteger)count {
    [self.arrayButtons[tag_share] setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];

}

- (void)setCacheProgress:(CGFloat)progress {
    NSLog(@"-------------->进度%f",progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (progress >= 1) {
            [self.arrayButtons[tag_cache] setTitle:@"已缓存" forState:UIControlStateNormal];
            [self.arrayButtons[tag_cache] setEnabled:NO];
        } else if (progress == 0) {
            [self.arrayButtons[tag_cache] setTitle:@"缓存" forState:UIControlStateNormal];
        } else {
            [self.arrayButtons[tag_cache] setTitle:[NSString stringWithFormat:@"%.1f%%",progress * 100] forState:UIControlStateNormal];
        }

    });
}
#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self addSubview:self.BG];
    [self.BG addSubview:self.title]; // 标题
    [self.BG addSubview:self.line]; // 分割线
    [self.BG addSubview:self.videoTag]; // 运动标签
    [self.BG addSubview:self.lengthTitle]; // 时长title
    [self.BG addSubview:self.lengthValue]; // 时长Value
    [self.BG addSubview:self.consumeTitle]; // 消耗title
    [self.BG addSubview:self.consumeValue]; // 消耗value
    [self.BG addSubview:self.intro]; // 介绍
    
    // 按钮
    [self setBottomButtons];
    [self configConstraints];
}

// 设置按钮
- (void)setBottomButtons {
    NSArray *arrayImage = @[[UIImage imageNamed:@"player_support"],[UIImage imageNamed:@"player_share"],[UIImage imageNamed:@"player_cache"]];
    NSArray *arrayTitles = @[@"60",@"150",@"缓存"];
    for (NSInteger i = 0; i < kButtonCount; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[UIFont themeFontOfSize:kFontSize]];
        [btn setTitleColor:[UIColor colorWithHex:0xd6d6d6] forState:UIControlStateNormal];
        [btn setTitle:arrayTitles[i] forState:UIControlStateNormal];
        [btn setTag:(TrainingDetailEventTag)(tag_support + i)];
        [btn setImage:arrayImage[i] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [btn addTarget:self action:@selector(trainingDetailIntroEventClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.BG addSubview:btn];
        [self.arrayButtons addObject:btn];
    }
}

#pragma mark - Event Response

- (void)trainingDetailIntroEventClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(trainingDetailIntroViewDelegateCallBack_clickedWithTag:)]) {
        [self.delegate trainingDetailIntroViewDelegateCallBack_clickedWithTag:sender.tag];
    }
}

#pragma mark - Delegate

#pragma mark - Init
- (UIToolbar *)BG {
    if (!_BG) {
        _BG = [[UIToolbar alloc] init];
        [_BG setBarStyle:UIBarStyleBlack];
    }
    return _BG;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel setLabel:_title text:@"" font:[UIFont themeFontOfSize:17] textColor:[UIColor themeOrange_ff5d2b]];
    }
    return _title;
}

- (UILabel *)videoTag {
    if (!_videoTag) {
        _videoTag = [UILabel setLabel:_videoTag text:@"#运动" font:[UIFont themeFontOfSize:kFontSize] textColor:[UIColor whiteColor]];
    }
    return _videoTag;
}
- (UILabel *)lengthTitle {
    if (!_lengthTitle) {
        _lengthTitle = [UILabel setLabel:_lengthTitle text:@"/ 时长:" font:[UIFont themeFontOfSize:kFontSize] textColor:[UIColor whiteColor]];
    }
    return _lengthTitle;
}
- (UILabel *)lengthValue {
    if (!_lengthValue) {
        _lengthValue = [UILabel setLabel:_lengthValue text:@"04\'47\'\'" font:[UIFont themeFontOfSize:kFontSize] textColor:[UIColor whiteColor]];
    }
    return _lengthValue;
}

- (UILabel *)consumeTitle {
    if (!_consumeTitle) {
        _consumeTitle = [UILabel setLabel:_consumeTitle text:@"/ 消耗:" font:[UIFont themeFontOfSize:kFontSize] textColor:[UIColor whiteColor]];
    }
    return _consumeTitle;
}

- (UILabel *)consumeValue {
    if (!_consumeValue) {
        _consumeValue = [UILabel setLabel:_consumeValue text:@"" font:[UIFont themeFontOfSize:kFontSize] textColor:[UIColor whiteColor]];
    }
    return _consumeValue;
}

- (UITextView *)intro {
    if (!_intro) {
        _intro = [[UITextView alloc] init];
        [_intro setFont:[UIFont themeFontOfSize:kFontSize]];
        [_intro setTextColor:[UIColor colorWithHex:0xbdbcbc]];
        _intro.editable = NO;
        _intro.selectable = NO;
        [_intro setText:@""];
        [_intro setBackgroundColor:[UIColor clearColor]];
    }
    return _intro;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor colorWithHex:0x7c7979]];
    }
    return _line;
}

- (NSMutableArray *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray arrayWithCapacity:kButtonCount];
    }
    return _arrayButtons;
}
@end
