//
//  MenuView.h
//  Reshape
//
//  Created by jasonwang on 15/11/25.
//  Copyright © 2015年 jasonwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapeEnum.h"

@protocol MenuViewDelegate <NSObject>


- (void)MenuViewDelegateCallBack_btnClicked:(MenuListTag)tag;

@end


@interface MenuView : UIView
@property (nonatomic, weak)  id <MenuViewDelegate>  delegate;
@end
