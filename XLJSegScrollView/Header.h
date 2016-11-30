//
//  Header.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/31.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "XLJTtitleButton.h"
#import "UIView+XLJFrame.h"

/** UITabBar的高度 */
CGFloat const XMGTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const XMGNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const XMGTitlesViewH = 35;


#define XLJColor(r,g,b) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:1]
#define XLJRandomColor XLJColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#endif /* Header_h */
