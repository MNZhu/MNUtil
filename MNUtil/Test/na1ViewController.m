//
//  na1ViewController.m
//  MNUtil
//
//  Created by jacknan on 2016/11/17.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "na1ViewController.h"
#import "na2ViewController.h"

@interface na1ViewController ()<UINavigationControllerDelegate>

@end

@implementation na1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}


-(void)next
{
    na2ViewController *vc = [[na2ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
