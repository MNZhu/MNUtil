//
//  test1ViewController.m
//  MNUtil
//
//  Created by jacknan on 2016/10/18.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "test1ViewController.h"
#import "MNUtil.h"
#import "test.h"

typedef void (^bloc)();

@interface test1ViewController ()
@property(nonatomic,strong)NSMutableArray* arr;



@end

@implementation test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    test *t = [[test alloc]init];
    t.frame = CGRectMake(10, 30, 100, 100);
    [self.view addSubview:t];
    
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)dealloc
{
    NSLog(@"销毁");
}

@end
