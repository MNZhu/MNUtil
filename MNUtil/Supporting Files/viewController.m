//
//  viewController.m
//  MNUtil
//
//  Created by jacknan on 2019/4/16.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "viewController.h"
#import "MNLogManager.h"
#import "MNDebugConfigViewController.h"
#import "MNAppLogViewController.h"
#import "Test1ViewController.h"
#import "MNNetwork.h"
#import <Colours.h>

@interface viewController ()

@end

@implementation viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"下" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    [UIColor colorFromHexString:@""];
    
    MNLOG_DEBUG(@"1111");
}

- (void)next
{
    Test1ViewController *vc = [Test1ViewController new];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",MNNETWORK.sessionManager.requestSerializer.HTTPRequestHeaders);
    
//    Test1ViewController *vc = [Test1ViewController new];
//    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:na animated:YES completion:nil];
    
    
//    MNAppLogViewController *vc = [[MNAppLogViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
   
    MNDebugConfigViewController *vc = [[MNDebugConfigViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    MNLOG_ERROR(@"测试日志测测试日志测试日");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
