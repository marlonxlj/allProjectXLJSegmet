//
//  UIView+XLJFrame.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/31.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "UIView+XLJFrame.h"

@implementation UIView (XLJFrame)

- (void)setXljHeight:(CGFloat)xljHeight
{
    CGRect rect = self.frame;
    rect.size.height = xljHeight;
    self.frame = rect;
}

- (CGFloat)xljHeight
{
    return self.frame.size.height;
}

- (void)setXljWidth:(CGFloat)xljWidth
{
    CGRect rect = self.frame;
    rect.size.width = xljWidth;
    self.frame = rect;
}

- (CGFloat)xljWidth
{
    return self.frame.size.width;
}

- (void)setXljX:(CGFloat)xljX
{
    CGRect rect = self.frame;
    rect.origin.x = xljX;
    self.frame = rect;
}

- (CGFloat)xljX
{
    return self.frame.origin.x;
}

- (void)setXljY:(CGFloat)xljY
{
    CGRect rect = self.frame;
    rect.origin.y = xljY;
    self.frame = rect;
}

- (CGFloat)xljY
{
    return self.frame.origin.y;
}

- (void)setXljCenterX:(CGFloat)xljCenterX
{
    CGPoint center = self.center;
    center.x = xljCenterX;
    self.center = center;
}

- (CGFloat)xljCenterX
{
    return self.center.x;
}

- (void)setXljCenterY:(CGFloat)xljCenterY
{
    CGPoint center = self.center;
    center.y = xljCenterY;
    self.center = center;
}

- (CGFloat)xljCenterY
{
    return self.center.y;
}

@end
