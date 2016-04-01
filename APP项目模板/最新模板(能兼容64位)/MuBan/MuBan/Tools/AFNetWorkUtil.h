//
//  AFNetWorkUtil.h
//  GoodSex
//
//  Created by KungJack on 10/10/14.
//  Copyright (c) 2014 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DataPackageInfoModel.h"

@interface AFNetWorkUtil : NSObject

+ (void)DDTPOST:(NSString *)urlString
  isShowLoading:(BOOL)isShowLoading
            tag:(NSInteger)tag
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject,NSInteger netWorkTag))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)DDTPOST:(NSString *)urlString
            tag:(NSInteger)tag
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSInteger netWorkTag))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)CheckDataPackageVersion:(NSInteger)fileIndex
                     parameters:(id)parameters
                        success:(void (^)(DataPackageInfoModel *model))success
                        failure:(void (^)(NSError *error))failure;

@end
