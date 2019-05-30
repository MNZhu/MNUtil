//
//  Test1ViewController.m
//  MNUtil
//
//  Created by jacknan on 2019/5/5.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "Test1ViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"test1";
    self.view.backgroundColor = UIColor.yellowColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
}

- (void)next
{
    [self.navigationController pushViewController:Test2ViewController.new animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end

@implementation Test2ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.fd_prefersNavigationBarHidden = YES;
//        self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"下" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
}

- (void)next
{
    [self.navigationController pushViewController:Test3ViewController.new animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end

@implementation Test3ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.fd_prefersNavigationBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    self.title = @"test3";
}

@end
