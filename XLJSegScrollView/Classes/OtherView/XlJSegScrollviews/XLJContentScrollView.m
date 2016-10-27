//
//  XLJContentScrollView.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/25.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJContentScrollView.h"
#import "XLJContentSegment.h"

@interface XLJContentScrollView()

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) XLJContentSegment *segMent;

@property (nonatomic, strong) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) BOOL isFirstLayoutSubviews;

@end

@implementation XLJContentScrollView

- (NSMutableArray *)items
{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame withItem:(NSMutableArray *)items
{
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        self.isFirstLayoutSubviews = YES;
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.isFirstLayoutSubviews) {
        [self addContentSegment];
    }
}

- (void)addContentSegment
{
    self.segMent = [[XLJContentSegment alloc] initWithFlexibleWidthFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) items:self.items withWidth:CGRectGetWidth(self.bounds)];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.segMent];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.segMent.frame), 0);
    
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.isFirstLayoutSubviews = NO;
    [self.segMent addTarget:self action:@selector(actityAction)];
    self.segMent.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self layoutSubviews];
    _selectedIndex = selectedIndex;
    _segMent.selectedIndex = selectedIndex;
    if (selectedIndex > _items.count - 1) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界" reason:@"selectedIndex大于items数组个数" userInfo:nil];
        @throw exception;
    }

}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)actityAction
{
    
    __weak typeof(self) weakSelf = self;
    
    _selectedIndex = self.segMent.selectedIndex;
    
    CGFloat rightOffset = self.contentSize.width - self.segMent.currentXOffset;
    
    CGFloat halfWidth = self.frame.size.width / 2.0;
    

    if ((self.segMent.currentXOffset >= halfWidth) && (rightOffset >= halfWidth)) {
        CGFloat toLeft = self.segMent.currentXOffset - self.contentOffset.x;
        CGFloat needeOffset = halfWidth - toLeft;
        CGFloat currentOffsetY = self.contentOffset.y;
        CGFloat currentOffsetX = self.contentOffset.x;
        currentOffsetX -= needeOffset;
        
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY) animated:YES];
        }];
    }else if (self.segMent.currentXOffset < halfWidth){
        CGFloat currentOffsetY = self.contentOffset.y;
        
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf setContentOffset:CGPointMake(0, currentOffsetY) animated:YES];
        }];
    }else{
        
        CGFloat currentOffsetX = 0;
        CGFloat currentOffsetY = 0;
        currentOffsetX = self.contentSize.width - self.frame.size.width;
        currentOffsetY = self.contentOffset.y;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY) animated:YES];
        }];
    }
    
    if ([self.target respondsToSelector:self.action]) {
        
        [self.target performSelector:self.action withObject:self afterDelay:0.0f];
        
    }
}

@end
