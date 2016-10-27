//
//  XLJTabBar.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/18.
//  Copyright © 2016年 XLJ. All rights reserved.
//


#import <UIKit/UIKit.h>

@class XLJTabBar;

@protocol XLJTabBarDelegate <NSObject>

/**点击tabBar按钮*/
- (void)tabBar:(XLJTabBar *)tabBar didClickButton:(NSInteger)index;

/**点击中间加号的图标调用*/
- (void)tabBarDidiClickPlusButton:(XLJTabBar *)tabBar;


@end

@interface XLJTabBar : UIView


@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<XLJTabBarDelegate> delegate;

@end
