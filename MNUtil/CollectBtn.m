//
//  CollectBtn.m
//  MNUtil
//
//  Created by jacknan on 2016/10/18.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import "CollectBtn.h"
#import "MNUtil.h"

@interface CollectBtn()
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation CollectBtn

-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CollectBtn" owner:nil options:nil]firstObject];
        
//        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpClick)];
//        [self addGestureRecognizer:lp];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lpClick)];
//        [self addGestureRecognizer:tap];
        [_btn setBackgroundImage:[UIImage imageWithColor_mn:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches
{
    
}

-(void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    
}


-(void)lpClick
{
    self.backgroundColor = [UIColor whiteColor];
}


//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.backgroundColor = [UIColor lightGrayColor];
//}


@end
