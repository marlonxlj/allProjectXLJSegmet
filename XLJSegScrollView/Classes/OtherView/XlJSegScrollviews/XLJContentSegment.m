//
//  XLJContentSegment.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/25.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJContentSegment.h"

#define ViewTag 1000000

@interface XLJContentSegment ()

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) CGFloat fixWidth;

@property (nonatomic, assign) CGFloat totalWidth;

@property (nonatomic, assign) BOOL isFlexibleWidth;
@property (nonatomic, assign) BOOL isFirstLayoutSubView;

@end

@implementation XLJContentSegment

- (instancetype)initWithFlexibleWidthFrame:(CGRect)frame items:(NSArray *)items withWidth:(CGFloat)width
{
    if (self = [super initWithFrame:frame]) {
        
        _fixWidth = width;
        
        self.items = items.mutableCopy;
        self.isFlexibleWidth = YES;
        self.isFirstLayoutSubView = YES;
        //设置宽度
        [self settingAllWidth];
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.isFirstLayoutSubView) {
        if (!self.isFlexibleWidth) {
            [self settingAllWidth];
        }
        
        [self creatAllChildView];
    }
}

- (void)creatAllChildView
{
    NSMutableArray *mArray = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.items.count; i++) {
        
        UIView *newView = (UIView *)self.items[i];
        
        newView.tag = ViewTag + i;
        
        if (i == 0) {
            
            [newView setFrame:CGRectMake(0, 0, self.fixWidth, self.bounds.size.height)];
            newView.center = CGPointMake(newView.center.x, self.center.y);
            [mArray addObject:@0];
        }else{
            CGFloat originX = [mArray[i -1] doubleValue] + self.fixWidth;
            
            [mArray addObject:[NSNumber numberWithDouble:originX]];
            
            [newView setFrame:CGRectMake(originX, 0, self.fixWidth, self.bounds.size.height)];
            newView.center = CGPointMake(newView.center.x, self.center.y);
        }
        
        [self addSubview:newView];
    }
}

- (void)settingAllWidth
{
    self.totalWidth = 0;
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        self.totalWidth += self.fixWidth;
    }
    
    CGFloat newWidth = self.totalWidth;
    CGRect ret = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
    
    self.frame = ret;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _isFirstLayoutSubView = NO;
    [self layoutSubviews];
    if (selectedIndex > _items.count -1 ) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界" reason:@"selectedIndex大于items数组个数" userInfo:nil];
        @throw exception;
    }
    
    UIView *changedView = (UIView *)[self viewWithTag:ViewTag + selectedIndex];
    
    _selectedIndex = selectedIndex;
    
    self.currentXOffset = changedView.center.x;
    
    if ([self.target respondsToSelector:self.action]) {
        
        [self.target performSelector:self.action withObject:self afterDelay:0.0f];
    }

}

@end
