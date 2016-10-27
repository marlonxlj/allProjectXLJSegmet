//
//  XLJScrollView.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/20.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLJScrollView : UIScrollView

@property (nonatomic, assign) NSInteger selectedIndexStop;

@property (nonatomic, assign) NSInteger selectedIndexNext;

@property (nonatomic, assign) NSInteger selectedIndex;


- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)mArray;

- (void)addTagert:(id)target action:(SEL)action;
//开始滚动时调用
- (void)changeSelectedIndex:(NSInteger)selectedIndex sliderOffset:(CGFloat)sliderOffset;
//停止滚动时调用

@end
