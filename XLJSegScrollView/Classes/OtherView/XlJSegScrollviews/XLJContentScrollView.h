//
//  XLJContentScrollView.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/25.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLJContentScrollView : UIScrollView

@property (nonatomic, assign) NSInteger selectedIndex;

/**外部接口*/
- (instancetype)initWithFrame:(CGRect)frame withItem:(NSMutableArray *)items;

- (void)addTarget:(id)target action:(SEL)action;


@end
