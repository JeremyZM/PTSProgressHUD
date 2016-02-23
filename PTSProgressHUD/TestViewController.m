//
//  TestViewController.m
//  LoadingTest
//
//  Created by 黄杰 on 15/11/28.
//  Copyright © 2015年 黄杰. All rights reserved.
//

#import "TestViewController.h"
#import "PTSProgressHUD.h"
#import "HttpManage.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    // 设置hud字体颜色
    [PTSProgressHUD setTitleColor:[UIColor grayColor]];
    // 完成后的状态回调
    [PTSProgressHUD shareView].statusBlock = ^ (PTSProgressStatus status) {
        NSLog(@"%zi", status);
    };
    // 加载视图
    [PTSProgressHUD showWithGifImagePath:@"xxx.gif" withTitle:@"加载中" toView:self.view];
}

- (void)dealloc
{
    NSLog(@"销毁了");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupData];
    });
}

/**
 *  请求网络数据
 */
- (void)setupData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pid"] = @"5";
    
    NSString *url = @"http://365ttq.com/api/?action=ad&control=list";
    
    [HttpManage PostWithURL:url parameters:param success:^(id json) {
        
        NSLog(@"%@", json);
        // 隐藏视图
        [PTSProgressHUD hide];
        
    } failure:^(NSError *error) {
        // 隐藏视图
        [PTSProgressHUD hide];
    }];
}

@end
