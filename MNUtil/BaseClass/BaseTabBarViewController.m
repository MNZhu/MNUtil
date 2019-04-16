//
//  BaseTabBarViewController.m
//  MNUtil
//
//  Created by jacknan on 2017/11/14.
//  Copyright © 2017年 jacknan. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSMutableArray *arr = [NSMutableArray array];
//        NSString *a = nil;
//        [arr addObject:a];
//    });
}

- (void)initView
{
    UINavigationController *na1 = [[BaseNavigationController alloc]initWithRootViewController:[[BaseViewController alloc]init]];
    na1.title = @"page1";
    [self addChildViewController:na1];
    
    UINavigationController *na2 = [[BaseNavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    na2.title = @"page2";
    [self addChildViewController:na2];
    
    UINavigationController *na3 = [[BaseNavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    na3.title = @"page3";
    [self addChildViewController:na3];
    
    UINavigationController *na4 = [[BaseNavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    na4.title = @"page4";
    [self addChildViewController:na4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
