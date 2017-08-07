//
//  KKAdRequest.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKAdRequest.h"
#import "NetworkStatusManager.h"
#import "KKAdPublic.h"

#define kAdAES256Key @"13f439726d2d4522" ///< 广告接口AES解密

@implementation KKAdRequest

+ (void)sendAdRequest:(NSString *)urlString tag:(NSInteger)tag parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 3;
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    
    [manager POST:urlString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 解析数据
        if ([responseObject isValidDictionary] && 0 == [[[responseObject objectForKey:@"state"] objectForKey:@"code"] integerValue]) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (success) {
                success(operation, dataDic, tag);
            }
        } else {
            if (failure) {
                NSString *message = [[responseObject safeObjectForKey:@"state"] safeObjectForKey:@"msg"];
                NSString *errorMessage = [message isValidString] ? message : @"AFNetworkingTool 请求失败！";
                NSError *error = [[NSError alloc] initWithDomain:@"KKPOEM_REQUEST_ERROR_DOMAIN"
                                                            code:1500
                                                        userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                
                failure(operation, error, tag);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error, tag);
        }
    }];
}

+ (void)sendAdAnalyticsRequest:(NSString *)urlString tag:(NSInteger)tag parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id, NSInteger))success failure:(void (^)(AFHTTPRequestOperation *, NSError *, NSInteger))failure {    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    
    [manager POST:urlString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
         // 解析数据
        if ([responseObject isValidData]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        }
         
        if ([responseObject isValidDictionary] && 200 == [[responseObject objectForKey:@"status"] integerValue]) {
             NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (success) {
                success(operation, dataDic, tag);
            }
        } else {
            if (failure) {
                NSString *message = [responseObject safeObjectForKey:@"message"];
                NSString *errorMessage = [message isValidString] ? message : @"KKAdRequest 请求失败！";
                NSError *error = [[NSError alloc] initWithDomain:@"KKYINGYU100K_REQUEST_ERROR_DOMAIN"
                                                            code:PARSE_JSON_ERROR
                                                        userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                 
                failure(operation, error, tag);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error, tag);
        }
    }];
}

// base64编码
+ (NSData *)decryptBase64Data:(NSData *)data {
    
    if ([data isValidData]) {
        
        NSString *base64ResponseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *base64ResponseData = [NSData dataFromBase64String:base64ResponseStr];
        NSData *newData = [base64ResponseData aes256DecryptWithkey:[kAdAES256Key dataValue] iv:nil];
        
        return newData;
    }
    return data;
}

@end
