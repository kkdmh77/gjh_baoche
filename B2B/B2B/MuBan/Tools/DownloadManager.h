//
//  DownLoadManager.h
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"

typedef void (^DownloadStartBlock)      (AFDownloadRequestOperation *operation);
typedef void (^DownloadProgressBlock)   (AFDownloadRequestOperation *operation, CGFloat progress); // progress: 0 ~ 1
typedef void (^DownloadPauseBlock)      (AFDownloadRequestOperation *operation);
typedef void (^DownloadCompletionBlock) (AFDownloadRequestOperation *operation, NSError *error);

@interface DownloadManager : NSObject

AS_SINGLETON(DownloadManager);

@property (nonatomic, strong, readonly) NSOperationQueue *dbZipOperationQueue; // zip包的下载队列

- (AFDownloadRequestOperation *)dbZipDownloadingOperationWithUrlStr:(NSString *)urlString; // 正在下载或者暂停中的任务

/// 数据库zip包的下载(如果是WIFI环境开始的下载-从WIFI切换到移动数据后会自动暂停)
- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString
                                               completion:(DownloadCompletionBlock)completion;

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString
                                                 progress:(DownloadProgressBlock)progress
                                               completion:(DownloadCompletionBlock)completion;

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString
                                                  isPatch:(BOOL)isPatch
                                                 progress:(DownloadProgressBlock)progress
                                                    pause:(DownloadPauseBlock)pause
                                               completion:(DownloadCompletionBlock)completion;

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString
                                                  isPatch:(BOOL)isPatch
                                                    start:(DownloadStartBlock)start
                                                 progress:(DownloadProgressBlock)progress
                                                    pause:(DownloadPauseBlock)pause
                                               completion:(DownloadCompletionBlock)completion;

////////////////////////////////////////////////////////////////////////////////

/// 普通非zip包的下载(允许移动数据下载-从WIFI切换到移动数据不自动暂停)
- (AFDownloadRequestOperation *)downloadFileWithUrlStr:(NSString *)urlStr
                                            targetPath:(NSString *)targetPath
                            completionBlockWithSuccess:(void (^) (AFDownloadRequestOperation *operation))success
                                               failure:(void (^) (AFDownloadRequestOperation *operation, NSError *error))failure;

- (AFDownloadRequestOperation *)downloadFileWithUrlStr:(NSString *)urlStr
                                            targetPath:(NSString *)targetPath
                                        blockWithStart:(void (^) (AFDownloadRequestOperation *operation))start
                                              progress:(void (^) (AFDownloadRequestOperation *operation, CGFloat percentDone))progress
                                               success:(void (^) (AFDownloadRequestOperation *operation))success
                                               failure:(void (^) (AFDownloadRequestOperation *operation, NSError *error))failure;

@end
