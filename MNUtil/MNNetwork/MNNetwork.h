//
//  ABSNetwork.h
//  MNUtil
//
//  Created by jacknan on 2019/4/12.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "BaseReq.h"
#import "BaseRsp.h"
@class BaseReq;

typedef void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable ResponseData, BaseRsp * _Nullable baseRsp);
typedef void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
typedef void(^progressBlock)(NSProgress * _Nonnull downloadProgress);

NS_ASSUME_NONNULL_BEGIN

@interface MNNetwork : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;


- (void)cancelAllRequest;

#pragma mark GET
- (nullable NSURLSessionDataTask *)GETWithReq:(BaseReq *)req
                                      success:(nullable successBlock)success
                                      failure:(nullable failureBlock)failure
                                     Progress:(nullable progressBlock) progress;

- (nullable NSURLSessionDataTask *)GETWithReq:(BaseReq *)req
                                      success:(nullable successBlock)success
                                      failure:(nullable failureBlock)failure;
#pragma mark POST
- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                                       success:(nullable successBlock)success
                                       failure:(nullable failureBlock)failure
                                      Progress:(nullable progressBlock) progress;

- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                                       success:(nullable successBlock)success
                                       failure:(nullable failureBlock)failure;

- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                     constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                       success:(nullable successBlock)success
                                       failure:(nullable failureBlock)failure
                                      Progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))progress;
#pragma mark PUT
- (nullable NSURLSessionDataTask *)PUTWithReq:(BaseReq *)req
                                      success:(nullable successBlock)success
                                      failure:(nullable failureBlock)failure
                                     Progress:(nullable progressBlock) progress;
#pragma mark DELETE
- (nullable NSURLSessionDataTask *)DELETEWithReq:(BaseReq *)req
                                         success:(nullable successBlock)success
                                         failure:(nullable failureBlock)failure
                                        Progress:(nullable progressBlock) progress;
@end

NS_ASSUME_NONNULL_END
