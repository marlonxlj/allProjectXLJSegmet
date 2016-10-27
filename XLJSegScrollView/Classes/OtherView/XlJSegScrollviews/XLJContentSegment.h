//
//  XLJContentSegment.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/25.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLJContentSegment : UIView

@property (nonatomic, assign) CGFloat currentXOffset;

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithFlexibleWidthFrame:(CGRect)frame items:(NSArray *)items withWidth:(CGFloat)width;

- (void)addTarget:(id)target action:(SEL)action;

@end
