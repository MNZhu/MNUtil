//
//  MNNaviAnimation.m
//  MNUtil
//
//  Created by jacknan on 2016/11/17.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "MNNaviAnimation.h"
#import <UIKit/UIKit.h>

@interface MNNaviAnimation()<UIViewControllerAnimatedTransitioning>

@end

@implementation MNNaviAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}


-(void)animationEnded:(BOOL)transitionCompleted
{
    
    
    
}

@end
