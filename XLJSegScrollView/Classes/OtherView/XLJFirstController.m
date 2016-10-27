//
//  XLJFirstController.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/18.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJFirstController.h"
#import "XLJTestGepController.h"

#import "XLJScrollView.h"
#import "XLJSegment.h"

//子视图
#import "XLJRecommendController.h"
#import "XLJYongController.h"
#import "XLJActivityController.h"
#import "XLJTomorrowController.h"
#import "XLJMusicController.h"
#import "XLJVedioController.h"
#import "XLJWellComeController.h"
#import "XLJPersonalController.h"

//内容scrollview
#import "XLJContentSegment.h"
#import "XLJContentScrollView.h"

@interface XLJFirstController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleChild;
@property (nonatomic, strong) XLJScrollView *topTitleScrollView;

//内容
@property (nonatomic, strong) XLJContentScrollView *contentChildView;

@end

@implementation XLJFirstController

- (NSMutableArray *)titleChild
{
    if (!_titleChild) {
        _titleChild = @[].mutableCopy;
    }
    return _titleChild;
}
#pragma mark -- 测试navgation手势返回方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    XLJTestGepController *test = [XLJTestGepController new];
//    
//    [self.navigationController pushViewController:test animated:YES];
    
//    XLJScrollView *topScrollView = [[XLJScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
//    topScrollView.backgroundColor = [UIColor lightGrayColor];
//    
//    [self.view addSubview:topScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1;
    
    //1.设置标题按钮
    [self settingTitleButton];
    
    //2.添加标题的子视图
    [self addChildTtitleButton];
}

#pragma mark -- 添加标题的子视图
- (void)addChildTtitleButton
{
    //1.把子视图添加到self的子视图中
    XLJRecommendController *reVC = [XLJRecommendController new];
    [self addChildViewController:reVC];
    
    XLJYongController *yongVC = [XLJYongController new];
    [self addChildViewController:yongVC];
    
    XLJActivityController *acVC = [XLJActivityController new];
    [self addChildViewController:acVC];
    
    XLJTomorrowController *toVC = [XLJTomorrowController new];
    
    [self addChildViewController:toVC];
    
    XLJMusicController *muVC = [XLJMusicController new];
    [self addChildViewController:muVC];
    
    XLJVedioController *veVC = [XLJVedioController new];
    [self addChildViewController:veVC];
    
    XLJWellComeController *weVC = [XLJWellComeController new];
    [self addChildViewController:weVC];
    
    XLJPersonalController *prVC = [XLJPersonalController new];
    [self addChildViewController:prVC];
    
    
    //2.把滚动的scrollView添加到self.viw上
 
    NSMutableArray *marray = @[reVC.view,yongVC.view,acVC.view,toVC.view,muVC.view,veVC.view,weVC.view,prVC.view].mutableCopy;

    XLJContentScrollView *contenChildView = [[XLJContentScrollView alloc] initWithFrame:CGRectMake(0, 64+40, CGRectGetWidth(self.view.bounds), self.view.frame.size.height - 64-40) withItem:marray];
    
    self.contentChildView = contenChildView;
    self.contentChildView.delegate = self;
    [self.view addSubview:contenChildView];
    
}


#pragma mark -- 设置标题按钮
- (void)settingTitleButton
{
    //这句话没有作用，不知道是什么？？？
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.navigationItem.title = @"First";此方法有作用
    NSMutableArray *marray = @[@"推荐大家",@"少年",@"活动介绍中",@"明天约",@"音乐乐天",@"视频动画",@"欢迎来到这里",@"个人介绍"].mutableCopy;
    
    //下面的这个ok的
    XLJScrollView *topScrollView = [[XLJScrollView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 40) withArray:marray];
    
    self.topTitleScrollView = topScrollView;
    topScrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:topScrollView];
    
    [topScrollView addTagert:self action:@selector(onClicked:)];

}

- (void)onClicked:(UIButton *)btn
{
    NSLog(@"AAAA");
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.contentChildView.selectedIndex = self.topTitleScrollView.selectedIndex;
        
    });

}

//正在滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat origin = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (origin < 0) {
        origin = 0;
    }
    
    CGFloat floorValue = floor(origin);
    
    CGFloat tempValue = origin - floorValue;
    
    CGFloat index;
    
    if (tempValue > 0.5) {
        index = floorValue + 1;
    }else{
        index = floorValue;
    }
    
    CGFloat scrollViewOffSet = scrollView.contentOffset.x;
    CGFloat ratio = scrollViewOffSet / scrollView.bounds.size.width;
    CGFloat sliderOffset = self.contentChildView.contentSize.width * ratio;

    [self.topTitleScrollView changeSelectedIndex:index sliderOffset:sliderOffset];
  
}
//停止滚动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat origin = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (origin < 0) {
        origin = 0;
    }
    
    CGFloat floorValue = floor(origin);
    
    self.topTitleScrollView.selectedIndexStop = floorValue;
}
@end
