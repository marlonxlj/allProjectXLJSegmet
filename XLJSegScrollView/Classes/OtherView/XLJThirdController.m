//
//  XLJThirdController.m
//  XLJSegScrollView
//
//  Created by m on 2016/10/18.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "XLJThirdController.h"

@interface XLJThirdController ()

@end

@implementation XLJThirdController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"Third";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
