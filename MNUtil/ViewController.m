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
#import "test2ViewController.h"
#import "HomePresentationController.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic,weak)CircleProgressView* p;
@property(nonatomic,strong)dispatch_source_t timer;

@property(nonatomic,strong)UIView* tab;
@property(nonatomic,strong)UIView* tt;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
}

-(void)hide
{
    
}

-(void)test
{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    test1ViewController *vc = [[test1ViewController alloc]init];
    vc.view.backgroundColor = [UIColor orangeColor];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    
    
    
    
    [self presentViewController:vc animated:YES completion:nil];

}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    HomePresentationController *presentVc = [[HomePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
    
    return presentVc;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    BOOL a = transitionContext.isInteractive;
    MN_Log(@"%d",a);
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [transitionContext.containerView addSubview:toView];
    
    toView.layer.anchorPoint = CGPointMake(1, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
    }];
    
    MN_Log(@"%@",toVc);
    MN_Log(@"%@",fromVc);
    
    
}


@end
