//
//  UIBarButtonItem+XLJButtonItem.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/17.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "UIBarButtonItem+XLJButtonItem.h"

@implementation UIBarButtonItem (XLJButtonItem)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highLightedImage:(UIImage *)highLightImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highLightImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
