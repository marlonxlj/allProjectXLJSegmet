//
//  XLJSegmentController.m
//  XLJSegScrollView
//
//  Created by m on 2016/11/30.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJSegmentController.h"
#import "UIView+XLJFrame.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

#define FixMinSpacing 10

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define btnWidth 0
#define randomColor [UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1]
#define btnHeight 20
#define btnAddHeight 20

#define fontSize 15

@interface XLJSegmentController ()<UIScrollViewDelegate>

/**
 *  顶部的scrollView
 */
@property (nonatomic, strong)  UIScrollView *topScrollView;

/**
 *  底部大的scrollView
 */
@property (nonatomic, strong)   UIScrollView *bottomScrollview;

/**
 *  滚动滑块
 */
@property (nonatomic, strong) UIView *titleUnderLine;

/**
 *  按钮的个数
 */
@property (nonatomic, assign)  NSInteger  buttonCount;
/**
 *  按钮数组
 */
@property (nonatomic, strong) NSMutableArray *buttonmArray;

/**
 * 字体大小
 */
//@property (nonatomic, assign) CGFloat fontSize;

/**
 * 用来存储所有的子控制器的scrollview
 */
//@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation XLJSegmentController

- (NSMutableArray *)buttonmArray
{
    if (!_buttonmArray) {
        _buttonmArray = @[].mutableCopy;
    }
    
    return _buttonmArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置视图
    [self setChildScrollView];
}

- (void)setChildScrollView
{
 
    //1.设置顶部的scrollview
    [self topView];
    
}

- (void)topView
{
    NSArray *array = @[@"试听列表", @"一岁愿不愿意都是我我的在", @"两岁加一", @"三岁一二三", @"立体书", @"千字文文言文", @"三字经", @"童话故事里都是", @"王子和公主", @"词", @"古诗", @"文言文", @"格言", @"警句"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat sizeWidth = 0;
    self.buttonCount = array.count;
    //1.设置顶部的Scrollview
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 40)];
    //设置代理
    self.topScrollView.delegate = self;
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.bounces = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.tag = 101;
    self.topScrollView.backgroundColor = [UIColor redColor];
    
    //添加到当前的view
    [self.view addSubview:self.topScrollView];
    
    //1.设置底部的scrollview
    [self bottomView];
    
    //2.创建按钮

    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //根据文字的长度来计算宽度
        CGFloat width = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
        //20不知道，等会看
        width = width + btnAddHeight;
        //设置按钮的frame
        button.frame =  CGRectMake(sizeWidth, 0+FixMinSpacing, width, btnHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.tag = i;
        //设置按钮的标题文字
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        //把按钮添加到顶部滚动视图
        [self.topScrollView addSubview:button];
        button.backgroundColor = randomColor;
        
        //计算按钮x的位置
        sizeWidth = sizeWidth + width + FixMinSpacing;
        //将创建的按钮保存到数组中
        [self.buttonmArray addObject:button];
        
        //添加子视图
        UIView *ChildView = [[UIView alloc] initWithFrame:CGRectMake(i *WIDTH, 0, WIDTH, self.bottomScrollview.bounds.size.height)];
        
        ChildView.backgroundColor = randomColor;
        [self.bottomScrollview addSubview:ChildView];

    }
     
    self.topScrollView.contentSize = CGSizeMake(sizeWidth, 30);
    
    //创建按钮下方的滑块
    CGFloat bottomViewWidth =  [array[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    bottomViewWidth = bottomViewWidth + btnAddHeight;
    
    self.titleUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight+FixMinSpacing, bottomViewWidth, 3)];
    self.titleUnderLine.backgroundColor = [UIColor greenColor];
    [self.topScrollView addSubview:self.titleUnderLine];

    
}


- (void)bottomView
{
    //创建底部的滚动视图
    self.bottomScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, self.view.xljHeight-104)];
    self.bottomScrollview.delegate = self;
    [self.view addSubview:self.bottomScrollview];
    
    self.bottomScrollview.pagingEnabled = YES;
    self.bottomScrollview.bounces = NO;
    self.bottomScrollview.tag = 102;
    
    self.bottomScrollview.contentSize = CGSizeMake(WIDTH * self.buttonCount, self.bottomScrollview.xljHeight);
    
}

#pragma mark --按钮点击事件
- (void)titleButtonAction:(UIButton *)button
{
    self.bottomScrollview.contentOffset = CGPointMake(button.tag *WIDTH, 0);

}

#pragma mark --scrollView的代理
/**
 *  ScrollView 的代理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIScrollView *sc = (UIScrollView *)[self.view viewWithTag:102];
    
    if (scrollView ==sc) {
        
        int intPage = scrollView.contentOffset.x/WIDTH;
        CGFloat locationpoint = 0;
        
        UIButton *button = self.buttonmArray[intPage];
        NSInteger arrayCount = self.buttonmArray.count;
        
        UIButton *newButton;
        
        if (intPage<arrayCount-1) {
            
            newButton = self.buttonmArray[intPage+1];
            
        } else {
            
            newButton = self.buttonmArray[intPage];
        }
        
        //取出当前按钮的宽
        CGFloat lastWidth = button.frame.size.width;
        CGFloat newX = button.frame.origin.x;

        //计算当前位置
        for (int i = 0; i < intPage; i ++) {
            
            UIButton *btn =  self.buttonmArray[i];
            locationpoint = locationpoint + btn.frame.size.width;
            
        }
        
        
        //滚动滑块的变化动画
        [UIView animateWithDuration:0.3 animations:^{
            
            self.titleUnderLine.frame = CGRectMake(newX, btnHeight+FixMinSpacing, lastWidth, 3);
            
        }];
        
        
        CGFloat contentWidth = self.topScrollView.contentSize.width;
        
        if (contentWidth > WIDTH) {
            [UIView animateWithDuration:0.8 animations:^{
                
                // 当前按钮的位置大于屏幕的一半    小于整个topScrollView的contentSize减去屏幕的一半宽度和按钮的和
                if (locationpoint>=WIDTH/2 && locationpoint<=contentWidth-WIDTH/2-lastWidth) {
                    
                    
                    self.topScrollView.contentOffset = CGPointMake(locationpoint-WIDTH/2+lastWidth/2, 0);
                    
                    // 当前按钮的位置小于屏幕的一半
                } else if (locationpoint<WIDTH/2) {
                    
                    self.topScrollView.contentOffset = CGPointMake(0, 0);
                    
                    //当前按钮的位置大于整个topScrollView的contentSize减去屏幕的一半宽度和按钮的和
                } else if (locationpoint>contentWidth-WIDTH/2-lastWidth){
                    
                    self.topScrollView.contentOffset = CGPointMake(contentWidth-WIDTH, 0);
                }
                
            }];
        }
        
    }
    
}






@end
