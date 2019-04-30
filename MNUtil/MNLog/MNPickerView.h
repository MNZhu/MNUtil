//
//  MNPickerView.h
//  MNUtil
//
//  Created by jacknan on 2019/4/30.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MNPickerView : UIView

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, copy) void(^Complete)(NSInteger index);

+ (instancetype)showInView:(UIView *)inView WithTitleArr:(NSArray *)titleArr Complete:(void (^)(NSInteger index))complete;
@end

NS_ASSUME_NONNULL_END
