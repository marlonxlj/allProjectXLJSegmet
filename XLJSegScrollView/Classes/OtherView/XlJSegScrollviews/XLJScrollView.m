//
//  XLJScrollView.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/20.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJScrollView.h"
#import "XLJSegment.h"

@interface XLJScrollView ()

@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong) XLJSegment *segMent;
//事件对象
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL isFirstLayoutSubview;


@end

@implementation XLJScrollView

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = @[].mutableCopy;
    }
    return _itemArray;
}

- (XLJSegment *)segMent
{
    if (!_segMent) {
        //初始化标题按钮
        _segMent = [[XLJSegment alloc] initWithSegmentFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 35) withButtonTitleItems:self.itemArray withButtonFontSize:20 withSliderColor:[UIColor whiteColor]];
        
        [_segMent addTagert:self action:@selector(onButtonClicked)];
    }
    
    return _segMent;
}
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)mArray
{
    if (self = [super initWithFrame:frame]) {
        self.itemArray = mArray;
        self.isFirstLayoutSubview = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isFirstLayoutSubview) {
        //添加子控件
        [self addSegment];

    }
    
}

//添加子控件
- (void)addSegment
{
    //1.把segMent添加到scrollView上面
    [self addSubview:self.segMent];
    
    //2.设置scrollView的属性
    //关闭垂直、水平滚动条
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;

    //关闭弹簧效果
    self.bounces = NO;
    //滑动范围
    //这两句话的意思是一样的
    // self.contentSize = CGSizeMake(self.segMent.frame.size.width, 0);
    self.contentSize = CGSizeMake(CGRectGetWidth(self.segMent.frame), 0);
    self.isFirstLayoutSubview = NO;
}

- (void)addTagert:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)onButtonClicked
{
    _selectedIndex = self.segMent.selectedIndex;
    
    CGFloat onClickedXToRight = self.contentSize.width - self.segMent.currentXOffset;
    
    
    CGFloat halfWidth = self.frame.size.width / 2;
    
    if ((self.segMent.currentXOffset >= halfWidth) && (onClickedXToRight >= halfWidth)) {
        
        
        CGFloat onClickedToLeft = self.segMent.currentXOffset - self.contentOffset.x;
        CGFloat neededOffset = halfWidth - onClickedToLeft;
        CGFloat currentOffsetY = self.contentOffset.y;
        CGFloat currentOffsetX = self.contentOffset.x;
        currentOffsetX -= neededOffset;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY)];
        }];
        
        
    }else if (self.segMent.currentXOffset < halfWidth){
        
        
        __weak typeof(self) weakSelf = self;
        CGFloat currentOffsetY = self.contentOffset.y;
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(0, currentOffsetY)];
        }];
    }else
    {
        
        __weak typeof(self) weakSelf = self;
        CGFloat currentOffsetX = 0;
        CGFloat currentOffsetY = 0;
        currentOffsetY = self.contentOffset.y;
        currentOffsetX = self.contentSize.width - self.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY)];
        }];
        
    }

    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self afterDelay:0.0f];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self layoutSubviews];
    if (selectedIndex > self.itemArray.count - 1) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界" reason:@"selectedIndex大于items数组个数" userInfo:nil];
        @throw exception;
    }
    _selectedIndex = selectedIndex;
    _segMent.selectedIndex = selectedIndex;
}

- (void)setSelectedIndexStop:(NSInteger)selectedIndexStop
{
    [self layoutSubviews];
    if (selectedIndexStop > self.itemArray.count - 1) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界1" reason:@"selectedIndex大于items数组个数" userInfo:nil];
        @throw exception;
    }
    _selectedIndex = selectedIndexStop;
    _segMent.selectedIndexStop = selectedIndexStop;
    [self updataFrame];
}

- (void)setSelectedIndexNext:(NSInteger)selectedIndexNext
{
    [self layoutSubviews];
    if (selectedIndexNext > self.itemArray.count - 1) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界2" reason:@"selectedIndex大于items数组个数" userInfo:nil];
        @throw exception;
    }
    _selectedIndexNext = selectedIndexNext;
    _segMent.selectedIndexNext = selectedIndexNext;
}

- (void)updataFrame
{
    __weak typeof(self) weakSelf = self;
    _selectedIndexStop = self.segMent.selectedIndexStop;
    
    CGFloat onClickedXToRight = self.contentSize.width - self.segMent.currentXOffset;
    
    
    CGFloat halfWidth = self.frame.size.width / 2;
    
    if ((self.segMent.currentXOffset >= halfWidth) && (onClickedXToRight >= halfWidth)) {
        
        
        CGFloat onClickedToLeft = self.segMent.currentXOffset - self.contentOffset.x;
        CGFloat neededOffset = halfWidth - onClickedToLeft;
        CGFloat currentOffsetY = self.contentOffset.y;
        CGFloat currentOffsetX = self.contentOffset.x;
        currentOffsetX -= neededOffset;
       
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY)];
            
        }];
    }else if (self.segMent.currentXOffset < halfWidth){
        
        
        CGFloat currentOffsetY = self.contentOffset.y;
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(0, currentOffsetY)];
        }];
    }else
    {
        CGFloat currentOffsetX = 0;
        CGFloat currentOffsetY = 0;
        currentOffsetY = self.contentOffset.y;
        currentOffsetX = self.contentSize.width - self.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            
            [weakSelf setContentOffset:CGPointMake(currentOffsetX, currentOffsetY)];
        }];
    }

}

- (void)changeSelectedIndex:(NSInteger)selectedIndex sliderOffset:(CGFloat)sliderOffset
{
    [self layoutSubviews];
    self.segMent.sliderOffset = sliderOffset;
    self.selectedIndexStop = selectedIndex;
    
}
@end
