
//
//  DownLoadManager.m
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "DownLoadManager.h"
#import "FileManager.h"
#import "DataPackageInfoModel.h"
#import "AFNetworking.h"
#import "NSData+bsdiff.h"
#import "GCDThread.h"
#import "HUDManager.h"
#import "NetworkStatusManager.h"
#include <objc/runtime.h>

static const void * const kCompletionBlockKey = &kCompletionBlockKey;
static const void * const kPauseBlockKey = &kPauseBlockKey;
static const void * const kProgressBlockKey = &kProgressBlockKey;
static const void * const kStartBlockKey = &kStartBlockKey;

@interface DownloadManager ()

@property (nonatomic, strong) NSOperationQueue *dbZipOperationQueue; // zip包的下载队列
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *failDownloadContainer; // 下载失败的的任务 key:url, value:isPatch

@property (nonatomic, strong) NSOperationQueue *operationQueue; // 普通包的下载队列

@end

@implementation DownloadManager

DEF_SINGLETON(DownloadManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbZipOperationQueue = [[NSOperationQueue alloc] init];
        self.failDownloadContainer = [NSMutableDictionary dictionary];
        // _downloadOperationQueue.maxConcurrentOperationCount = 1;
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(netWorkChange:)
                                                     name:kNetworkReachabilityDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNetworkReachabilityDidChangeNotification
                                                  object:nil];
}

/****************************普通数据包下载********************************/

- (AFDownloadRequestOperation *)downloadFileWithUrlStr:(NSString *)urlStr targetPath:(NSString *)targetPath completionBlockWithSuccess:(void (^)(AFDownloadRequestOperation *))success failure:(void (^)(AFDownloadRequestOperation *, NSError *))failure
{
    return [self downloadFileWithUrlStr:urlStr
                             targetPath:targetPath
                         blockWithStart:nil
                               progress:nil
                                success:success
                                failure:failure];
}

- (AFDownloadRequestOperation *)downloadFileWithUrlStr:(NSString *)urlStr targetPath:(NSString *)targetPath blockWithStart:(void (^)(AFDownloadRequestOperation *))start progress:(void (^)(AFDownloadRequestOperation *, CGFloat))progress success:(void (^)(AFDownloadRequestOperation *))success failure:(void (^)(AFDownloadRequestOperation *, NSError *))failure
{
    AFDownloadRequestOperation *downloadOperation = nil;
    NSArray *operations = [_operationQueue.operations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.request.URL.absoluteString = %@", urlStr]];
    if ([operations isValidArray]) {
        downloadOperation = operations[0];
    }
    
    // 没有正在下载的任务
    if (!downloadOperation) {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                     URLString:urlStr
                                                                                    parameters:nil
                                                                                         error:NULL];
        
        downloadOperation = [[AFDownloadRequestOperation alloc] initWithRequest:request
                                                                     targetPath:targetPath
                                                                   shouldResume:YES];
        downloadOperation.shouldOverwrite = YES;
        
        // 成功 & 失败的block
        [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            AFDownloadRequestOperation *operation1 = (AFDownloadRequestOperation *)operation;
            [operation1 deleteTempFileWithError:NULL];
            
            // SHA1校验
            /*
            NSDictionary *headerDic = operation.response.allHeaderFields;
            NSString *toCheckSha1Str = [[headerDic safeObjectForKey:@"Etag"] lowercaseString];
            toCheckSha1Str = [toCheckSha1Str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *sha1Str = [[[NSData dataWithContentsOfFile:targetPath] SHA1Sum] lowercaseString];
             */
            
            if (success) {
                success(operation1);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            AFDownloadRequestOperation *operation2 = (AFDownloadRequestOperation *)operation;
            
            if (failure) {
                failure(operation2, error);
            }
        }];
        
        // 下载进度block
        [downloadOperation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            CGFloat percentDone = totalBytesReadForFile / (CGFloat)totalBytesExpectedToReadForFile;
            
            if (progress) {
                progress(operation, percentDone);
            }
        }];
        
        [_operationQueue addOperation:downloadOperation];
        
        if (start) {
            start(downloadOperation);
        }
    } else {
        // 正在下载
        if (downloadOperation.isExecuting && failure) {
            NSError *error = [self makeErrorWithDescription:@"数据包正在下载..."
                                                       code:1505
                                                     domain:nil];
            
            failure(downloadOperation, error);
        } else if (downloadOperation.isPaused) {
            [downloadOperation resume];
        }
    }
    
    return downloadOperation;
}

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

- (AFDownloadRequestOperation *)dbZipDownloadingOperationWithUrlStr:(NSString *)urlString
{
    AFDownloadRequestOperation *operation = nil;
    NSArray *operations = [_dbZipOperationQueue.operations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.request.URL.absoluteString = %@", urlString]];
    
    if ([operations isValidArray]) {
        operation = operations[0];
    }
    
    return operation;
}

/****************************压缩功能包下载********************************/

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString completion:(DownloadCompletionBlock)completion
{
    return [self downloadFileWithURLString:urlString
                                  progress:nil
                                completion:completion];
}

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString progress:(DownloadProgressBlock)progress completion:(DownloadCompletionBlock)completion
{
    return [self downloadFileWithURLString:urlString
                                   isPatch:NO
                                  progress:progress
                                     pause:nil
                                completion:completion];
}

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString isPatch:(BOOL)isPatch progress:(DownloadProgressBlock)progress pause:(DownloadPauseBlock)pause completion:(DownloadCompletionBlock)completion
{
    return  [self downloadFileWithURLString:urlString
                                    isPatch:isPatch
                                      start:nil
                                   progress:progress
                                      pause:pause
                                 completion:completion];
}

- (AFDownloadRequestOperation *)downloadFileWithURLString:(NSString *)urlString isPatch:(BOOL)isPatch start:(DownloadStartBlock)start progress:(DownloadProgressBlock)progress pause:(DownloadPauseBlock)pause completion:(DownloadCompletionBlock)completion
{
    AFDownloadRequestOperation *currentOperation = [self dbZipDownloadingOperationWithUrlStr:urlString];
    
    if (!currentOperation) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:60];
        
        NSString *targetPath = [FileManager getFileDownladTargetPathWithDownloadUrl:urlString];
        currentOperation = [[AFDownloadRequestOperation alloc] initWithRequest:request
                                                                    targetPath:targetPath
                                                                  shouldResume:YES];
        currentOperation.shouldOverwrite = YES;
        [currentOperation addObserver:[DownloadManager sharedInstance]
                           forKeyPath:@"state"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:NULL];
        if (pause) {
            objc_setAssociatedObject(currentOperation, kPauseBlockKey, pause, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        if (completion) {
            objc_setAssociatedObject(currentOperation, kCompletionBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        if (progress) {
            objc_setAssociatedObject(currentOperation, kProgressBlockKey, progress, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        if (start) {
            objc_setAssociatedObject(currentOperation, kStartBlockKey, start, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        DBFileType fileType = [[FileManager sharedInstance] getFileTypeByUrl:urlString];
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(fileType)];

        // 成功&失败的block
        WEAKSELF
        [currentOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            AFDownloadRequestOperation *operation1 = (AFDownloadRequestOperation *)operation;
            [operation1 removeObserver:weakSelf forKeyPath:@"state" context:NULL];
            [operation1 deleteTempFileWithError:nil];

            model.isDownloading = NO;
            model.percentDone = 0;
            
            [weakSelf.failDownloadContainer removeObjectForKey:urlString];
            
            // MD5校验
            NSString *md5String = [[[NSData dataWithContentsOfFile:targetPath] MD5Sum] lowercaseString];
            NSString *toCheckMD5Str = nil;
            // 下载的是增量包
            if (isPatch && [model.patchMd5 isAbsoluteValid]) {
                toCheckMD5Str = [model.patchMd5 lowercaseString];
                // 校验增量包的MD5和解压增量包
                if ([md5String isEqualToString:toCheckMD5Str] && [FileManager unPackageFileWithPath:targetPath toPath:[FileManager getTempPath] fileType:fileType])
                {
                    // 合并
                    NSString *oldDBFilePath = [FileManager getFilePathByFileType:fileType];
                    NSString *patchFilePath = [NSString stringWithFormat:@"%@.patch", [targetPath stringByDeletingPathExtension]];
                    
                    NSString *mergePaht = [NSString stringWithFormat:@"%@/%@", [FileManager getTempPath], [oldDBFilePath lastPathComponent]];
                    
                    [GCDThread enqueueBackground:^{
                        // 合并成功
                        // 发送通知。hasNewVersion = no；合并失败的tag清空,删除旧的包，把新的包移过去
                        // NSData *mergeData = [NSData dataWithData:[NSData dataWithContentsOfFile:oldDBFilePath] andPatch:[NSData dataWithContentsOfFile:patchFilePath]];
                        BOOL flag = [NSData mergeDataWithOldFilePath:oldDBFilePath newFilePath:mergePaht patchPath:patchFilePath];
                        
                        if (flag && [[[[NSData dataWithContentsOfFile:mergePaht] MD5Sum] lowercaseString] isEqualToString:[model.sourceMd5 lowercaseString]] /*&& [mergeData writeToFile:mergePaht atomically:YES]*/)
                        {
                            DeleteFiles(patchFilePath);
                            
                            // 删除旧版本包&移动合并的新版本包到旧版本包的位置
                            if (DeleteFiles(oldDBFilePath) && [[NSFileManager defaultManager] moveItemAtPath:mergePaht toPath:oldDBFilePath error:NULL])
                            {
                                [GCDThread enqueueForeground:^{
                                    model.hasNewVersion = NO;
                                    model.dbMergeFailedVersionColde = nil;
                                    
                                    if (completion) {
                                        completion(operation1, nil);
                                    }
                                    
                                    // 下载完且解压成功后做功能包下载完成的提示
                                    [HUDManager showAutoHideHUDWithToShowStr:@"离线包已下载完成！" // DOWNLOAD_SUCCESS_MSG(type)
                                                                     HUDMode:MBProgressHUDModeText];
                                }];
                            }
                            // 移动包失败
                            else
                            {
                                [weakSelf patchDownloadFailedWithOperation:operation1
                                                          packageInfoModel:model];
                            }
                        }
                        // 合并增量包失败
                        else
                        {
                            [weakSelf patchDownloadFailedWithOperation:operation1
                                                      packageInfoModel:model];
                        }
                    }];
                }
                // 合并失败（校验patch的MD5或者解压增量包失败）
                // 发送失败通知，给这个版本的数据库打上合并失败的tag
                else
                {
                    [weakSelf patchDownloadFailedWithOperation:operation1
                                              packageInfoModel:model];
                }
            } else {
                toCheckMD5Str = [model.md5 lowercaseString];
                
                // 解压
                if ([md5String isEqualToString:toCheckMD5Str] && [FileManager unPackageFileWithToUnPackageFilePath:targetPath fileType:fileType]) {
                    [GCDThread enqueueForeground:^{
                        model.hasNewVersion = NO;
                        model.dbMergeFailedVersionColde = nil;
                        
                        if (completion) {
                            completion(operation1, nil);
                        }
                        
                        // 下载完且解压成功后做功能包下载完成的提示
                        [HUDManager showAutoHideHUDWithToShowStr:@"离线包已下载完成！" // DOWNLOAD_SUCCESS_MSG(type)
                                                         HUDMode:MBProgressHUDModeText];
                    }];
                } else {
                    [GCDThread enqueueForeground:^{
                        if (completion) {
                            NSError *error = [weakSelf makeErrorWithDescription:@"数据库MD5校验失败或者zip解压失败!"
                                                                           code:1504
                                                                         domain:nil];
                            
                            completion(operation1, error);
                        }
                    }];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            AFDownloadRequestOperation *operation2 = (AFDownloadRequestOperation *)operation;
            [operation2 removeObserver:weakSelf forKeyPath:@"state" context:NULL];
            
            model.isDownloading = NO;
            
            [weakSelf.failDownloadContainer setObject:@(isPatch) forKey:urlString];
            
            [GCDThread enqueueForeground:^{
                if (completion) {
                    completion(operation2, error);
                }
            }];
        }];
        
        // 下载进度block
        [currentOperation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            
            float percentDone = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
            
            model.isDownloading = YES;
            model.percentDone = percentDone;
            
            [GCDThread enqueueForeground:^{
                if (progress) {
                    progress(operation, percentDone);
                }
            }];
        }];
        
        // [operation start];
        currentOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
        [_dbZipOperationQueue addOperation:currentOperation];
        
        model.isDownloading = YES;
        
        [GCDThread enqueueForeground:^{
            if (start) {
                start(currentOperation);
            }
        }];
    } else {
        // 正在下载
        if (currentOperation.isExecuting && completion) {
            NSError *error = [self makeErrorWithDescription:@"数据包正在下载..."
                                                       code:1505
                                                     domain:nil];
            
            completion(currentOperation, error);
        } else if (currentOperation.isPaused) {
            [currentOperation resume];
        }
    }
    
    return currentOperation;
}

- (NSError *)makeErrorWithDescription:(NSString *)description code:(NSInteger)code domain:(NSString *)domain
{
    NSError *error = [NSError errorWithDomain:[domain isValidString] ? domain : @"DOWNLOAD_ERROR_DOMAIN"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey: [description isValidString] ? description : @"数据库下载失败!"}];
    return error;
}

// 增量升级失败
- (void)patchDownloadFailedWithOperation:(AFDownloadRequestOperation *)operation packageInfoModel:(DataPackageInfoModel *)model
{
    // 合并失败
    // 发送失败通知，给这个版本的数据库打上合并失败的tag
    [GCDThread enqueueForeground:^{
        model.hasNewVersion = YES;
        model.dbMergeFailedVersionColde = model.versionCode;
        model.isUpPackageing = NO;
        
        DownloadCompletionBlock completion = objc_getAssociatedObject(operation, kCompletionBlockKey);
        if (completion) {
            NSError *error = [self makeErrorWithDescription:@"数据库增量升级失败！"
                                                       code:1503
                                                     domain:nil];
            
            completion(operation, error);
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[AFDownloadRequestOperation class]]) {
        DownloadPauseBlock pause = objc_getAssociatedObject(object, kPauseBlockKey);
        
        if (pause && [keyPath isEqualToString:@"state"] && -1 == [[change safeObjectForKey:@"new"] integerValue]) {
            pause((AFDownloadRequestOperation *)object);
        }
    }
}

- (void)netWorkChange:(NSNotification *)notification
{
    NetworkStatus status = [NetworkStatusManager getNetworkStatus];
    switch (status) {
        case ReachableViaWiFi:
        {
            for (NSString *key in [_failDownloadContainer allKeys]) {
                BOOL isPatch = [[_failDownloadContainer objectForKey:key] boolValue];
                
                [self downloadFileWithURLString:key
                                        isPatch:isPatch
                                       progress:nil
                                          pause:nil
                                     completion:nil];
            }
            
            // 切换到WIFI后开始所有暂停的下载任务
            for (AFHTTPRequestOperation *operation in _dbZipOperationQueue.operations)
            {
                [operation resume];
            }
        }
            break;
        case ReachableViaWWAN:
        {
            // 切换到3G后停止所有正在进行的下载任务
            [self pauseAllDownloadTask];
        }
            break;
        case NotReachable:
        {
            // 没有网络后停止所有正在进行的下载任务
            [self pauseAllDownloadTask];
        }
            break;
        
        default:
            break;
    }
}

- (void)pauseAllDownloadTask
{
    for (AFHTTPRequestOperation *operation in _dbZipOperationQueue.operations)
    {
        [operation pause];
    }
}

@end
