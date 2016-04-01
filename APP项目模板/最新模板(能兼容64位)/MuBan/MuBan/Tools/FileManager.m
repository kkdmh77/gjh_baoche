//
//  FileManager.m
//  KKDictionary
//
//  Created by KungJack on 11/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "FileManager.h"
#import "DownLoadManager.h"
#import "NetworkStatusManager.h"
#import "AFNetWorkUtil.h"
#import "DBManager.h"
#include <sys/xattr.h>
#import "DataPackageInfoModel.h"
#import "NIDeviceInfo.h"
#import "HUDManager.h"

#define DOCUMENTS_PATH GetDocumentPath()

@implementation FileManager

DEF_SINGLETON(FileManager);

/*
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey
                                   error: &error];
    if(!success){
        
    }
    return success;
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDownLoadNext:)
                                                     name:DOWN_LOAD_SUCCESS_HAVE_NEXT
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDownLoadNext:)
                                                     name:DOWN_LOAD_ERROR_HAVE_NEXT
                                                   object:nil];
        
        self.dataPackageInfoDic = [[self class] getDataPackageInfoModels];
    }
    return self;
}

+ (void)creatCacheFolder
{
    NSString *voicePath = [FileManager getVoicePath];
    NSString *DBPath = [FileManager getDBPath];
    NSString *videoPath = [FileManager getMoviePath];
    NSString *tempPath = [FileManager getTempPath];
    NSString *fontPath = [FileManager getFontPath];
    
    if (!IsFileExists(voicePath)) {
        CreateFolder(voicePath);
    }
    if (!IsFileExists(DBPath)) {
        CreateFolder(DBPath);
    }
    if (!IsFileExists(videoPath)) {
        CreateFolder(voicePath);
    }
    if (!IsFileExists(tempPath)) {
        CreateFolder(tempPath);
    }
    if (!IsFileExists(fontPath)) {
        CreateFolder(fontPath);
    }
    
    /*
    NSURL *dbURLPath = [NSURL fileURLWithPath:DBPath];
    [self addSkipBackupAttributeToItemAtURL:dbURLPath];
    
    NSURL *voiceURLPath = [NSURL fileURLWithPath:voicePath];
    [self addSkipBackupAttributeToItemAtURL:voiceURLPath];
    
    NSURL *videoURLPath = [NSURL fileURLWithPath:videoPath];
    [self addSkipBackupAttributeToItemAtURL:videoURLPath];
    
    NSURL *tempURLPath = [NSURL fileURLWithPath:tempPath];
    [self addSkipBackupAttributeToItemAtURL:tempURLPath];
     */
}

+ (NSString *)getFilePathByFileType:(DBFileType)type
{
    if (0 <= type && type < FILE_CONFIG_ARRAY.count)
    {
        NSString *fileName = [FILE_CONFIG_ARRAY[type] objectAtIndex:0];
        
        if (type == TYPEFACE_INDEX)
        {
            return [DOCUMENTS_PATH stringByAppendingPathComponent:fileName];
        }
        else
        {
            return [[self getDBPath] stringByAppendingPathComponent:fileName];
        }
    }
    return nil;
}

+ (NSString *)getVoicePath {
    return [DOCUMENTS_PATH stringByAppendingPathComponent:VOICE_FOLDER_NAME];
}

+ (NSString *)getDBPath {
    return [DOCUMENTS_PATH stringByAppendingPathComponent:DB_FOLDER_NAME];
}

+ (NSString *)getMoviePath {
    return [DOCUMENTS_PATH stringByAppendingPathComponent:VIDEO_FOLDER_NAME];
}

+ (NSString *)getTempPath {
    return [DOCUMENTS_PATH stringByAppendingPathComponent:TEMP_FOLDER_NAME];
}

+ (NSString *)getFontPath
{
    return [DOCUMENTS_PATH stringByAppendingPathComponent:FONT_FOLDER_NAME];
}

////////////////////////////////////////////////////////////////////////////////

+ (BOOL)dbFileIsExsitWithDBFileType:(DBFileType)type
{
    NSString *path = [self getFilePathByFileType:type];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (FileExsitType)dbFileExsitTypeWithDBFileType:(DBFileType)type
{
    BOOL flag = [self dbFileIsExsitWithDBFileType:type];
    if (flag)
    {
        NSInteger version = [self getDBVersionCode:type];
        NSInteger miniSupport = [[FILE_CONFIG_ARRAY[type] objectAtIndex:3] integerValue];
        if (version < miniSupport)
        {
            return NeedUpDate;
        }
        
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
        if (version < [model.versionCode integerValue])
        {
            return HasNewVersion;
        }
        return Exsit;
    }
    return Empty;
}

+ (BOOL)isAbsoluteValidDBFile:(DBFileType)type
{
    BOOL flag = [self dbFileIsExsitWithDBFileType:type];
    if (flag)
    {
        FileExsitType exsitType = [self dbFileExsitTypeWithDBFileType:type];
        
        if (Exsit == exsitType || HasNewVersion == exsitType)
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

////////////////////////////////////////////////////////////////////////////////

+ (NSInteger)getNotExsitFileNum
{
    NSInteger num = 0;
    for (int i = 0; i < [FILE_CONFIG_ARRAY count]; i++) {
        NSString *path = [self getFilePathByFileType:i];
        BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (!flag) {
            num++;
        } else {
            DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(i)];
            if (model.hasNewVersion) {
                num++;
            }
        }
    }
    return num;
}

+ (float)getUnpackageTimePercent:(DBFileType)type
{
    if (type == 0 || type == 2 || type == 3) {
        return 0.95;
    }
    if (type == 1) {
        return 0.9;
    }
    if (type == 4) {
        return 0.8;
    }
    return 0.95;
}

/*
+(BOOL)unParkageFileWithPath:(NSString *)path toPath:(NSString*)toPath{
    
    NSDate *date1 = [NSDate date];
    ZipArchive *zipArchive = [[ZipArchive alloc]init];
    BOOL openFileFlag = [zipArchive UnzipOpenFile:path];
    if(openFileFlag){
        BOOL unZipFlag = [zipArchive UnzipFileTo:toPath overWrite:YES];
        if(unZipFlag){
            DEBUG_LOG(@"解压成功!!!!");
            [zipArchive UnzipCloseFile];
            if([[NSFileManager defaultManager]fileExistsAtPath:path]){
                [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
                return YES;
            }
        }else{
            DEBUG_LOG(@"解压失败!!!!");
        }
    }else{
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    }
    NSDate *date2 = [NSDate date];
    DEBUG_LOG(@"%f",([date2 timeIntervalSince1970]-[date1 timeIntervalSince1970]));
    return NO;
    
}
 */

+ (BOOL)unPackageFileWithPath:(NSString *)path toPath:(NSString *)toPath fileType:(DBFileType)type
{
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    BOOL openFileFlag = [zipArchive UnzipOpenFile:path];
    
    if (openFileFlag) {
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
        model.isUpPackageing = YES;
        
        zipArchive.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles) {
            float timePercent = [FileManager getUnpackageTimePercent:type];
            float percentDone = percentage * (1.0 - timePercent) * 0.01 + timePercent;
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:percentDone], @"percentDone",
                                        @(type), @"fileType",
                                        nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LOAD_FILEING
                                                                    object:dictionary];
            });
        };
        
        BOOL unZipFlag = [zipArchive UnzipFileTo:toPath overWrite:YES];
        if (unZipFlag) {
            [zipArchive UnzipCloseFile];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                
                return YES;
            }
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    return NO;
}

+ (void)unPackageFileWithToUnPackageFilePath:(NSString *)path fileType:(DBFileType)type
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL flag = NO;
        NSString *fileDownloadPath = path;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileDownloadPath]) {
            NSString *toPath = @"";
            
            if (TYPEFACE_INDEX == type) {
                toPath  = [FileManager getFontPath];
            } else {
                toPath = [FileManager getDBPath];
            }
        
            flag = [FileManager unPackageFileWithPath:fileDownloadPath toPath:toPath fileType:type];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag) {
                    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
                    model.hasNewVersion = NO;
                    model.dbMergeFailedVersionColde = nil;
                    model.isUpPackageing = NO;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UN_PARKAGE_FILE_SUCCESS
                                                                        object:@{@"fileType": @(type)}];
                    
                    // 下载完且解压成功后做功能包下载完成的提示
                    [HUDManager showAutoHideHUDWithToShowStr:[DOWNLOAD_SUCCESS_MSGS objectAtIndex:type]
                                                     HUDMode:MBProgressHUDModeText];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UN_PARKAGE_FILE_ERROR
                                                                        object:@{@"fileType": @(type)}];
                }
            });
        }
    });
}

+ (NSMutableDictionary *)getDataPackageInfoModels
{
    NSString *path = [DOCUMENTS_PATH stringByAppendingPathComponent:@"dataPackageInfoModels.plist"];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];

    if (IsFileExists(path)) {
        NSMutableDictionary *tempModelsDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        for (NSInteger i = 0; i < FILE_CONFIG_ARRAY.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%ld", i];
            NSDictionary *modelDic = [tempModelsDic safeObjectForKey:key];
            
            DataPackageInfoModel *model = nil;
            if (modelDic) {
                model = [[DataPackageInfoModel alloc] initWithDictionary:modelDic];
                model.isManualTapDownload = NO;
                model.isDownLoading = NO;
                model.hasNewVersion = NO;
                model.isAutoDownLoading = NO;
                model.isUpPackageing = NO;
            } else {
                model = [[DataPackageInfoModel alloc] init];
            }
            
            [resultDic setObject:model forKey:key];
        }
        return resultDic;
    } else {
        for (NSInteger i = 0; i < FILE_CONFIG_ARRAY.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%ld", i];
            DataPackageInfoModel *model = [[DataPackageInfoModel alloc] init];
            
            [resultDic setObject:model forKey:key];
        }
        return resultDic;
    }
}

- (void)saveDataPackageInfoModels
{
    NSString *path = [DOCUMENTS_PATH stringByAppendingPathComponent:@"dataPackageInfoModels.plist"];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < [[_dataPackageInfoDic allKeys] count]; i++) {
        NSString *key = [[_dataPackageInfoDic allKeys] objectAtIndex:i];
        DataPackageInfoModel *model = [_dataPackageInfoDic objectForKey:key];
        NSMutableDictionary *modelDic = [model toDictionary];
        
        [result setObject:modelDic forKey:key];
    }
    if (IsFileExists(path)) {
        DeleteFiles(path);
    }
    
    [result writeToFile:path atomically:YES];
}

/*
- (void)removeFileWithPath:(NSString *)path {
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL flag = [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:[SUCCESS_STRING stringByAppendingString:path]
                                                                        object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:[FAILED_STRING stringByAppendingString:path]
                                                                        object:nil];
                }
            });
        });
    }
}
*/

// 检查自动下载
-(void)checkFileUpdateWithAutoDownload:(BOOL)autoDownload;
{
    [self dbFileUpdateAndNextWithDBFileType:XIANG_JIE_INDEX autoDownload:autoDownload];
}

#pragma mark - 下载相关的方法

// ************************************************************************

- (void)dbFileUpdateWithDBFileType:(DBFileType)type autoDownload:(BOOL)flag
{
    [self updateDBByID:type autoDownload:flag];
}

#pragma mark - 自动下载相关的方法

// ************************************************************************

- (void)dbFileUpdateAndNextWithDBFileType:(DBFileType)type autoDownload:(BOOL)flag
{
    DBFileType lastType = TYPEFACE_INDEX;
    
    if (type <= lastType && type >= 0)
    {
        if (type < lastType)
        {
            [self updateDBByID:type autoDownload:flag nextId:type + 1];
        }
        else if (type == lastType)
        {
            [self dbFileUpdateWithDBFileType:type autoDownload:flag];
        }
    }
}

#pragma mark - 下载基础方法

- (void)updateDBByID:(DBFileType)index autoDownload:(BOOL)flag
{
    [self updateDBByID:index autoDownload:flag nextId:-1];
}

- (void)updateDBByID:(DBFileType)index autoDownload:(BOOL)flag nextId:(DBFileType)nextId
{
    NSString * versionCode = [NSString stringWithFormat:@"%ld", [FileManager getDBVersionCode:index]];
    
    [self updateFileByID:index versionCode:versionCode autoDownload:flag nextId:nextId];
}

- (void)updateFileByID:(DBFileType)index versionCode:(NSString *)versionCode autoDownload:(BOOL)flag nextId:(DBFileType)nextId
{
    NSArray *keys = @[@"app",
                      @"resource",
                      @"versionCode",
                      @"supportVersion",/*@"channel",*/
                      @"mid",
                      @"privateKey"];
    NSArray *values = @[@"kkdict",
                        [FILE_CONFIG_ARRAY[index] objectAtIndex:1],
                        versionCode,
                        [FILE_CONFIG_ARRAY[index] objectAtIndex:2],/*kChannelID,*/
                        @"",
                        kPrivateKey];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    NSString *token = [[values componentsJoinedByString:@""] MD5Sum];
    [parameters setValue:token forKey:@"token"];
    // NSLog(@"\n%@\n",[parameters description]);
    
    [self updateNetWorkWithParameters:parameters fileType:index autoDownload:flag nextFileType:nextId];
}

- (void)updateNetWorkWithParameters:(NSMutableDictionary *)parameters fileType:(DBFileType)type autoDownload:(BOOL)flag nextFileType:(DBFileType)nextFileType
{
    [AFNetWorkUtil DDTPOST:kDBInfoYYUrlString tag:0 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger netWorkTag) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = responseObject;
            // NSLog(@"[responseObject description] %@,%@",[responseObject description],[resultDic objectForKey:@"message"]);
            NSNumber *code = [resultDic objectForKey:@"status"];
            
            if ([[code stringValue] isEqualToString:@"200"]) {
                NSString *key = [NSString stringWithFormat:@"%ld",type];
                DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:key];
                DataPackageInfoModel *tempModel = [[DataPackageInfoModel alloc] initWithDictionary:[resultDic objectForKey:@"data"]];
                
                model.appName = tempModel.appName;
                model.channel = tempModel.channel;
                model.downloadUrl = tempModel.downloadUrl;
                model.hasNewVersion = tempModel.hasNewVersion;
                model.md5 = tempModel.md5;
                model.patchMd5 = tempModel.patchMd5;
                model.patchUrl = tempModel.patchUrl;
                model.sourceMd5 = tempModel.sourceMd5;
                model.resName = tempModel.resName;
                model.size = tempModel.size;
                model.supportVersion = tempModel.supportVersion;
                model.updateContent = tempModel.updateContent;
                model.userVersion = tempModel.userVersion;
                model.versionCode = [NSString stringWithFormat:@"%@", tempModel.versionCode];
                
                long long space = [[UIDevice currentDevice] freeDiskSpaceBytes];
                
                // 计算要合并的包的大小是否小于总内存的1/4
                NSInteger memory = [[UIDevice currentDevice] totalMemoryBytes] / 1000  / 1000;
                NSInteger fileSize = 0;
                NSString *filePath = [[self class] getFilePathByFileType:type];
                NSDictionary *attributesOfFile = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
                if (attributesOfFile) {
                    fileSize = [attributesOfFile[@"NSFileSize"] integerValue] / 1000 / 1000;
                }
                
                if (space > model.size * 2) {
                    if (model.hasNewVersion) {
                        if ([NetworkStatusManager isEnableWIFI]) {
                            if (flag) {
                                model.isDownLoading = YES;
                                BOOL isNext = nextFileType == -1 ? NO : YES;
                                model.isAutoDownLoading = isNext;
                                
                                if ([model.patchUrl isAbsoluteValid] && ![model.dbMergeFailedVersionColde isEqualToString:model.versionCode] && (memory / 4) >= fileSize)
                                {
                                    [[DownLoadManager sharedInstance] startDownLoadFileWithURLString:model.patchUrl isNext:isNext isPatch:YES];
                                }
                                else
                                {
                                    [[DownLoadManager sharedInstance] startDownLoadFileWithURLString:model.downloadUrl isNext:isNext];
                                }
                            } else {
                                [self checkNextFile:nextFileType autoDown:flag];
                            }
                        } else {
                            if ([model.allowCellular isEqualToString:@"1"]) {
                                model.isDownLoading = YES;
                                model.isAutoDownLoading = NO;
                                
                                if ([model.patchUrl isAbsoluteValid] && ![model.dbMergeFailedVersionColde isEqualToString:model.versionCode]  && (memory / 4) >= fileSize)
                                {
                                    [[DownLoadManager sharedInstance] startDownLoadFileWithURLString:model.patchUrl isNext:NO isPatch:YES];
                                }
                                else
                                {
                                    [[DownLoadManager sharedInstance] startDownLoadFileWithURLString:model.downloadUrl];
                                }
                            }
                        }
                    } else {
                        [self checkNextFile:nextFileType autoDown:flag];
                    }
                } else {
                    [HUDManager showAutoHideHUDWithToShowStr:@"手机存储空间已满，请删除一些数据后再尝试下载"
                                                     HUDMode:MBProgressHUDModeText];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)checkNextFile:(NSInteger)nextId autoDown:(BOOL)flag
{
    [self dbFileUpdateAndNextWithDBFileType:nextId autoDownload:flag];
}

- (void)handleDownLoadNext:(NSNotification *)notification
{
    NSDictionary *value = notification.object;
    DBFileType fileType = [[value objectForKey:@"fileType"] integerValue];
   
    [self dbFileUpdateAndNextWithDBFileType:fileType + 1 autoDownload:YES];
}

#pragma mark - 获取资源版本号相关的方法

+ (NSInteger )getDBVersionCode:(DBFileType)fileType {
    
    if (TYPEFACE_INDEX == fileType)
    {
        NSString *versionFilePath = [[self getFontPath] stringByAppendingPathComponent:@"version"];
        NSString *versionStr = [NSString stringWithContentsOfFile:versionFilePath encoding:NSUTF8StringEncoding error:NULL];
        if ([versionStr isAbsoluteValid])
        {
            return [versionStr integerValue];
        }
        return 0;
    }
    else
    {
        DBManager *manager = [DBManager sharedInstance];
        [manager changeToDatabaseWithName:[FILE_CONFIG_ARRAY[fileType] objectAtIndex:0]];
        
        return [manager getDBVersion];
    }
}

- (DBFileType)getFileIdByUrl:(NSString *)urlString
{
    NSArray *allKeys = [[FileManager sharedInstance].dataPackageInfoDic allKeys];
    for (NSString *key in allKeys) {
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:key];
        if ([model.downloadUrl isEqualToString:urlString]) {
            NSInteger index = [key integerValue];
            return index;
        }
        
        if ([model.patchUrl isEqualToString:urlString]) {
            NSInteger index = [key integerValue];
            return index;
        }
    }
    return NSNotFound;
}

- (AFHTTPRequestOperation *)curDownloadOperationByPackageInfoModel:(DataPackageInfoModel *)model
{
    AFHTTPRequestOperation *operation = [[DownLoadManager sharedInstance].currentDownLoad objectForKey:model.downloadUrl];
    if (!operation) {
        operation = [[DownLoadManager sharedInstance].currentDownLoad objectForKey:model.patchUrl];
    }
    return operation;
}

- (void)downloadPackageWithFileTypeAndShowNoticeString:(DBFileType)type
{
    NSString *notice = [NSString stringWithFormat:@"是否要下载“%@”功能包？",[DATA_PACKAGE_CHINESE_NAME objectAtIndex:type]];
    [self downloadPackageWithFileType:type noticeStr:notice];
}

- (void)downloadPackageWithFileType:(DBFileType)type noticeStr:(NSString *)notice
{
    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    model.isAutoDownLoading = NO;
    if (!model.isDownLoading) {
        BOOL flag = [NetworkStatusManager isEnableWIFI];
        if (flag) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:notice
                                                          delegate:self
                                                 cancelButtonTitle:@"否"
                                                 otherButtonTitles:@"是", nil];
            alert.tag = type;
            [alert show];
        } else {
            BOOL flag = [NetworkStatusManager isConnectNetwork];
            if (flag) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"您目前处于非Wi-Fi状态，下载“%@”功能包可能会产生流量费用，是否确认下载？",[DATA_PACKAGE_CHINESE_NAME objectAtIndex:type]]
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是", nil];
                alert.tag = type + 200;
                [alert show];
            } else {
                [HUDManager showAutoHideHUDWithToShowStr:@"您好像没有连接网络，无法下载"
                                                 HUDMode:MBProgressHUDModeText];
            }
        }
    } else {
        AFHTTPRequestOperation *downloadOperation = [self curDownloadOperationByPackageInfoModel:model];
        
        if (downloadOperation && downloadOperation.isPaused) {
            [downloadOperation resume];
            
            [HUDManager showAutoHideHUDWithToShowStr:@"继续下载功能包..."
                                             HUDMode:MBProgressHUDModeText];
        } else {
            [HUDManager showAutoHideHUDWithToShowStr:@"正在下载中，请稍候再使用本功能"
                                             HUDMode:MBProgressHUDModeText];
        }
    }
}

- (void)downloadPackageWithFileType:(DBFileType)type
{
    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    model.isAutoDownLoading = NO;
    if (!model.isDownLoading) {
        BOOL flag = [NetworkStatusManager isEnableWIFI];
        if (flag) {
            [HUDManager showAutoHideHUDWithToShowStr:@"开始下载功能包..."
                                             HUDMode:MBProgressHUDModeText];
            
            [self downLoadingWithTag:type];
        } else {
            BOOL flag = [NetworkStatusManager isConnectNetwork];
            if (flag) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"您目前处于非Wi-Fi状态，下载“%@”功能包可能会产生流量费用，是否确认下载？",[DATA_PACKAGE_CHINESE_NAME objectAtIndex:type]]
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是", nil];
                alert.tag = type + 200;
                [alert show];
            } else {
                [HUDManager showAutoHideHUDWithToShowStr:@"您好像没有连接网络，无法下载"
                                                 HUDMode:MBProgressHUDModeText];
            }
        }
    } else {
        AFHTTPRequestOperation *downloadOperation = [self curDownloadOperationByPackageInfoModel:model];
        
        if (downloadOperation && downloadOperation.isPaused) {
            [downloadOperation resume];
            
            [HUDManager showAutoHideHUDWithToShowStr:@"继续下载功能包..." HUDMode:MBProgressHUDModeText];
        } else {
            [HUDManager showAutoHideHUDWithToShowStr:@"正在下载中，请稍候再使用本功能"
                                             HUDMode:MBProgressHUDModeText];
        }
    }
}


- (void)downLoadingWithTag:(NSInteger)alertIndex
{
    // WIFI环境下载
    if (alertIndex < 200)
    {
        [self dbFileUpdateWithDBFileType:alertIndex autoDownload:YES];
    }
    // 蜂窝数据环境下载
    else
    {
        DBFileType type = alertIndex - 200;
        
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
        model.allowCellular = @"1";
        model.isAutoDownLoading = NO;
        
        [self dbFileUpdateWithDBFileType:type autoDownload:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger alertIndex = alertView.tag;
    
    if (buttonIndex != 0) {
        [self downLoadingWithTag:alertIndex];
    }
}

@end
