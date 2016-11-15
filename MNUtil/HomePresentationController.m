//
//  HomePresentationController.m
//  MNUtil
//
//  Created by jacknan on 2016/11/11.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "HomePresentationController.h"

@implementation HomePresentationController



-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        
    }
    return self;
}

-(void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    
    self.presentedViewController.view.frame = CGRectMake(30, 64, 200, 400);
    
}

@end
