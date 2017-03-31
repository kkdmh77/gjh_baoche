//
//  KKAdRequest.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/*
 * 广告请求
 */
@interface KKAdRequest : NSObject

/**
 * @method 加载请求广告
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
+ (void)sendAdRequest:(NSString *)urlString
                  tag:(NSInteger)tag
           parameters:(NSDictionary *)parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag))failure;

/**
 * @method 上报广告展示数据
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
+ (void)sendAdAnalyticsRequest:(NSString *)urlString
                           tag:(NSInteger)tag
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag))failure;

@end
