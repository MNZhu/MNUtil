//
//  CircleProgressView.h
//  MNUtil
//
//  Created by jacknan on 2016/9/21.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView


//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;


//百分比数值（0-1）
@property (assign, nonatomic)float percent;

//圆环宽度
@property (assign, nonatomic)float width;

@end


