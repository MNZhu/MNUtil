//
//  MNPickerView.m
//  MNUtil
//
//  Created by jacknan on 2019/4/30.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNPickerView.h"

@interface MNPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) UIButton *maskView;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MNPickerView

+ (instancetype)showInView:(UIView *)inView WithTitleArr:(NSArray *)titleArr Complete:(void (^)(NSInteger index))complete
{
    MNPickerView *view = [[MNPickerView alloc] init];
    view.frame = inView.bounds;
    [inView addSubview:view];
    view.Complete = complete;
    view.titleArr = [titleArr copy];
    [view initView];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.maskView.alpha = 0.4;
        view.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
    return view;
}

- (void)initView
{
    self.backgroundColor = UIColor.clearColor;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    // mask view
    UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    self.maskView = maskView;
    maskView.backgroundColor = UIColor.blackColor;
    maskView.alpha = 0.0;
    maskView.frame = self.bounds;
    [self addSubview:maskView];
    
    //content view
    UIView *contentView = UIView.alloc.init;
    self.contentView = contentView;
    contentView.frame = CGRectMake(0, h*0.5, w, h*0.5);
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, contentView.bounds.size.height);
    [self addSubview:contentView];
    
    //picker view
    UIPickerView *view = [[UIPickerView alloc] init];
    self.pickerView = view;
    view.backgroundColor = [UIColor whiteColor];
    view.delegate = self;
    view.frame = contentView.bounds;
    [contentView addSubview:view];
    
    //ok btn
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [okBtn setTitle:@"ok" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(w-10-50, 10, 60, 40);
    [okBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:okBtn];
    
    
    //cancel btn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(10, 10, 60, 40);
    [cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
}

- (void)completeAction
{
    if (self.Complete) {
        self.Complete(self.currentIndex);
    }
    [self removeSelf];
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.contentView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.titleArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.titleArr[row];
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentIndex = row;
}

@end
