//
//  ViewController.m
//  PTSProgressHUD
//
//  Created by 黄杰 on 16/2/23.
//  Copyright © 2016年 黄杰. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 *  点击了加载按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)didClickLoadBtn:(UIButton *)sender {
    TestViewController *test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}
@end
