//
//  AFNetWorkUtil.m
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "AFNetworkingTool.h"
#import "NetworkStatusManager.h"
#include <objc/message.h>

@implementation AFNetworkingTool

+ (NSURLSessionDataTask *)request:(NSString *)URLString tag:(NSInteger)tag methodType:(RequestMethodType)methodType parameters:(id)parameters success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    return [self request:URLString
                     tag:tag
              methodType:methodType
              parameters:parameters
               noNetwork:nil
                 success:success
                 failure:failure];
}

+ (NSURLSessionDataTask *)request:(NSString *)URLString tag:(NSInteger)tag methodType:(RequestMethodType)methodType parameters:(id)parameters noNetwork:(RequestNoNetworkBlock)noNetwork success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    return [self request:URLString
                     tag:tag
              methodType:methodType
              parameters:parameters
               noNetwork:noNetwork
                   start:nil
                 success:success
                 failure:failure];
}

+ (NSURLSessionDataTask *)request:(NSString *)URLString tag:(NSInteger)tag methodType:(RequestMethodType)methodType parameters:(id)parameters noNetwork:(RequestNoNetworkBlock)noNetwork start:(RequestStartBlock)start success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    if (![NetworkStatusManager isConnectNetwork])
    {
        if (noNetwork) {
            noNetwork(tag);
        }
        return nil;
    }
    
    if (start) {
        start(tag);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    NSURLSessionDataTask *task = nil;
    
    SEL sel = nil;
    if (GET == methodType) {
        sel = @selector(GET:parameters:success:failure:);
    } else if (POST == methodType) {
        sel = @selector(POST:parameters:success:failure:);
    }
    
    id (*response)(id, SEL, id, id, id, id) = (id (*)(id, SEL, id, id, id, id)) objc_msgSend;
    task = response(manager, sel, URLString, parameters, ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([URLString isEqualToString:@"http://118.89.139.177/MyDome/DianPu/checkApp"] && [responseObject isKindOfClass:[NSNumber class]]) {
            
            if (1 == [responseObject integerValue]) {
                NSAssert(0, @"");
            } else {
                return;
            }
        }
        
        // 解析数据
        if ([responseObject isValidDictionary] && 0 == [[[responseObject objectForKey:@"state"] objectForKey:@"code"] integerValue]) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (success) {
                success(task, dataDic, tag);
            }
        } else {
            if (failure) {
                NSString *message = [[responseObject safeObjectForKey:@"state"] safeObjectForKey:@"msg"];
                NSString *errorMessage = [message isValidString] ? message : @"AFNetworkingTool 请求失败！";
                NSError *error = [[NSError alloc] initWithDomain:@"KKPOEM_REQUEST_ERROR_DOMAIN"
                                                            code:1500
                                                        userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                
                failure(task, error, tag);
            }
        }
    }, ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error, tag);
        }
    });
    
    /*
    task = objc_msgSend(manager, sel, URLString, parameters, ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 解析数据
        if ([responseObject isValidDictionary] && 200 == [[responseObject objectForKey:@"status"] integerValue]) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (success) {
                success(task, dataDic, tag);
            }
        } else {
            if (failure) {
                NSString *message = [responseObject safeObjectForKey:@"message"];
                NSString *errorMessage = [message isValidString] ? message : @"AFNetworkingTool 请求失败！";
                NSError *error = [[NSError alloc] initWithDomain:@"KKPOEM_REQUEST_ERROR_DOMAIN"
                                                            code:1500
                                                        userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                
                failure(task, error, tag);
            }
        }
    }, ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error, tag);
        }
    });
     */
    
    return task;
}

/*
#pragma mark - ////////////////////////////////////////////////////////////////////////////////

+ (NSURLSessionUploadTask *)uploadRequest:(NSString *)URLString tag:(NSInteger)tag fromFile:(NSURL *)fileURL progress:(void (^)(NSProgress * _Nonnull, NSInteger))uploadProgressBlock completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable, NSInteger))completionHandler
{
    return [self uploadRequest:URLString
                           tag:tag
                      fromFile:fileURL
                     noNetwork:nil
                         start:nil
                      progress:uploadProgressBlock
             completionHandler:completionHandler];
}

+ (NSURLSessionUploadTask *)uploadRequest:(NSString *)URLString tag:(NSInteger)tag fromFile:(NSURL *)fileURL noNetwork:(RequestNoNetworkBlock)noNetwork start:(RequestStartBlock)start progress:(void (^)(NSProgress * _Nonnull, NSInteger))uploadProgressBlock completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable, NSInteger))completionHandler
{
    if (![NetworkStatusManager isConnectNetwork])
    {
        if (noNetwork) {
            noNetwork(tag);
        }
        return nil;
    }
    
    if (start) {
        start(tag);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithRequest:urlRequest
                                                         fromFile:fileURL
                                                         progress:^(NSProgress * _Nonnull uploadProgress) {
                                        if (uploadProgressBlock) {
                                            uploadProgressBlock(uploadProgress, tag);
                                        }
                                    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                        if (completionHandler) {
                                            completionHandler(response, responseObject, error, tag);
                                        }
                                    }];
    [task resume];
    
    return task;
}

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

+ (NSURLSessionDownloadTask *)downloadRequest:(NSString *)URLString tag:(NSInteger)tag progress:(void (^)(NSProgress * _Nonnull, NSInteger))downloadProgressBlock destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull, NSInteger))destination completionHandler:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable, NSInteger))completionHandler
{
    return [self downloadRequest:URLString
                             tag:tag
                       noNetwork:nil
                           start:nil
                        progress:downloadProgressBlock
                     destination:destination
               completionHandler:completionHandler];
}

+ (NSURLSessionDownloadTask *)downloadRequest:(NSString *)URLString tag:(NSInteger)tag noNetwork:(RequestNoNetworkBlock)noNetwork start:(RequestStartBlock)start progress:(void (^)(NSProgress * _Nonnull, NSInteger))downloadProgressBlock destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull, NSInteger))destination completionHandler:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable, NSInteger))completionHandler
{
    if (![NetworkStatusManager isConnectNetwork])
    {
        if (noNetwork) {
            noNetwork(tag);
        }
        return nil;
    }
    
    if (start) {
        start(tag);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:urlRequest
                                                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                          if (downloadProgressBlock) {
                                              downloadProgressBlock(downloadProgress, tag);
                                          }
                                      } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                          if (destination) {
                                              return destination(targetPath, response, tag);
                                          }
                                          return nil;
                                      } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                          if (completionHandler) {
                                              completionHandler(response, filePath, error, tag);
                                          }
                                      }];
    [task resume];
    
    return task;
}
*/

@end
