###ScrolView自定义segment

###前言：

刚开始不是知从哪里下手.
定义一个继承自scrollView的类，一个继承自UIView的类.

###一、遇到的问题

在这里卡了有一段时间，因为一直以为`self.navigationController.automaticallyAdjustsScrollViewInsets = NO; `这个能解决问题，但是发现更根本不行。以至开始怀疑人生

```
//这句话没有作用，不知道是什么？？？
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
//下面这句话有作用???
注:据说是内边距的问题
self.automaticallyAdjustsScrollViewInsets = NO;

```
###效果图一:


###二、根据标题数组的个数来创建按钮
通过button setFrame来设置按钮的位置

###遇到问题
按钮选中的状态不对，下划的也不对。
###效果图二:


###三、此问题的难点在于,当我们的在改变frame的时候就会进行重复的调用,很多的时候会忽略这个事情:

```
- (void)layoutSubviews
```
而在`- (void)layoutSubviews`方法中进行的创建按钮的下划线

```
  //创建按钮
   [self creatButton];
        
  //创建线
  [self creatLineAddSlider];

```
```
//改变滑块的位置
    self.currentXOffset = button.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.slider.frame = CGRectMake(self.slider.frame.origin.x, self.slider.frame.origin.y, [self.titlemArray[self.currentSelectedSaveIndex] doubleValue], self.slider.frame.size.height);
        
        self.slider.center = CGPointMake(button.center.x, self.slider.center.y);
        
    }];
```

既然原因找到那就好做了，通过做标记的方式来不让他重复的进行创建，只创建一次就好了。

```
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isFirstLayoutSubviews) {
    
        [self settingButtonTileLength];
        
        //创建按钮
        [self creatButton];
        
        //创建线
        [self creatLineAddSlider];

    }
}

```
###效果图三:


###四、现在需要解决多个标题适配scrollview滚动的问题，这样segment基本的功能实现，现在处理scrollView的frame问题。
标题数目与scrollview的宽度和contsize
在这里也同样有layoutSubviews的问题，同样需要对其设置标记。
但是问题还是没有解决，只是解决了效率和重复创建的问题。

这里应该使用segment的宽度，当时我自己写的宽度是totoalWidth。
```
self.contentSize = CGSizeMake(CGRectGetWidth(self.segMent.frame), 0);
```
至此这个问题解决。
####效果图四：

###五、接下来要做的就是添加子视图了:












