//
//  XLJSegmentController.m
//  XLJSegScrollView
//
//  Created by m on 2016/11/30.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJSegmentController.h"
#import "UIView+XLJFrame.h"

//子视图
#import "XLJRecommendController.h"
#import "XLJYongController.h"
#import "XLJActivityController.h"
#import "XLJTomorrowController.h"
#import "XLJMusicController.h"
#import "XLJVedioController.h"
#import "XLJWellComeController.h"
#import "XLJPersonalController.h"

#define fontSize 20
#define FixMinSpacing 10
@interface XLJSegmentController ()<UIScrollViewDelegate>
/** 顶部scrollView  */
@property (strong, nonatomic)  UIScrollView *topScrollView;

/** 底部的scrollView */
@property (strong, nonatomic)  UIScrollView *bottomScrollview;

/** 滚动滑块 */
@property (nonatomic, strong) UIView *bottomView;

/** 按钮的个数 */
@property (nonatomic, assign) NSInteger  count;

/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHight [UIScreen mainScreen].bounds.size.height

#define randomColor [UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1]

//按钮的高度(最好算法是topScrollView的高度的一半)
#define btnHeight 20
//按钮的宽度，根据传入文字的长度来计算
#define btnWidth 0
//按钮左边的距离
#define btnAddHeight 20

@implementation XLJSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.初始化子控制器
    [self setupAllChildViews];
    
    [self setupScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addChilviewIntoScrollView:0];
}

- (void)setupScrollView {
    
    NSArray *array = @[@"试听列表", @"一岁愿不愿意都是我我的在", @"两岁加一", @"三岁一二三", @"立体书", @"千字文文言文", @"三字经", @"童话故事里都是", @"王子和公主", @"词", @"古诗", @"文言文", @"格言", @"警句"];
    
    CGFloat sizeWidth = btnWidth;
    _count = array.count;
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    self.topScrollView.backgroundColor = [UIColor redColor];
    self.topScrollView.delegate = self;
    
    [self.view addSubview:self.topScrollView];
    
    self.bottomScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, ScreenWidth,  self.view.xljHeight - 104)];
    
    self.bottomScrollview.delegate = self;
    [self.view addSubview:self.bottomScrollview];
    
    if (self.btnArray) {
        
        self.btnArray = nil;
    }
    
    self.btnArray = [NSMutableArray arrayWithCapacity:0];
    
    
    for (int i = 0; i < _count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //计算传入的文字的长度
        CGFloat width = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
        
        width += btnAddHeight;
        
        button.frame = CGRectMake(sizeWidth, 10, width, btnHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.backgroundColor = randomColor;
        [self.topScrollView addSubview:button];
        
        //按钮X的位置
        sizeWidth += (width+FixMinSpacing);
        
        [self.btnArray addObject:button];
        
    }
    
    //设置按钮下面的滚动滑块
    CGFloat bottomViewWidth = [array[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    
    bottomViewWidth += btnAddHeight;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight+FixMinSpacing, bottomViewWidth, 3)];
    
    _bottomView.backgroundColor = [UIColor greenColor];
    
    [self.topScrollView addSubview:_bottomView];
    
    //设置顶部的scrollView
    
    self.topScrollView.contentSize = CGSizeMake(sizeWidth, 40);
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.bounces = NO;
    self.topScrollView.tag = 101;
    
    //设置底部的ScrollView
    
    self.bottomScrollview.contentSize = CGSizeMake(ScreenWidth *_count, self.bottomScrollview.xljHeight);
    self.bottomScrollview.bounces = NO;
    self.bottomScrollview.pagingEnabled = YES;
    self.bottomScrollview.tag = 102;
    
    
}

/**
 *  按钮的点击事件
 */
- (void)buttonAction:(UIButton *)btn {
    
    self.bottomScrollview.contentOffset = CGPointMake(btn.tag*ScreenWidth, 0);
}

/**
 *  ScrollView 的代理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIScrollView *sc = (UIScrollView *)[self.view viewWithTag:102];
    
    if (scrollView ==sc) {
        
        int intPage = scrollView.contentOffset.x/ScreenWidth;
        
        CGFloat locationpoint = 0;
        
        UIButton *button = self.btnArray[intPage];
        NSInteger arrayCount = self.btnArray.count;
        
        UIButton *newButton;
        
        if (intPage < arrayCount-1) {
            
            newButton = self.btnArray[intPage+1];
            
        } else {
            
            newButton = self.btnArray[intPage];
        }
        
        //取出当前按钮的宽
        CGFloat lastWidth = button.xljWidth;

        CGFloat newX = button.xljX;
        
        //计算当前位置
        for (int i = 0; i < intPage; i ++) {
            
            UIButton *btn =  self.btnArray[i];
            locationpoint = locationpoint + btn.xljWidth;
            
        }
        
        
        //滚动滑块的变化动画
        [UIView animateWithDuration:0.3 animations:^{
            _bottomView.frame = CGRectMake(newX, btnHeight+FixMinSpacing, lastWidth, 3);
        } completion:^(BOOL finished) {
            [self addChilviewIntoScrollView:intPage];
        }];
        
        
        CGFloat contentWidth = self.topScrollView.contentSize.width;
        
        if (contentWidth > ScreenWidth) {
            [UIView animateWithDuration:0.8 animations:^{
                
                // 当前按钮的位置大于屏幕的一半且小于整个topScrollView的contentSize减去屏幕的一半宽度和按钮的和
                if (locationpoint >= ScreenWidth/2 && locationpoint <= contentWidth-ScreenWidth/2-lastWidth) {
                    
                    
                    self.topScrollView.contentOffset = CGPointMake(locationpoint-ScreenWidth/2+lastWidth/2, 0);
                    
                    // 当前按钮的位置小于屏幕的一半
                } else if (locationpoint < ScreenWidth/2) {
                    
                    self.topScrollView.contentOffset = CGPointMake(0, 0);
                    
                    //当前按钮的位置大于整个topScrollView的contentSize减去屏幕的一半宽度和按钮的和
                } else if (locationpoint > contentWidth-ScreenWidth/2-lastWidth){
                    
                    self.topScrollView.contentOffset = CGPointMake(contentWidth - ScreenWidth, 0);
                }
                
            }];
        }
        
    }
    
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
        CGFloat scrollViewW = self.bottomScrollview.frame.size.width;
        childVCView.frame = CGRectMake(scrollViewW * index, 0, scrollViewW, self.bottomScrollview.frame.size.height);
    
        //添加子控制器的view到scrollView
        [self.bottomScrollview addSubview:childVCView];
    
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


@end
