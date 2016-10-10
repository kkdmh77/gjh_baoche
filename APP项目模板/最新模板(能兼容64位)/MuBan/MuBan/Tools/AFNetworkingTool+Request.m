//
//  AFNetworkingTool+Request.m
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "AFNetworkingTool+Request.h"
#import "UrlManager.h"
#import "HUDManager.h"

@implementation AFNetworkingTool (Request)

+ (NSURLSessionDataTask *)request:(NetRequestType)requestType methodType:(RequestMethodType)methodType parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    return [self request:requestType
              methodType:methodType
              parameters:parameters
               noNetwork:^(NSInteger tag) {
                   [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:NoConnectionNetwork
                                                               showType:HUDOperationFailed];
               }
                 success:success
                 failure:failure];
}

+ (NSURLSessionDataTask *)request:(NetRequestType)requestType methodType:(RequestMethodType)methodType parameters:(NSDictionary *)parameters noNetwork:(RequestNoNetworkBlock)noNetwork success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    return [self request:requestType
              methodType:methodType
              parameters:parameters
               noNetwork:noNetwork
                   start:nil
                 success:success
                 failure:failure];
}

+ (NSURLSessionDataTask *)request:(NetRequestType)requestType methodType:(RequestMethodType)methodType parameters:(NSDictionary *)parameters noNetwork:(RequestNoNetworkBlock)noNetwork start:(RequestStartBlock)start success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:requestType]];
    
    return [self request:url.absoluteString
                     tag:requestType
              methodType:methodType
              parameters:parameters
               noNetwork:noNetwork
                   start:start
                 success:success
                 failure:failure];
}

@end
