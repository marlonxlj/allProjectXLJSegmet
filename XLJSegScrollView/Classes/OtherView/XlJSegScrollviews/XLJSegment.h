//
//  XLJSegment.h
//  XLJSegScrollView
//
//  Created by m on 2016/10/20.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLJSegment : UIView

/**点击事件*/
- (void)addTagert:(id)target action:(SEL)action;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat totoalWidth;
@property (nonatomic, assign) NSInteger selectedIndexStop;
@property (nonatomic, assign) CGFloat currentXOffset;
@property (nonatomic, assign) NSInteger selectedIndexNext;
@property (nonatomic, assign) CGFloat sliderOffset;
/**
 *  初始化title
 *
 *  @param frame       frame
 *  @param titleItems  标题数组
 *  @param fontSize    字体大小
 *  @param sliderColor 下划线颜色
 *
 *  @return
 */
- (instancetype)initWithSegmentFrame:(CGRect)frame withButtonTitleItems:(NSMutableArray *)titleItems withButtonFontSize:(CGFloat)fontSize withSliderColor:(UIColor *)sliderColor;


@end
