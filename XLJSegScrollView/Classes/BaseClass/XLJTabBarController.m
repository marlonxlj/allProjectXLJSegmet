//
//  XLJTabBarController.m
//  XLJSegScrollViewDemo
//
//  Created by m on 2016/10/17.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJTabBarController.h"
#import "XLJFiveController.h"
#import "XLJFirstController.h"
#import "XLJSecondController.h"
#import "XLJThirdController.h"
#import "XLJFourController.h"

#import "XLJNavigationController.h"
#import "XLJTabBar.h"

@interface XLJTabBarController ()<XLJTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;


@property (nonatomic, strong) XLJFirstController *first;
@property (nonatomic, strong) XLJSecondController *second;
@property (nonatomic, strong) XLJFourController *four;
@property (nonatomic, strong) XLJFiveController *five;

@end

@implementation XLJTabBarController

- (NSMutableArray *)items
{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加所有子视图
    [self setAllChildViewController];
    
    //自定义tabBar
    [self setUpTabBar];
}

//自定义tabBar,自定义的方法类似
- (void)setUpTabBar
{
    XLJTabBar *tabBar = [[XLJTabBar alloc] initWithFrame:self.tabBar.bounds];
    
    tabBar.backgroundColor = [UIColor lightGrayColor];
    tabBar.delegate = self;
    tabBar.items = self.items;
    
    [self.tabBar addSubview:tabBar];
}


//添加所有子视图
- (void)setAllChildViewController
{
    
    
    //第一页
    XLJFirstController *first = [[XLJFirstController alloc] init];
    
    [self setOneChildViewController:first withNormalImage:[UIImage imageNamed:@"tabbar_home"] withSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"] withTitle:@"first"];
    
    //第二页
    XLJSecondController *second = [[XLJSecondController alloc] init];
    
    [self setOneChildViewController:second withNormalImage:[UIImage imageNamed:@"tabbar_message_center"] withSelectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"] withTitle:@"second"];

    //第四页
    XLJFourController *four = [[XLJFourController alloc] init];
    
    [self setOneChildViewController:four withNormalImage:[UIImage imageNamed:@"tabbar_discover"] withSelectedImage:[UIImage imageNamed:@"tabbar_discover_selected"] withTitle:@"four"];

    //第五页
    XLJFiveController *five = [[XLJFiveController alloc] init];
    
    [self setOneChildViewController:five withNormalImage:[UIImage imageNamed:@"tabbar_profile"] withSelectedImage:[UIImage imageNamed:@"tabbar_profile_selected"] withTitle:@"five"];

}

//添加一个子控制器
- (void)setOneChildViewController:(UIViewController *)controlVC withNormalImage:(UIImage *)normalImage withSelectedImage:(UIImage *)selectedImage withTitle:(NSString *)title
{
    controlVC.tabBarItem.title = title;
    controlVC.tabBarItem.image = normalImage;
    controlVC.tabBarItem.selectedImage = selectedImage;
    //这句不是很明白？请明白的告知，谢谢.
    [self.items addObject:controlVC.tabBarItem];
    controlVC.title = title;
    XLJNavigationController *nav = [[XLJNavigationController alloc] initWithRootViewController:controlVC];
    
    [self addChildViewController:nav];
}

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 50;
    
    tabFrame.origin.y = self.view.frame.size.height - 50;
    
    self.tabBar.frame = tabFrame;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //移除系统自带的tarbBar
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

//当点击tabBar上的按钮时调用
- (void)tabBar:(XLJTabBar *)tabBar didClickButton:(NSInteger)index
{
    if (index== 0 && self.selectedIndex == index) {
        NSLog(@"首页");
    }
    
    self.selectedIndex = index;
}


//点击大图
- (void)tabBarDidiClickPlusButton:(XLJTabBar *)tabBar
{
    //创建发送微博控制器
    XLJThirdController *composeVc = [[XLJThirdController alloc] init];
    XLJNavigationController *nav = [[XLJNavigationController alloc] initWithRootViewController:composeVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}


@end
