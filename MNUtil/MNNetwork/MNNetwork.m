//
//  ABSNetwork.m
//  MNUtil
//
//  Created by jacknan on 2019/4/12.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNNetwork.h"
#import <MJExtension/MJExtension.h>

@interface MNNetwork ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation MNNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSessionManager];
    }
    return self;
}

- (void)setupSessionManager
{
    //requestSerializer
    self.sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 15;
    self.sessionManager.requestSerializer = requestSerializer;
    
    //responseSerializer
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    self.sessionManager.responseSerializer = responseSerializer;
}

- (void)cancelAllRequest
{
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

- (nullable NSURLSessionDataTask *)GETWithReq:(BaseReq *)req
                                      success:(successBlock)success
                                      failure:(failureBlock)failure
                                     Progress:(nullable progressBlock) progress
{
    Class cls = [req rspClass];
    req.dataTask = [self.sessionManager GET:req.reqUrl parameters:req.mj_keyValues progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRsp *rsp = [cls mj_objectWithKeyValues:responseObject];
        if (success) success(task,responseObject,rsp);
    } failure:failure];
    return req.dataTask;
}

- (nullable NSURLSessionDataTask *)GETWithReq:(BaseReq *)req
                                      success:(successBlock)success
                                      failure:(failureBlock)failure
{
    return [self GETWithReq:req success:success failure:failure Progress:nil];
}

- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                                       success:(successBlock)success
                                       failure:(failureBlock)failure
                                      Progress:(nullable progressBlock) progress
{
    Class cls = [req rspClass];
    req.dataTask = [self.sessionManager POST:req.reqUrl parameters:req.mj_keyValues progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRsp *rsp = [cls mj_objectWithKeyValues:responseObject];
        if (success) success(task,responseObject,rsp);
    } failure:failure];
    return req.dataTask;
}

- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                                       success:(successBlock)success
                                       failure:(failureBlock)failure
{
    return [self POSTWithReq:req success:success failure:failure Progress:nil];
}

- (nullable NSURLSessionDataTask *)POSTWithReq:(BaseReq *)req
                     constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                       success:(successBlock)success
                                       failure:(failureBlock)failure
                                      Progress:(void (^)(NSProgress * _Nonnull uploadProgress))progress
{
    Class cls = [req rspClass];
    req.dataTask = [self.sessionManager POST:req.reqUrl parameters:req.mj_keyValues constructingBodyWithBlock:block progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRsp *rsp = [cls mj_objectWithKeyValues:responseObject];
        if (success) success(task,responseObject,rsp);
    } failure:failure];
    return req.dataTask;
}

- (nullable NSURLSessionDataTask *)PUTWithReq:(BaseReq *)req
                                      success:(successBlock)success
                                      failure:(failureBlock)failure
                                     Progress:(progressBlock) progress
{
    Class cls = [req rspClass];
    req.dataTask = [self.sessionManager PUT:req.reqUrl parameters:req.mj_keyValues success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRsp *rsp = [cls mj_objectWithKeyValues:responseObject];
        if (success) success(task,responseObject,rsp);
    } failure:failure];
    return req.dataTask;
}

- (nullable NSURLSessionDataTask *)DELETEWithReq:(BaseReq *)req
                                         success:(successBlock)success
                                         failure:(failureBlock)failure
                                        Progress:(progressBlock) progress
{
    Class cls = [req rspClass];
    req.dataTask = [self.sessionManager DELETE:req.reqUrl parameters:req.mj_keyValues success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRsp *rsp = [cls mj_objectWithKeyValues:responseObject];
        if (success) success(task,responseObject,rsp);
    } failure:failure];
    return req.dataTask;
}

@end
