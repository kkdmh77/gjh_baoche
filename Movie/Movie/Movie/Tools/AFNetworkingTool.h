//
//  AFNetWorkUtil.h
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, RequestMethodType)
{
    GET = 0,
    POST
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^RequestNoNetworkBlock) (NSInteger tag);
typedef void (^RequestStartBlock)     (NSInteger tag);
typedef void (^RequestProgressBlock)  (NSProgress *progress, NSInteger tag);
typedef void (^RequestSuccessBlock)   (NSURLSessionDataTask *task, id _Nullable responseObject, NSInteger tag);
typedef void (^RequestFailedBlock)    (NSURLSessionDataTask * _Nullable task, NSError *error, NSInteger tag);

@interface AFNetworkingTool : NSObject

+ (nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                       tag:(NSInteger)tag
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;

+ (nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                       tag:(NSInteger)tag
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                 noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;

+ (nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                       tag:(NSInteger)tag
                                methodType:(RequestMethodType)methodType
                                parameters:(nullable NSDictionary *)parameters
                                 noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                     start:(nullable RequestStartBlock)start
                                   success:(nullable RequestSuccessBlock)success
                                   failure:(nullable RequestFailedBlock)failure;


/*因为不支持重启应用后的断点续传,暂时不用这个类进行文件下载
 *************************************************
 
////////////////////////////////////////////////////////////////////////////////

+ (NSURLSessionUploadTask *)uploadRequest:(NSString *)URLString
                                      tag:(NSInteger)tag
                                 fromFile:(NSURL *)fileURL
                                 progress:(nullable void (^)(NSProgress *uploadProgress, NSInteger tag))uploadProgressBlock
                        completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error, NSInteger tag))completionHandler;

+ (NSURLSessionUploadTask *)uploadRequest:(NSString *)URLString
                                      tag:(NSInteger)tag
                                 fromFile:(NSURL *)fileURL
                                noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                    start:(nullable RequestStartBlock)start
                                 progress:(nullable void (^)(NSProgress *uploadProgress, NSInteger tag))uploadProgressBlock
                        completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error, NSInteger tag))completionHandler;

////////////////////////////////////////////////////////////////////////////////

+ (NSURLSessionDownloadTask *)downloadRequest:(NSString *)URLString
                                          tag:(NSInteger)tag
                                     progress:(nullable void (^)(NSProgress *downloadProgress, NSInteger tag))downloadProgressBlock
                                  destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response, NSInteger tag))destination
                            completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error, NSInteger tag))completionHandler;

+ (NSURLSessionDownloadTask *)downloadRequest:(NSString *)URLString
                                          tag:(NSInteger)tag
                                    noNetwork:(nullable RequestNoNetworkBlock)noNetwork
                                        start:(nullable RequestStartBlock)start
                                     progress:(nullable void (^)(NSProgress *downloadProgress, NSInteger tag))downloadProgressBlock
                                  destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response, NSInteger tag))destination
                            completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error, NSInteger tag))completionHandler;
*/

@end

NS_ASSUME_NONNULL_END
