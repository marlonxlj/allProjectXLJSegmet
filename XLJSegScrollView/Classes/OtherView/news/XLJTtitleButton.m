//
//  XLJTtitleButton.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/31.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJTtitleButton.h"

@implementation XLJTtitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;

}
@end
