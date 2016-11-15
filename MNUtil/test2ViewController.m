//
//  test2ViewController.m
//  MNUtil
//
//  Created by jacknan on 2016/11/9.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "test2ViewController.h"

@interface test2ViewController ()

@end

@implementation test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *maskbg = [[UIView alloc]initWithFrame:CGRectMake(30, 90, 100, 100)];
    maskbg.backgroundColor = [UIColor greenColor];
    [self.view addSubview:maskbg];
    
    CABasicAnimation *animaton = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animaton.toValue = [NSNumber numberWithDouble:2 * M_PI];
    animaton.duration = 10;
    animaton.repeatCount = MAXFLOAT;
    animaton.removedOnCompletion = NO;
    [maskbg.layer addAnimation:animaton forKey:nil ];
    
    // Do any additional setup after loading the view.
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(80, 190, 90, 90)];
    la.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:la];
    
    
    
    
    __block int i = 0;
    
    NSTimer *tim = [NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer * _Nonnull timer) {
        la.text = [NSString stringWithFormat:@"%d",i];
        i++;
        
        
        
        
    }];
    
    [[NSRunLoop currentRunLoop]addTimer:tim forMode:NSDefaultRunLoopMode];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
