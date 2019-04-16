//
//  BaseReq.h
//  MNUtil
//
//  Created by jacknan on 2019/4/12.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "ABSNetwork.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseReq : NSObject

@property (nonatomic, weak) NSURLSessionDataTask *dataTask;


- (NSString *)reqUrl;

- (Class)rspClass;
@end

NS_ASSUME_NONNULL_END
