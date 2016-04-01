
//
//  DownLoadManager.m
//  KKDictionary
//
//  Created by KungJack on 12/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "DownLoadManager.h"
#import "FileManager.h"
#import "DataPackageInfoModel.h"
#import "AFNetworking.h"
#import "NSData+bsdiff.h"
#import "DBManager.h"
#import "GCDThread.h"
#import "HUDManager.h"
#import "NetworkStatusManager.h"

@interface DownLoadManager () {
    
    NSMutableDictionary *currentDownLoad;
    NSMutableDictionary *failUrl;
}

@property (nonatomic, strong) NSMutableDictionary *failUrl;
@property (nonatomic, strong) NSMutableDictionary *downloadTypeDic; // 是全包下载还是增量包下载

@end

@implementation DownLoadManager

@synthesize currentDownLoad;
@synthesize failUrl;

DEF_SINGLETON(DownLoadManager);

- (id)init {
    self = [super init];
    if (self) {
        self.currentDownLoad = [NSMutableDictionary dictionary];
        self.failUrl = [NSMutableDictionary dictionary];
        self.downloadTypeDic = [NSMutableDictionary dictionary];
        
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

- (void)startDownLoadFileWithURLString:(NSString *)urlString
{
    [self startDownLoadFileWithURLString:urlString isNext:NO];
}

- (void)startDownLoadFileWithURLString:(NSString *)urlString isNext:(BOOL)isNext
{
    [self startDownLoadFileWithURLString:urlString isNext:isNext isPatch:NO];
}

- (void)startDownLoadFileWithURLString:(NSString *)urlString isNext:(BOOL)isNext isPatch:(BOOL)isPatch
{
    AFDownloadRequestOperation *currentOperation = [self.currentDownLoad objectForKey:urlString];
    // AFHTTPRequestOperation *currentOperation = [self.currentDownLoad objectForKey:urlString];
    
    if (!currentOperation) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:3600];
        /*
         AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
         [requestSerializer willChangeValueForKey:@"timeoutInterval"];
         requestSerializer.timeoutInterval = 60.f;
         [requestSerializer didChangeValueForKey:@"timeoutInterval"];
         NSURLRequest *request = [requestSerializer requestWithMethod:@"GET"
         URLString:urlString
         parameters:nil
         error:NULL];
         */
        
        NSString *fileName = [urlString lastPathComponent];
        NSString *targetPath = [[FileManager getTempPath] stringByAppendingPathComponent:fileName];
        if (IsFileExists(targetPath))
        {
            DeleteFiles(targetPath);
        }
        
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request
                                                                                         targetPath:targetPath
                                                                                       shouldResume:YES];
        
        /*
         AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         operation.outputStream = [NSOutputStream outputStreamToFileAtPath:targetPath append:NO];
         */
        
        [self.currentDownLoad setValue:operation forKey:urlString];
        
        DBFileType fileType = [[FileManager sharedInstance] getFileIdByUrl:urlString];
        __weak AFDownloadRequestOperation *_operation = operation;
        
        // 成功&失败的block
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
            
            DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(fileType)];
            model.isDownLoading = NO;
            
            [self.currentDownLoad removeObjectForKey:urlString];
            [failUrl removeObjectForKey:urlString];
            [_downloadTypeDic removeObjectForKey:urlString];
            
            if (isNext) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_SUCCESS_HAVE_NEXT
                                                                    object:@{@"fileType": @(fileType)}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_SUCCESS
                                                                    object:@{@"fileType":@(fileType)}];
            }
            
            [_operation deleteTempFileWithError:nil];
            
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
                                    model.isUpPackageing = NO;
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:UN_PARKAGE_FILE_SUCCESS
                                                                                        object:@{@"fileType": @(fileType)}];
                                    
                                    // 下载完且解压成功后做功能包下载完成的提示
                                    [HUDManager showAutoHideHUDWithToShowStr:[DOWNLOAD_SUCCESS_MSGS objectAtIndex:fileType]
                                                                     HUDMode:MBProgressHUDModeText];
                                }];
                            }
                            // 移动包失败
                            else
                            {
                                [self postUnPackageFailedNotificationWithPackageInfoModel:model
                                                                              fileType:fileType];
                            }
                        }
                        // 合并增量包失败
                        else
                        {
                            [self postUnPackageFailedNotificationWithPackageInfoModel:model
                                                                          fileType:fileType];
                        }
                    }];
                }
                // 合并失败（校验patch的MD5或者解压增量包失败）
                // 发送失败通知，给这个版本的数据库打上合并失败的tag
                else
                {
                    [self postUnPackageFailedNotificationWithPackageInfoModel:model
                                                                  fileType:fileType];
                }
            } else {
                toCheckMD5Str = [model.md5 lowercaseString];
                
                if ([md5String isEqualToString:toCheckMD5Str])
                {
                    // 解压
                    [FileManager unPackageFileWithToUnPackageFilePath:targetPath fileType:fileType];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation2, NSError *error) {
            DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(fileType)];
            model.isDownLoading = NO;
            
            [self.currentDownLoad removeObjectForKey:urlString];
            [failUrl setValue:[NSNumber numberWithBool:isNext] forKey:urlString];
            [_downloadTypeDic setObject:@(isPatch) forKey:urlString];
            
            if (isNext) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_ERROR_HAVE_NEXT
                                                                    object:@{@"fileType": @(fileType)}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_ERROR
                                                                    object:@{@"fileType": @(fileType)}];
            }
        }];
        
        float timePercent = [FileManager getUnpackageTimePercent:fileType];
        
        // 下载进度block
        [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            
            float percentDone = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile * timePercent;
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:percentDone], @"percentDone",
                                        [NSNumber numberWithLongLong:totalBytesRead], @"totalBytesRead",
                                        [NSNumber numberWithLongLong:totalBytesRead], @"totalBytesExpected",
                                        [NSNumber numberWithLongLong:totalBytesRead], @"totalBytesReadForFile",
                                        [NSNumber numberWithLongLong:totalBytesRead], @"totalBytesExpectedToReadForFile",
                                        @(fileType), @"fileType",
                                        nil];
            DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(fileType)];
            model.isDownLoading = YES;
            model.percentDone = percentDone;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_FILEING
                                                                object:dictionary];
        }];
        
        [operation start];
        
    } else {
        if (currentOperation.isPaused) {
            [currentOperation resume];
        }
    }
}

- (void)postUnPackageFailedNotificationWithPackageInfoModel:(DataPackageInfoModel *)model fileType:(DBFileType)type
{
    // 合并失败
    // 发送失败通知，给这个版本的数据库打上合并失败的tag
    [GCDThread enqueueForeground:^{
        model.hasNewVersion = YES;
        model.dbMergeFailedVersionColde = model.versionCode;
        model.isUpPackageing = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UN_PARKAGE_FILE_ERROR
                                                            object:@{@"fileType": @(type)}];
    }];
}

- (void)netWorkChange:(NSNotification *)notification
{
    NetworkStatus status = [NetworkStatusManager getNetworkStatus];
    switch (status) {
        case kReachableViaWiFi:
        {
            for (NSString *key in [failUrl allKeys]) {
                [self startDownLoadFileWithURLString:key
                                              isNext:[[failUrl objectForKey:key] boolValue]
                                             isPatch:[_downloadTypeDic[key] boolValue]];
            }
            
            // 切换到WIFI后开始所有暂停的下载任务
            for (AFHTTPRequestOperation *operation in self.currentDownLoad.allValues)
            {
                [operation resume];
            }
        }
            break;
        case kReachableViaWWAN:
        {
            // 切换到3G后停止所有正在进行的下载任务
            [self pauseAllDownloadTask];
        }
            break;
        case kNotReachable:
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
    for (AFHTTPRequestOperation *operation in self.currentDownLoad.allValues)
    {
        [operation pause];
        
        DBFileType fileType = [[FileManager sharedInstance] getFileIdByUrl:operation.request.URL.absoluteString];
        [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_PAUSE
                                                            object:@{@"fileType": @(fileType)}];
    }
}

@end
