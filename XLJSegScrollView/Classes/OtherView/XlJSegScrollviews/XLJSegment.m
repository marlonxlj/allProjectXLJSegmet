//
//  XLJSegment.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/20.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJSegment.h"

#define Button_tag 100000
#define FixMargin 20

#define margein (self.frame.size.width/self.items.count * (1/6.0f))

@interface XLJSegment()
@property (nonatomic, strong) UIButton *button;
/**线*/
@property (nonatomic, strong) UIView *line;

/**滑块*/
@property (nonatomic, strong) UIView *slider;

//事件对象
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;

//保存传过来的属性信息
/**标题数组*/
@property (nonatomic, strong) NSMutableArray *items;

/**当前选中的下标*/
@property (nonatomic, assign) NSInteger currentSelectedSaveIndex;

/**字体的大小*/
@property (nonatomic, assign) CGFloat fontSize;

/**普通字体颜色*/
@property (nonatomic, strong) UIColor *titleColor;

/**选中字体颜色*/
@property (nonatomic, strong) UIColor *selectedCorlor;

/**下划线的颜色*/
@property (nonatomic, strong) UIColor *sliderColor;

/**总的宽度*/
//@property (nonatomic, assign) CGFloat totoalWidth;

/**按钮标题长度的数组*/
@property (nonatomic, strong) NSMutableArray *titlemArray;

/**按钮的间距*/
@property (nonatomic, assign) CGFloat buttonMargin;

@property (nonatomic, assign) CGFloat buttonY;

@property (nonatomic, strong) NSMutableArray *buttonArray;

//@property (nonatomic, assign) CGFloat currentXOffset;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) UIButton *previousClickedTitleButton;

//是否是第一次加载，是为了不让layoutsubview重复的调用
@property (nonatomic, assign) BOOL isFirstLayoutSubviews;

//scrollView宽度的问题
@property (nonatomic, assign) BOOL isFlexibleWidth;

@end

@implementation XLJSegment
{
    NSInteger _selectedIndex;
}
- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = @[].mutableCopy;
    }
    return _buttonArray;
}

- (NSMutableArray *)titlemArray
{
    if (!_titlemArray) {
        _titlemArray = @[].mutableCopy;
    }
    return _titlemArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isFirstLayoutSubviews) {

        if (!self.isFlexibleWidth) {
            [self settingButtonTileLength];

        }
                //创建按钮
        [self creatButton];
        
        //创建线
        [self creatLineAddSlider];

    }
}

- (void)creatButton
{
    
    NSMutableArray *originXarray = @[].mutableCopy;
    
    //计算frame
    int i = 0;
    
    for (NSString *title in self.items) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置title
        [button setTitle:title forState:UIControlStateNormal];
        
        //设置字体颜色
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
        self.button = button;
        
        button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [button sizeToFit];
        button.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];

        //显示在界面上
        [self addSubview:button];
        
        //添加事件
        [button addTarget:self action:@selector(buttonONclicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置tag
        button.tag = Button_tag + i;
        
        //设置第一个按钮为默认选中状态
        if (i == 0) {
            button.selected = YES;
            button.userInteractionEnabled = NO;

            [button setFrame:CGRectMake(FixMargin, self.buttonY, [self.titlemArray[i] doubleValue], self.bounds.size.height - self.buttonY)];
            
            [originXarray addObject:[NSNumber numberWithDouble:FixMargin]];
        }else{
            CGFloat originX = [originXarray[i - 1] doubleValue] + [self.titlemArray[i - 1] doubleValue] + FixMargin;
            
            [originXarray addObject:[NSNumber numberWithDouble:originX]];
            
            [button setFrame:CGRectMake(originX, self.buttonY, [self.titlemArray[i] doubleValue], self.bounds.size.height - self.buttonY)];
            
        }
        
        [self.buttonArray addObject:button];
        self.isFirstLayoutSubviews = NO;
        i++;
    }
}

- (void)buttonONclicked:(UIButton *)button
{
    //找到上次选中的按钮，将其变成没有选中
    self.isFirstLayoutSubviews = NO;
    
    UIButton *btn = (UIButton *)[self viewWithTag:Button_tag + _selectedIndex];
    
    btn.selected = NO;
    btn.userInteractionEnabled = YES;
    
    self.currentXOffset = button.center.x;
    
    //将当前点中的变成选中
    button.userInteractionEnabled = NO;
    button.selected = YES;
    btn = button;
    
    /** 这个方法可以实现按钮状态选择，但是有一个问题就是默认选择中第一个的问题，如果使用下面这个有bug,待修改，大家也可以帮忙修改，谢谢。
    self.previousClickedTitleButton.selected = NO;
    button.selected = YES;
    self.previousClickedTitleButton = button;
    */
//    self.currentSelectedSaveIndex = button.tag - Button_tag;
    
    _selectedIndex = button.tag - Button_tag;
    
    //改变滑块的位置
    self.currentXOffset = button.center.x;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.slider.frame = CGRectMake(self.slider.frame.origin.x, self.slider.frame.origin.y, [self.titlemArray[_selectedIndex] doubleValue], self.slider.frame.size.height);
        
        self.slider.center = CGPointMake(button.center.x, self.slider.center.y);
        
    }];
    
    //添加响应事件
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self afterDelay:0.0f];
    }else{
        NSException *exception = [[NSException alloc] initWithName:@"提示信息" reason:@"没有实现响应事件方法" userInfo:nil];
        
        @throw exception;
    }
    
}

- (void)creatLineAddSlider
{
    //1.创建线
    CGFloat lineX = 0;
    CGFloat lineH = 2;
    CGFloat lineY = self.frame.size.height - lineH;
    CGFloat lineW = self.frame.size.width;
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
    
    self.line.backgroundColor = [UIColor orangeColor];
    

    //2.滑块
    UIButton *btn = (UIButton *)[self viewWithTag:Button_tag + _selectedIndex];
    
    self.slider = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, self.bounds.size.height - 4, [self.titlemArray[_selectedIndex] doubleValue], 2)];
    self.slider.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.slider];
    
}

- (void)addTagert:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

//如果没有设置按钮的标题就抛出异常信息
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        NSException *execption = [[NSException alloc] initWithName:@"标题设置提示" reason:@"不能直接设置Frame，必须设置标题名称" userInfo:nil];
        @throw execption;
 
    }
    
    return self;
}

//实现初始化方法
- (instancetype)initWithSegmentFrame:(CGRect)frame withButtonTitleItems:(NSMutableArray *)titleItems withButtonFontSize:(CGFloat)fontSize withSliderColor:(UIColor *)sliderColor
{
    if (self = [super initWithFrame:frame]) {
        
        self.items = titleItems;
        self.fontSize = fontSize;
        self.sliderColor = sliderColor;
        self.buttonY = CGRectGetHeight(self.bounds)/2.0 - 12;
        self.isFirstLayoutSubviews = YES;
        self.isFlexibleWidth = YES;
        //根据按钮的长度来自适应宽度
        [self settingButtonTileLength];
        
    }
    
    return self;
}

//计算宽度,更新位置
- (void)settingButtonTileLength
{
    self.totoalWidth = 0;
    //清空标题数组
    [self.titlemArray removeAllObjects];
    
    //遍历标题数组
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        CGSize titleSize;
        
        titleSize = [self.items[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]}];
        self.totoalWidth += titleSize.width;
        //获取标题文字的宽度
        [self.titlemArray addObject:[NSNumber numberWithDouble:titleSize.width]];
    }
    
    //设置新的Frame
    self.buttonMargin = FixMargin;
    
    CGFloat newWidth = FixMargin * (self.items.count + 1) + self.totoalWidth;
    
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
    self.frame = rect;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;

}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (selectedIndex > self.items.count -1) {
        NSException *expection = [[NSException alloc] initWithName:@"来自segment的提显示" reason:@"数组有问题" userInfo:nil];
        @throw expection;
    }
    
    UIButton *currentBtn = self.buttonArray[_selectedIndex];
    currentBtn.selected = NO;
    currentBtn.userInteractionEnabled = YES;
    UIButton *choosedBtn = self.buttonArray[selectedIndex];
    
    [self buttonONclicked:choosedBtn];
    _selectedIndex = selectedIndex;
    
    
}

- (void)setSelectedIndexStop:(NSInteger)selectedIndexStop
{
    [self layoutSubviews];
    UIButton *currentBtn = self.buttonArray[_selectedIndexStop];
    currentBtn.selected = NO;
    currentBtn.userInteractionEnabled = YES;
    UIButton *choosedBtn = self.buttonArray[selectedIndexStop];
    
    [self onClickedButton2:choosedBtn];
    _selectedIndex = selectedIndexStop;

}

- (void)onClickedButton2:(UIButton *)button
{
    self.isFirstLayoutSubviews = NO;
    UIButton *currentBtn = (UIButton *)[self viewWithTag:Button_tag + self.selectedIndexStop];
    currentBtn.selected = NO;
    currentBtn.userInteractionEnabled = YES;
    
    button.selected = YES;
    button.userInteractionEnabled = NO;
    
    _selectedIndexStop = button.tag - Button_tag;
    
    self.currentXOffset = button.center.x;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.slider.frame = CGRectMake(_slider.frame.origin.x, self.slider.frame.origin.y, [self.titlemArray[self.selectedIndexStop] doubleValue], self.slider.frame.size.height);
        
        self.slider.center = CGPointMake(button.center.x, self.slider.center.y);
        
    }];
}

- (void)setSelectedIndexNext:(NSInteger)selectedIndexNext
{
    [self layoutSubviews];
    if (selectedIndexNext > self.items.count -1) {
        
        NSException *exception = [[NSException alloc] initWithName:@"数组越界" reason:@"selectedIndex2大于items数组个数" userInfo:nil];
        @throw exception;
    }
    
    UIButton *currentBtn = self.buttonArray[_selectedIndexNext];
    currentBtn.selected = NO;
    currentBtn.userInteractionEnabled = YES;
    UIButton *choosedBtn = self.buttonArray[selectedIndexNext];
    [self moveSliderRightBySelectedIndex:choosedBtn];
    _selectedIndexNext = selectedIndexNext;
    
}

- (void)moveSliderRightBySelectedIndex:(UIButton *)button
{
    self.isFirstLayoutSubviews = NO;
    UIButton *currentBtn = (UIButton *)[self viewWithTag:Button_tag + _selectedIndexNext];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.slider.frame = CGRectMake(self.sliderOffset + _buttonMargin, _slider.frame.origin.y, currentBtn.frame.size.width, _slider.frame.size.height);
        
    }];
    [UIView animateWithDuration:0.5 animations:^{
        
        
        _slider.frame = CGRectMake(_slider.frame.origin.x, _slider.frame.origin.y, button.frame.size.width, _slider.frame.size.height);
        
    }];
    
    
    
    CGFloat sliderRightX = _slider.frame.origin.x + _slider.frame.size.width;
    
    if (_slider.frame.origin.x < button.center.x || sliderRightX > button.center.x) {
        
        currentBtn.selected = NO;
        currentBtn.userInteractionEnabled = YES;
        
        button.selected = YES;
        button.userInteractionEnabled = NO;
        
    }
    
    
}



@end
