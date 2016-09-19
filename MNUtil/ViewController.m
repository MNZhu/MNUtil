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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
//    
//    
//    NSString *s = [MNUtil getiphoneType];
//    
//    NSLog(@"%@--",[s md5Withstring:@"dsafafafasfa"]);
//    return;
//    
//    [MNUtil GETwithUrl:@"http://paonan580.com/api/v1/dn-videos" Paras:@{
//  @"access-token" : @"bFQ7niDGLsYCp-vPm6HAienWpPsxjrRI",
//  @"page" : @"1",
//  @"per-page" : @"20"
//    } successBlock:^(NSURLSessionDataTask * _Nonnull task, id _Nullable ResponseData) {
//        NSLog(@"%@",ResponseData);
//    } FailBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    } Progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%f",downloadProgress.completedUnitCount/(CGFloat)downloadProgress.totalUnitCount);
//    }];
}



@end
