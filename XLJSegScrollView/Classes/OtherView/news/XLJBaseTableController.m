//
//  XLJBaseTableController.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/31.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJBaseTableController.h"
/** UITabBar的高度 */
CGFloat const XMGTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const XMGNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const XMGTitlesViewH = 35;

@interface XLJBaseTableController ()

@end

@implementation XLJBaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XMGTabBarH, 0);
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}


@end
