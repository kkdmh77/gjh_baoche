//
//  FileManager.m
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "FileManager.h"
#import "NetworkStatusManager.h"
#import "AFNetworkingTool.h"
#include <sys/xattr.h>
#import "DataPackageInfoModel.h"
#import "NIDeviceInfo.h"
#import "HUDManager.h"
#import "PRPAlertView.h"
#import "GCDThread.h"
#import "GYDataCenter.h"

#define kChannelID       @"AppStore"
#define kPrivateKey      @"1e63bd8c12e0b5ef"

#define VOICE_FOLDER_NAME @"Voice"
#define DB_FOLDER_NAME    @"DB"
#define VIDEO_FOLDER_NAME @"Video"
#define TEMP_FOLDER_NAME  @"Tempp"
#define FONT_FOLDER_NAME  @"Font"

#define DOCUMENTS_PATH GetDocumentPath()

extern NSString * const kHasDownloadPictureListModelKey;
extern NSString * const kUserInfoModelPlistFileName;

@implementation FileManager

DEF_SINGLETON(FileManager);

- (instancetype)init {
    self = [super init];
    if (self) {
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
        CreateFolder(videoPath);
    }
    if (!IsFileExists(tempPath)) {
        CreateFolder(tempPath);
    }
    if (!IsFileExists(fontPath)) {
        CreateFolder(fontPath);
    }
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

+ (NSMutableDictionary<NSString *, NSArray *> *)fileConfig
{
    static NSMutableDictionary *configDic = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        configDic = [NSMutableDictionary dictionaryWithDictionary:
                     @{@(ZHUJIE).stringValue:    @[@"poem_zhujie.db",  @"poem_zhujie_ios",  @"2", @"2"],
                       @(YIWEN).stringValue:     @[@"poem_yiwen.db",   @"poem_yiwen_ios",   @"2", @"2"],
                       @(SHANGXI).stringValue:   @[@"poem_shangxi.db", @"poem_shangxi_ios", @"2", @"4"],
                       @(FULL_POEM).stringValue: @[@"poem_full.db",    @"poem_full_ios",    @"1", @"1"]}];
    });
    
    return configDic;
}

// 升序排序
+ (NSArray<NSString *> *)fileConfigKeys
{
    NSArray *keys = [[self fileConfig] allKeys];
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        NSInteger obj1Int = [obj1 integerValue];
        NSInteger obj2Int = [obj2 integerValue];
        
        if (obj1Int > obj2Int) {
            return NSOrderedDescending;
        } else if (obj1Int < obj2Int) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return keys;
}

+ (NSString *)getFileNameByFileType:(DBFileType)type
{
    NSArray *configInfo = [FILE_CONFIG safeObjectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    
    if (configInfo)
    {
        NSString *fileName = [configInfo objectAtIndex:0];
        
        return fileName;
    }
    return nil;
}

+ (NSString *)getFilePathByFileType:(DBFileType)type
{
    NSString *fileName = [self getFileNameByFileType:type];
    
    if ([fileName isAbsoluteValid])
    {
        return [[self getDBPath] stringByAppendingPathComponent:fileName];
    }
    return nil;
}

+ (NSString *)getFileDownladTargetPathWithDownloadUrl:(NSString *)url
{
    NSString *targetPath = nil;
    if ([url isAbsoluteValid])
    {
        NSString *fileName = [url lastPathComponent].stringByDeletingPathExtension;
        fileName = [fileName stringByAppendingPathExtension:@"zip"];
        targetPath = [[FileManager getTempPath] stringByAppendingPathComponent:fileName];
    }
    return targetPath;
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
        NSArray *configInfo = [FILE_CONFIG safeObjectForKey:KKD_NSINETGER_2_NSSTRING(type)];

        NSInteger version = [self getDBVersionCode:type];
        NSInteger miniSupport = [[configInfo objectAtIndex:3] integerValue];
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

+ (void)deleteDBFileWithType:(DBFileType)type completeHandle:(void (^)())completeHandle
{
    [PRPAlertView showWithTitle:@"是否删除此功能包？删除后您将无法正常使用相关功能。"
                        message:nil
                    cancelTitle:LocalizedStr(All_No)
                    cancelBlock:nil
                     otherTitle:LocalizedStr(All_Yes)
                     otherBlock:^
     {
         NSString *filePath = [FileManager getFilePathByFileType:type];
         
         if (DeleteFiles(filePath))
         {
             [HUDManager showAutoHideHUDWithToShowStr:@"删除成功" HUDMode:MBProgressHUDModeText];
             
             if (completeHandle)
             {
                 completeHandle();
             }
         }
         else
         {
             [HUDManager showAutoHideHUDWithToShowStr:@"删除失败，请重试" HUDMode:MBProgressHUDModeText];
         }
     }];
}

////////////////////////////////////////////////////////////////////////////////

+ (NSInteger)getNotExsitFileNum
{
    NSInteger num = 0;
    for (NSString *key in [self fileConfigKeys]) {
        BOOL flag = [self isAbsoluteValidDBFile:[key integerValue]];
        if (!flag) {
            num++;
        } else {
            DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:key];
            if (model.hasNewVersion) {
                num++;
            }
        }
    }
    return num;
}

+(BOOL)unPackageFileWithPath:(NSString *)path toPath:(NSString*)toPath
{
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    BOOL openFileFlag = [zipArchive UnzipOpenFile:path];
    
    if (openFileFlag) {
        BOOL unZipFlag = [zipArchive UnzipFileTo:toPath overWrite:YES];
        
        [zipArchive UnzipCloseFile];
        
        return unZipFlag;
    }
    return NO;
}

+ (BOOL)unPackageFileWithPath:(NSString *)path toPath:(NSString *)toPath fileType:(DBFileType)type
{
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    BOOL openFileFlag = [zipArchive UnzipOpenFile:path];
    
    if (openFileFlag) {
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
        model.isUpPackageing = YES;
        
        BOOL unZipFlag = [zipArchive UnzipFileTo:toPath overWrite:YES];
        [zipArchive UnzipCloseFile];
            
        DeleteFiles(path);
        model.isUpPackageing = NO;
        
        return unZipFlag;
    } else {
        DeleteFiles(path);
    }
    
    return NO;
}

+ (BOOL)unPackageFileWithToUnPackageFilePath:(NSString *)path fileType:(DBFileType)type
{
    BOOL flag = NO;
    
    if (IsFileExists(path)) {
        NSString *toPath = nil;
        
        /*if (TYPEFACE_INDEX == type) {
            toPath  = [FileManager getFontPath];
        } else */{
            toPath = [FileManager getDBPath];
        }
    
        flag = [FileManager unPackageFileWithPath:path toPath:toPath fileType:type];
    }
    
    return flag;
}

+ (NSMutableDictionary *)getDataPackageInfoModels
{
    NSString *path = [DOCUMENTS_PATH stringByAppendingPathComponent:@"dataPackageInfoModels.plist"];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];

    if (IsFileExists(path)) {
        NSMutableDictionary *tempModelsDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        for (NSString *key in [tempModelsDic allKeys]) {
            NSDictionary *modelDic = [tempModelsDic safeObjectForKey:key];
            
            DataPackageInfoModel *model = nil;
            if (modelDic) {
                model = [[DataPackageInfoModel alloc] initWithDictionary:modelDic];
                model.isManualTapDownload = NO;
                model.isDownloading = NO;
                model.hasNewVersion = NO;
                model.isUpPackageing = NO;
            } else {
                model = [[DataPackageInfoModel alloc] init];
            }
            
            [resultDic setObject:model forKey:key];
        }
        return resultDic;
    } else {
        for (NSString *key in [self fileConfigKeys]) {
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

// 检查自动下载
-(void)checkFileUpdateWithAutoDownload:(BOOL)autoDownload
{
    [self dbFileUpdateAndNextWithDBFileType:[FileManager fileConfigKeys][0].integerValue
                               autoDownload:autoDownload];
}

#pragma mark - 下载相关的方法

// ************************************************************************

- (void)dbFileUpdateWithDBFileType:(DBFileType)type autoDownload:(BOOL)autoDownload
{
    // 判断type是不是在范围之内
    if ([[FileManager fileConfigKeys] containsObject:KKD_NSINETGER_2_NSSTRING(type)]) {
        [self updateDBByID:type autoDownload:autoDownload];
    }
}

#pragma mark - 自动下载相关的方法

// ************************************************************************

- (void)dbFileUpdateAndNextWithDBFileType:(DBFileType)type autoDownload:(BOOL)autoDownload
{
    NSInteger index = [[FileManager fileConfigKeys] indexOfObject:KKD_NSINETGER_2_NSSTRING(type)];
    NSInteger lastIndex = [FileManager fileConfigKeys].count - 1;
    
    if (NSNotFound != index && index <= lastIndex)
    {
        if (index < lastIndex)
        {
            [self updateDBByID:type autoDownload:autoDownload nextId:[[FileManager fileConfigKeys][index + 1] integerValue]];
        }
        else if (index == lastIndex)
        {
            [self dbFileUpdateWithDBFileType:type autoDownload:autoDownload];
        }
    }
}

#pragma mark - 下载基础方法

- (void)updateDBByID:(DBFileType)type autoDownload:(BOOL)autoDownload
{
    [self updateDBByID:type autoDownload:autoDownload nextId:-1];
}

- (void)updateDBByID:(DBFileType)type autoDownload:(BOOL)autoDownload nextId:(DBFileType)nextId
{
    NSString * versionCode = [NSString stringWithFormat:@"%ld", [FileManager getDBVersionCode:type]];
    
    [self updateFileByID:type versionCode:versionCode autoDownload:autoDownload nextId:nextId];
}

- (void)updateFileByID:(DBFileType)type versionCode:(NSString *)versionCode autoDownload:(BOOL)autoDownload nextId:(DBFileType)nextId
{
    NSArray *configInfo = [FILE_CONFIG safeObjectForKey:KKD_NSINETGER_2_NSSTRING(type)];

    NSArray *keys = @[@"app",
                      @"resource",
                      @"versionCode",
                      @"supportVersion",/*@"channel",*/
                      @"mid",
                      @"privateKey"];
    NSArray *values = @[@"kkpoem",
                        configInfo ? [configInfo objectAtIndex:1] : @"",
                        versionCode,
                        configInfo ? [configInfo objectAtIndex:2] : @"",/*kChannelID,*/
                        @"",
                        kPrivateKey];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    NSString *token = [[values componentsJoinedByString:@""] MD5Sum];
    [parameters setValue:token forKey:@"token"];
    [parameters removeObjectForKey:@"privateKey"];
    
    [self updateFileWithParameters:parameters fileType:type autoDownload:autoDownload nextFileType:nextId];
}

- (void)updateFileWithParameters:(NSMutableDictionary *)parameters fileType:(DBFileType)type autoDownload:(BOOL)autoDownload nextFileType:(DBFileType)nextFileType
{
    WEAKSELF
    [AFNetworkingTool request:@""
                          tag:1
                   methodType:POST
                   parameters:parameters
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSInteger tag) {
        if ([responseObject isValidDictionary]) {
          NSString *key = [NSString stringWithFormat:@"%ld",type];
          
          DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:key];
          if (!model) {
              model = [[DataPackageInfoModel alloc] init];
              
              [[FileManager sharedInstance].dataPackageInfoDic setObject:model forKey:key];
          }
          
          DataPackageInfoModel *tempModel = [[DataPackageInfoModel alloc] initWithDictionary:responseObject];
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
          NSString *filePath = [[weakSelf class] getFilePathByFileType:type];
          NSDictionary *attributesOfFile = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
          if (attributesOfFile) {
              fileSize = [attributesOfFile[@"NSFileSize"] integerValue] / 1000 / 1000;
          }
          
          if (space > model.size * 2) {
              if (model.hasNewVersion) {
                  if ([NetworkStatusManager isEnableWIFI]) {
                      if (autoDownload) {
                          // 下载库
                          model.isDownloading = YES;
                          
                          // 下载完成后继续检测是否有下一个下载任务
                          if ([model.patchUrl isAbsoluteValid] && ![model.dbMergeFailedVersionColde isEqualToString:model.versionCode] && (memory / 4) >= fileSize) {
                              [[DownloadManager sharedInstance] downloadFileWithURLString:model.patchUrl
                                                                                  isPatch:YES
                                                                                 progress:nil
                                                                                    pause:nil
                                                                               completion:^(AFDownloadRequestOperation *operation, NSError *error) {
                                   [weakSelf dbFileUpdateAndNextWithDBFileType:nextFileType autoDownload:autoDownload];
                              }];
                          } else {
                              [[DownloadManager sharedInstance] downloadFileWithURLString:model.downloadUrl
                                                                               completion:^(AFDownloadRequestOperation *operation, NSError *error) {
                                  [weakSelf dbFileUpdateAndNextWithDBFileType:nextFileType autoDownload:autoDownload];
                              }];
                          }
                      } else {
                          // 检测更新
                          [weakSelf dbFileUpdateAndNextWithDBFileType:nextFileType autoDownload:autoDownload];
                      }
                  } else {
                      if (autoDownload) {
                          // 下载库
                          if ([model.allowCellular isEqualToString:@"1"]) {
                              model.isDownloading = YES;
                              
                              // 移动网络下，不进行检测是否有下一个下载任务
                              if ([model.patchUrl isAbsoluteValid] && ![model.dbMergeFailedVersionColde isEqualToString:model.versionCode]  && (memory / 4) >= fileSize) {
                                  [[DownloadManager sharedInstance] downloadFileWithURLString:model.patchUrl
                                                                                      isPatch:YES
                                                                                     progress:nil
                                                                                        pause:nil
                                                                                   completion:nil];
                              } else {
                                  [[DownloadManager sharedInstance] downloadFileWithURLString:model.downloadUrl
                                                                                   completion:nil];
                              }
                          }
                      } else {
                          // 检测跟新
                          [weakSelf dbFileUpdateAndNextWithDBFileType:nextFileType autoDownload:autoDownload];
                      }
                  }
              } else {
                  // 检测更新
                  [weakSelf dbFileUpdateAndNextWithDBFileType:nextFileType autoDownload:autoDownload];
              }
          } else {
              [HUDManager showAutoHideHUDWithToShowStr:@"手机存储空间已满，请删除一些数据后再尝试下载"
                                               HUDMode:MBProgressHUDModeText];
          }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, NSInteger tag) {
        
    }];
}

#pragma mark - 获取资源版本号相关的方法

+ (NSInteger )getDBVersionCode:(DBFileType)fileType {
    if ([self dbFileIsExsitWithDBFileType:fileType]) {
        /*
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
        */
        {
            NSUInteger version = [[GYDataContext sharedInstance] userVersion:[self getFileNameByFileType:fileType]];
            
            return version;
        }
    }
    return 0;
}

- (DBFileType)getFileTypeByUrl:(NSString *)urlString
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
    AFHTTPRequestOperation *operation = [[DownloadManager sharedInstance] dbZipDownloadingOperationWithUrlStr:model.downloadUrl];
    if (!operation) {
        operation = [[DownloadManager sharedInstance] dbZipDownloadingOperationWithUrlStr:model.patchUrl];
    }
    return operation;
}

- (void)downloadPackageWithFileTypeAndShowNoticeString:(DBFileType)type
{
    NSString *notice = [NSString stringWithFormat:@"是否要下载“%@”离线包？",@""];
    
    [self downloadPackageWithFileType:type noticeStr:notice];
}

- (void)downloadPackageWithFileType:(DBFileType)type noticeStr:(NSString *)notice
{
    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    AFHTTPRequestOperation *downloadOperation = [self curDownloadOperationByPackageInfoModel:model];
    
    if (!downloadOperation) {
        BOOL flag = [NetworkStatusManager isEnableWIFI];
        if (flag) {
            if ([notice isAbsoluteValid]) {
                WEAKSELF
                [PRPAlertView showWithTitle:notice
                                    message:nil
                                cancelTitle:@"否"
                                cancelBlock:nil
                                 otherTitle:@"是"
                                 otherBlock:^{
                    [weakSelf dbFileUpdateWithDBFileType:type autoDownload:YES];
                }];
            } else {
                [self dbFileUpdateWithDBFileType:type autoDownload:YES];
            }
        } else {
            BOOL flag = [NetworkStatusManager isConnectNetwork];
            if (flag) {
                NSString *packageSizeStr = [FileManager packageSizeWithFileType:type];
                packageSizeStr = [packageSizeStr isAbsoluteValid] ? [NSString stringWithFormat:@"（%@）", packageSizeStr] : @"";
                
                WEAKSELF
                [PRPAlertView showWithTitle:[NSString stringWithFormat:@"当前处于移动网络，下载离线包会耗费您的流量%@，确定下载？\n（建议您连接wifi下载）", packageSizeStr]
                                    message:nil
                                cancelTitle:@"否"
                                cancelBlock:nil
                                 otherTitle:@"是"
                                 otherBlock:^{
                     DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
                     model.allowCellular = @"1";
                     
                     [weakSelf dbFileUpdateWithDBFileType:type autoDownload:YES];
                }];
            } else {
                [HUDManager showAutoHideHUDWithToShowStr:NoConnectionNetwork
                                                 HUDMode:MBProgressHUDModeText];
            }
        }
    } else {
        if (downloadOperation && downloadOperation.isPaused) {
            [downloadOperation resume];
            
            [HUDManager showAutoHideHUDWithToShowStr:@"继续下载离线包..."
                                             HUDMode:MBProgressHUDModeText];
        } else {
            [HUDManager showAutoHideHUDWithToShowStr:@"离线包正在下载，请稍候..."
                                             HUDMode:MBProgressHUDModeText];
        }
    }
}

- (void)downloadPackageWithFileType:(DBFileType)type
{
    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    AFHTTPRequestOperation *downloadOperation = [self curDownloadOperationByPackageInfoModel:model];
    
    if (!downloadOperation) {
        BOOL flag = [NetworkStatusManager isEnableWIFI];
        if (flag) {
            [HUDManager showAutoHideHUDWithToShowStr:@"开始下载离线包..."
                                             HUDMode:MBProgressHUDModeText];
            
            [self dbFileUpdateWithDBFileType:type autoDownload:YES];
        } else {
            BOOL flag = [NetworkStatusManager isConnectNetwork];
            if (flag) {
                NSString *packageSizeStr = [FileManager packageSizeWithFileType:type];
                packageSizeStr = [packageSizeStr isAbsoluteValid] ? [NSString stringWithFormat:@"（%@）", packageSizeStr] : @"";
                
                WEAKSELF
                [PRPAlertView showWithTitle:[NSString stringWithFormat:@"当前处于移动网络，下载离线包会耗费您的流量%@，确定下载？\n（建议您连接wifi下载）", packageSizeStr]
                                    message:nil
                                cancelTitle:@"否"
                                cancelBlock:nil
                                 otherTitle:@"是"
                                 otherBlock:^{
                     DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic objectForKey:KKD_NSINETGER_2_NSSTRING(type)];
                     model.allowCellular = @"1";
                     
                     [weakSelf dbFileUpdateWithDBFileType:type autoDownload:YES];
                 }];
            } else {
                [HUDManager showAutoHideHUDWithToShowStr:NoConnectionNetwork
                                                 HUDMode:MBProgressHUDModeText];
            }
        }
    } else {
        if (downloadOperation && downloadOperation.isPaused) {
            [downloadOperation resume];
            
            [HUDManager showAutoHideHUDWithToShowStr:@"继续下载离线包..."
                                             HUDMode:MBProgressHUDModeText];
        } else {
            [HUDManager showAutoHideHUDWithToShowStr:@"离线包正在下载，请稍候..."
                                             HUDMode:MBProgressHUDModeText];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

+ (NSString *)packageSizeWithFileType:(DBFileType)fileType
{
    /*
    NSArray *configInfo = [FILE_CONFIG safeObjectForKey:KKD_NSINETGER_2_NSSTRING(fileType)];

    if (configInfo)
    {
        NSInteger bookId = [configInfo[4] integerValue];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bookId == %ld", bookId];
        NSArray<NSDictionary *> *filterArray = [[FileManager sharedInstance].packageVersionInfoArray filteredArrayUsingPredicate:predicate];
        if ([filterArray isAbsoluteValid])
        {
            NSDictionary *bookVersionInfoDic = filterArray[0];
            NSInteger size = [[bookVersionInfoDic safeObjectForKey:@"size"] integerValue] / 1024 / 1024.0;
 
            return [NSString stringWithFormat:@"约%ldM", size];
        }
    }
     */
    return @"";
}

@end
