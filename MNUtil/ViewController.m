//
//  ViewController.m
//  MNUtil
//
//  Created by jacknan on 2016/9/19.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "ViewController.h"
#import "MNUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>
#import "CircleProgressView.h"
#import <Masonry.h>
#import "XMGWaterflowLayout.h"
#import <objc/runtime.h>
#import "test1ViewController.h"
#import "CollectBtn.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "HomePresentationController.h"
#import "PopAnimation.h"
#import "na1ViewController.h"
#import "na2ViewController.h"
#import "MNNavigationViewController.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic,weak)CircleProgressView* p;
@property(nonatomic,strong)dispatch_source_t timer;

@property(nonatomic,strong)UIView* tab;
@property(nonatomic,strong)UIView* tt;

@property(nonatomic,strong) PopAnimation* presentVc;


@end

@implementation ViewController

-(PopAnimation *)presentVc
{
    if (!_presentVc) {
        _presentVc = [[PopAnimation alloc]init];
    }
    return _presentVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, 30, 60, 60);
    [btn setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)hide
{
    
}

-(void)test
{
//    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:[[na1ViewController alloc]init]];
    MNNavigationViewController *na = [[MNNavigationViewController alloc]initWithRootViewController:[[na1ViewController alloc]init]];
    [self presentViewController:na animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    //弹出视频-自定义动画
    test1ViewController *vc = [[test1ViewController alloc]init];
    vc.view.backgroundColor = [UIColor orangeColor];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = (id)self.presentVc;
    [self presentViewController:vc animated:YES completion:nil];

}


















@end
