//
//  TestRsp.h
//  MNUtil
//
//  Created by jacknan on 2019/4/16.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "BaseRsp.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestRsp : BaseRsp

@property (nonatomic, strong) NSString *message;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
