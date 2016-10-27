//
//  XLJTabBar.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/18.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJTabBar.h"
#import "XLJTabBarButton.h"

@interface XLJTabBar ()

@property (nonatomic, strong) UIButton *plusButton;

@property (nonatomic, strong) NSMutableArray *buttonmArray;

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation XLJTabBar

- (NSMutableArray *)buttonmArray
{
    if (!_buttonmArray) {
        _buttonmArray = @[].mutableCopy;
    }
    
    return _buttonmArray;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    //遍历模型数组，创建对应的tabBarButton
    for (UITabBarItem *item in _items) {
        
        XLJTabBarButton *btn = [XLJTabBarButton buttonWithType:UIButtonTypeCustom];
        
        btn.item = item;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = self.buttonmArray.count;
        //选中第0个
        if (btn.tag == 0) {
            [self btnClick:btn];
        }
        
        [self addSubview:btn];
        //把按钮添加到数组中
        [self.buttonmArray addObject:btn];
        
    }
}

//点击button调用
- (void)btnClick:(UIButton *)btn
{
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
    
    //通知tabBarVC控制器切换
    if ([_delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [_delegate tabBar:self didClickButton:btn.tag];
    }
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        // 默认按钮的尺寸跟背景图片一样大
        // sizeToFit:默认会根据按钮的背景图片或者image和文字计算出按钮的最合适的尺寸
        [btn sizeToFit];
        
        //监听按钮的点击
        [btn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        _plusButton = btn;
        
        [self addSubview:_plusButton];

    }
    
    return _plusButton;
}

- (void)plusClick
{
    //modal出控制器
    if ([_delegate respondsToSelector:@selector(tabBarDidiClickPlusButton:)]) {
        [_delegate tabBarDidiClickPlusButton:self];
    }
    
}

//调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.items.count + 1);
    CGFloat btnH = h;
    
    int i = 0;
    //设置tabBarButton的frame
    for (UIView *tabBarButton in self.buttonmArray) {
        if (i == 2) {
            i = 3;
        }
        btnX = i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
    
    //设置添加按钮的位置
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.5);
    
}

@end
