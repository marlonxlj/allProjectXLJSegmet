//
//  XLJTitleScrollView.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/31.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJTitleScrollView.h"
#import "XLJTtitleButton.h"
#import "UIView+XLJFrame.h"

/**间距*/
#define FixMargin 10

@interface XLJTitleScrollView ()

/**保存传过来的标题数组*/
@property (nonatomic, strong) NSMutableArray *mArray;
/**记录layout*/
@property (nonatomic, assign) BOOL isFirstLayoutSubview;
/**标题*/
@property (nonatomic, strong) UIView *titlesView;
/**下划线*/
@property (nonatomic, strong) UIView *titleUnderLine;
/**上一次按钮*/
@property (nonatomic, strong) XLJTtitleButton *previousClickButton;

@property (nonatomic, assign) CGFloat titleBtunWidth;

@property (nonatomic, strong) XLJTtitleButton *button;

@property (nonatomic, assign) CGFloat allWidth;

@end

@implementation XLJTitleScrollView
- (NSMutableArray *)mArray
{
    if (!_mArray) {
        _mArray = @[].mutableCopy;
    }
    return _mArray;
}

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)mArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.mArray = mArray;
        self.isFirstLayoutSubview = YES;
        //1.初始化子控制器
        //        [self setupAllChildViews];
        
        //2.设置scrollview
        [self setupScrollView];
        
        //3.设置标题
        [self setupTitlesView];
        
        //4.添加第0个子控制器的view
//                [self addChilviewIntoScrollView:0];
        
    }
    
    return self;
}

- (void)setupScrollView
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.pagingEnabled = YES;
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
////    [self setupTitlesView];
//
//}

#pragma mark -- 设置标题
- (void)setupTitlesView
{
    UIView *titleVies = [[UIView alloc] init];
    titleVies.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    self.titlesView = titleVies;
//    titleVies.frame = CGRectMake(0, 0, self.xljWidth+150, 40);
    
//    titleVies.frame = CGRectMake(0, 0, self.xljWidth + (self.mArray.count*self.button.xljWidth + (self.mArray.count+1) * FixMargin), 40);
    titleVies.frame = CGRectMake(0, 0, self.xljWidth + self.allWidth + (self.mArray.count+1)*FixMargin, 40);
    
    self.contentSize = CGSizeMake(titleVies.xljWidth, 0);
    [self addSubview:titleVies];
    
    
    //1.设置标题按钮
    [self settingButton];
    [self layoutIfNeeded];
    
    //2.设置下划线
    [self setupTItleUnderLine];
    
}

#pragma mark --设置按钮
- (void)settingButton
{
    //文字
    NSMutableArray *titles = @[].mutableCopy;
    
    titles = self.mArray;
    
    //标题按钮的尺寸
    //这个方法计算的不是很准确
    //准确的算法是拿到每个按钮的字数来确定按钮的宽度
//    CGFloat titleButtonW = self.titlesView.xljWidth / titles.count;
    
    CGFloat titleButtonH = self.titlesView.xljHeight;
    
    //创建按钮
    for (NSUInteger i = 0; i < titles.count; i++) {
        
        XLJTtitleButton *titleButton = [[XLJTtitleButton alloc] init];
        //设置tag
        titleButton.tag = i;

        //添加事事件
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [self.titlesView addSubview:titleButton];
        //frame
//        titleButton.frame = CGRectMake(titleButtonW * i, 0, titleButtonW, titleButtonH);
        self.titleBtunWidth = self.titlesView.xljWidth/titles.count;
        self.button = titleButton;
        
        //文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        //计算按钮的宽度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
        CGSize size=[titles[i] sizeWithAttributes:attrs];

//        self.titleBtunWidth = size.width;
//        titleButton.frame = CGRectMake((self.titleBtunWidth+FixMargin)*i, 0, self.titleBtunWidth, titleButtonH);
        
//        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//        attrs[NSFontAttributeName] = font;
//        CGSize maxSize = CGSizeMake(MaxW, MAXFLOAT);
        
        CGSize maxSize = CGSizeMake(MAXFLOAT,MAXFLOAT);
        CGFloat widthdALl = [titles[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;

        titleButton.frame = CGRectMake(i * (widthdALl), 0, widthdALl, titleButtonH);
        CGFloat all;
        all += widthdALl;
        self.allWidth = all;
        
        UIView *titleVies = [[UIView alloc] init];
        titleVies.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        self.titlesView = titleVies;

        titleVies.frame = CGRectMake(0, 0, self.xljWidth + self.allWidth + (self.mArray.count+1)*FixMargin, 40);
        
        self.contentSize = CGSizeMake(titleVies.xljWidth, 0);
        [self addSubview:titleVies];
        [self.titlesView addSubview:titleButton];


    }
    
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
        self.contentOffset = CGPointMake(self.xljWidth * titleButton.tag, self.contentOffset.y);
    } completion:^(BOOL finished) {
        
        //添加子视图
//        [self addChilviewIntoScrollView:index];
        
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


#pragma mark -- 添加第index个子控制器的view到scrollview

//- (void)addChilviewIntoScrollView:(NSInteger)index
//{

//    UIViewController *childVC = self.childViewControllers[index];
//    UIViewController *childVC = (UIViewController *)self.nextResponder.nextResponder[index];
    
    //如果view已经加载过就直接返回
//    if (childVC.isViewLoaded) return;
    
//    UIViewController *childVC = [[UIViewController alloc] init];
//    childVC.view.backgroundColor = [UIColor brownColor];
    //取出子控制器的view的frame
//    UIView *childVCView = childVC.view;
//    NSLog(@"%@",self.superview.superview);
    //设置子控制器的view的frame
//    CGFloat scrollViewW = self.xljWidth;
//    childVCView.frame = CGRectMake(scrollViewW * index, 0, scrollViewW, self.xljHeight);
//    
//    //添加子控制器的view到scrollView
//    [self addSubview:childVCView];

//}



@end
