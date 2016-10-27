//
//  UIBarButtonItem+XLJButtonItem.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/17.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XLJButtonItem)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highLightedImage:(UIImage *)highLightImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
