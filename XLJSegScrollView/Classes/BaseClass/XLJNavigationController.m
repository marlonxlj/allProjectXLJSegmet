//
//  XLJNavigationController.m
//  XLJSegScrollViewDemo
//
//  Created by m on 2016/10/17.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJNavigationController.h"
#import "UIBarButtonItem+XLJButtonItem.h"

@interface XLJNavigationController ()<UINavigationControllerDelegate>
//用于返回手势标记
@property (nonatomic, strong) id popDelegate;

@end

@implementation XLJNavigationController

+ (void)initialize
{
    [super initialize];
    
    //获取当前类下面的UIBarButtonItem
    //这个已经废弃[UIBarButtonItem appearanceWhenContainedIn:self, nil];
    //ios9
//    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIBarButtonItem class]]];
    
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    //设置导航条的颜色
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    self.navigationBar.backgroundColor = [UIColor redColor];
}

//导航控制器即将显示新的控制器的时候
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //获取主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    //获取tabBarVc
    UITabBarController *tabBarVc = (UITabBarController *)keyWindow.rootViewController;
    
    //移除系统自带的tarBar
    for (UIView *tabBarButton in tabBarVc.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

//导航控制器跳转完成的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        //实现滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
//重写pop方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    //设置非根控制器导航条的内容
    if (self.viewControllers.count != 0) {
        //设置导航条的内容
        //左边
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_back"] highLightedImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_more"] highLightedImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backToPre
{
    [self popViewControllerAnimated:YES];
}

- (void)backToRoot
{
    [self popToRootViewControllerAnimated:YES];
}


@end
