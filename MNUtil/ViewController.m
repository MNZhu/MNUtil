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



@interface ViewController ()

@property(nonatomic,weak)CircleProgressView* p;
@property(nonatomic,strong)dispatch_source_t timer;

@property(nonatomic,strong)UIView* tab;
@property(nonatomic,strong)UIView* tt;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    

    
    
}

-(void)hide
{
    
}

-(void)test
{
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSDate *cc = [[NSDate alloc]init];
    
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *d = [f stringFromDate:cc];
    NSLog(@"%@",d);
}
@end
