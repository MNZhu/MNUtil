//
//  BaseReq.m
//  MNUtil
//
//  Created by jacknan on 2019/4/12.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "BaseReq.h"
#import "BaseRsp.h"

@implementation BaseReq

- (NSString *)reqUrl
{
    return @"";
}

- (Class)rspClass
{
    NSString *reqStr = NSStringFromClass([self class]);
    if ([reqStr hasSuffix:@"Req"]) {
        NSString *rspStr = [[reqStr substringToIndex:reqStr.length-3] stringByAppendingString:@"Rsp"];
        return NSClassFromString(rspStr);
    }
    return nil;
}

@end
