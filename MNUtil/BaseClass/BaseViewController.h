//
//  BaseViewController.h
//  MNUtil
//
//  Created by jacknan on 2017/11/14.
//  Copyright © 2017年 jacknan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationBar.h"

@interface BaseViewController : UIViewController

@property (nonatomic,weak) BaseNavigationBar *navBar;   //自定义导航栏

@end
