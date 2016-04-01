//
//  AFNetWorkUtil.m
//  GoodSex
//
//  Created by KungJack on 10/10/14.
//  Copyright (c) 2014 Jack. All rights reserved.
//

#import "AFNetWorkUtil.h"

@implementation AFNetWorkUtil

+ (void)DDTPOST:(NSString *)urlString
  isShowLoading:(BOOL)isShowLoading
            tag:(NSInteger)tag
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject,NSInteger netWorkTag))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (isShowLoading) {
        
    }
    
    NSMutableDictionary *parametersWithSign = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", @"text/json", @"text/javascript", nil];
    [manager GET:urlString parameters:parametersWithSign success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject,tag);
        }
        
        if (isShowLoading) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
        
        if (isShowLoading) {
            
        }
    }];
}

+ (void)DDTPOST:(NSString *)urlString
            tag:(NSInteger)tag
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSInteger netWorkTag))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [AFNetWorkUtil DDTPOST:urlString isShowLoading:NO tag:tag parameters:parameters success:success failure:failure];
}

+ (void)CheckDataPackageVersion:(NSInteger)fileIndex
                    parameters:(id)parameters
                       success:(void (^)(DataPackageInfoModel *model))success
                       failure:(void (^)(NSError *error))failure{
    
}

@end
