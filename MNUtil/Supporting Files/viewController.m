//
//  viewController.m
//  MNUtil
//
//  Created by jacknan on 2019/4/16.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "viewController.h"
#import "MNLogManager.h"

@interface viewController ()

@end

@implementation viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    int i = 1000;
    while (i--) {
        MNLOG_DEBUG(@"测试打印 %d",i);
    }
    NSLog(@"end");
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
