//
//  JSPatchRequestManager.h
//  JSPatchDemo
//
//  Created by 龚 俊慧 on 16/9/8.
//  Copyright © 2016年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSPatchManager : NSObject

/// 初始化，会把一些工具JS文件拷贝到沙盒，必须最先调用此方法
+ (void)setup;

/// 执行本地已经存在的patch
+ (void)evaluateExistedPatch;

/// 异步请求线上的JSPatch文件
+ (void)requestJSPatch:(NSString *)URLString
            parameters:(nullable NSDictionary *)parameters
               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END