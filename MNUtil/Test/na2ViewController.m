//
//  na2ViewController.m
//  MNUtil
//
//  Created by jacknan on 2016/11/17.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "na2ViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface na2ViewController ()

@end

@implementation na2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"2";
    self.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController setFd_prefersNavigationBarHidden:YES];
    
}



@end
