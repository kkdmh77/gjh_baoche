//
//  AFNetworkingTool+Request.h
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "AFNetworkingTool.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface AFNetworkingTool (Request)

+ (nullable NSURLSessionDataTask *)request:(NetRequestType)requestType
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;

+ (nullable NSURLSessionDataTask *)request:(NetRequestType)requestType
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                 noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;

+ (nullable NSURLSessionDataTask *)request:(NetRequestType)requestType
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                 noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                     start:(nullable RequestStartBlock)start
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;

@end
