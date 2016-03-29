//
//  ShareView.h
//  Reshape
//
//  Created by jasonwang on 15/12/3.
//  Copyright © 2015年 jasonwang. All rights reserved.
//  分享页面

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    share_friendsCircle,
    share_weChat,
    share_qq,
    share_weibo,
    share_link
} ShareViewTag;

@protocol ShareViewDelegate <NSObject>

// 分享按钮点击
- (void)shareViewDelegateCallBack_shareClickedWithTag:(ShareViewTag)shareTag;

// cancel
- (void)shareViewDelegateCallBack_shareCancelClicked;

@end
@interface ShareView : UIView

@property (nonatomic, weak)  id <ShareViewDelegate>  delegate; // <##>
@end
