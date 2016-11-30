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

#import "XLJTtitleButton.h"
#import "UIView+XLJFrame.h"

//
#import "XLJTitleScrollView.h"

#import "XLJSegmentController.h"
@interface XLJFirstController ()<UIScrollViewDelegate>

//用新的方法实现
/**用来存储所有的子控制器的scrollview*/
@property (nonatomic, strong) UIScrollView *scrollView;

/**标题栏*/
@property (nonatomic, strong) UIView *titlesView;

/**下划线*/
@property (nonatomic, strong) UIView *titleUnderLine;

/**保存上一次点击的标题按钮*/
@property (nonatomic, strong) XLJTtitleButton *previousClickButton;


/************************************************/


@end

@implementation XLJFirstController

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
    
    
#if 0
    /*
     
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
                      方式一
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
     */
    
    //1.初始化子控制器
    [self setupAllChildViews];
    
    //2.设置scrollview
    [self setupScrollView];
    
    //3.设置标题
    [self setupTitlesView];
    
    //4.添加第0个子控制器的view
    [self addChilviewIntoScrollView:0];
    
#elif 0
    /*
     
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
                         方式二
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
     */
    NSMutableArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"开心麻花",@"小太阳",@"个人中心",@"相亲"].mutableCopy;

//    NSMutableArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"麻花",@"太阳",@"个人",@"相亲"].mutableCopy;
    XLJTitleScrollView *scrollviewTwo = [[XLJTitleScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.xljWidth, 40) withArray:titles];

    //一定要记得添加这句话，禁止内边距
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:scrollviewTwo];
    
#elif 1
    /*
     
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
     方式三
     ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
     */

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 40, 40)];
    
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
#endif
    
}

- (void)btnb
{
    XLJSegmentController *vc = [[XLJSegmentController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 添加第index个子控制器的view到scrollview
- (void)addChilviewIntoScrollView:(NSInteger)index
{
    UIViewController *childVC = self.childViewControllers[index];
    
    //如果view已经加载过就直接返回
    if (childVC.isViewLoaded) return;
    
    //取出子控制器的view的frame
    UIView *childVCView = childVC.view;
    
    //设置子控制器的view的frame
    CGFloat scrollViewW = self.scrollView.xljWidth;
    childVCView.frame = CGRectMake(scrollViewW * index, 0, scrollViewW, self.scrollView.xljHeight);
    
    //添加子控制器的view到scrollView
    [self.scrollView addSubview:childVCView];

}

#pragma mark -- 设置标题
- (void)setupTitlesView
{
    UIView *titleVies = [[UIView alloc] init];
    titleVies.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    titleVies.frame = CGRectMake(0, 64, self.view.xljWidth, 40);
    self.titlesView = titleVies;
    
    [self.view addSubview:titleVies];
    
    //1.设置标题按钮
    [self settingButton];
    
    //2.设置下划线
    [self setupTItleUnderLine];
}

#pragma mark -- 设置下划线
- (void)setupTItleUnderLine
{
    //标题按钮
    XLJTtitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    //下划线
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.xljHeight = 2;
    titleUnderLine.xljY = self.titlesView.xljHeight - titleUnderLine.xljHeight;
    titleUnderLine.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderLine];
    
    self.titleUnderLine = titleUnderLine;
    
    //按钮状态切换
    firstTitleButton.selected = YES;
    self.previousClickButton = firstTitleButton;
    
    //让lable文字内容计算尺寸
    [firstTitleButton.titleLabel sizeToFit];
    self.titleUnderLine.xljWidth = firstTitleButton.titleLabel.xljWidth + 10;
    self.titleUnderLine.xljCenterX = firstTitleButton.xljCenterX;
}

#pragma mark --设置按钮
- (void)settingButton
{
    //文字
    NSMutableArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"开心麻花",@"小太阳",@"个人中心",@"相亲"].mutableCopy;
    
    //标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.xljWidth / titles.count;
    
    CGFloat titleButtonH = self.titlesView.xljHeight;
    
    //创建按钮
    for (NSUInteger i = 0; i < titles.count; i++) {
        
        XLJTtitleButton *titleButton = [[XLJTtitleButton alloc] init];
        //设置tag
        titleButton.tag = i;
        
        //添加事事件
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titlesView addSubview:titleButton];
        //frame
        titleButton.frame = CGRectMake(titleButtonW * i, 0, titleButtonW, titleButtonH);
        
        //文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }

}

#pragma mark -- 设置滚动视图
- (void)setupScrollView
{
    //不允许自修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //点击状态栏的时候这个scrollView不到滚动到最顶部
    scrollView.scrollsToTop = NO;
    
    //添加子控制器的view
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.xljWidth;
    scrollView.contentSize = CGSizeMake(scrollViewW * count, 0);
    
    /*
    //添加子控制器的view
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.xljWidth;
    CGFloat scrollViewH = scrollView.xljHeight;
    
    for (NSUInteger i = 0; i < count; i++) {
        //取出i位置子控制器的view
        UIView *childVCView = self.childViewControllers[i].view;
        childVCView.frame = CGRectMake(scrollViewW * i, 0, scrollViewW, scrollViewH);
        [scrollView addSubview:childVCView];
    }
    
    //滚动的范围
    scrollView.contentSize = CGSizeMake(scrollViewW * count, 0);
    */
}

#pragma mark -- 初始化子控制器
- (void)setupAllChildViews
{
    //把所有的子控制器都添加到当前的self,实际是在self.childViewControllers
    [self addChildViewController:[[XLJRecommendController alloc] init]];
    [self addChildViewController:[[XLJYongController alloc] init]];
    [self addChildViewController:[[XLJActivityController alloc] init]];
    [self addChildViewController:[[XLJTomorrowController alloc] init]];
    [self addChildViewController:[[XLJMusicController alloc] init]];
    [self addChildViewController:[[XLJVedioController alloc] init]];
    [self addChildViewController:[[XLJWellComeController alloc] init]];
    [self addChildViewController:[[XLJPersonalController alloc] init]];
}

//正在滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
}
//停止滚动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.xljWidth;
    
    
    XLJTtitleButton *titleButton = self.titlesView.subviews[index];
    
    [self titleButtonClick:titleButton];
}

#pragma mark --按钮点击事件
- (void)titleButtonClick:(XLJTtitleButton *)titleButton
{
    if (self.previousClickButton == titleButton) {
//        NSLog(@"AAA");
    }
    
    //按钮切换状态
    self.previousClickButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickButton = titleButton;
    
    NSUInteger index = titleButton.tag;
    
    //动画处理
    [UIView animateWithDuration:0.25 animations:^{
        //处理下划线
        self.titleUnderLine.xljWidth = titleButton.titleLabel.xljWidth + 10;
        self.titleUnderLine.xljCenterX = titleButton.xljCenterX;
        
        //偏移量
        self.scrollView.contentOffset = CGPointMake(self.scrollView.xljWidth * titleButton.tag, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        
        //添加子视图
        [self addChilviewIntoScrollView:index];
        
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    /*
   for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIViewController *childVC = self.childViewControllers[i];
        
        UIScrollView *scrollView = (UIScrollView *)childVC.view;
        if (![scrollView isKindOfClass:[UIScrollView class]])  continue;
       
        scrollView.scrollsToTop = (i == index);
    }
    */
}

@end
