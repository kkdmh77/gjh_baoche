//
//  FileManager.h
//  kkpoem
//
//  Created by 龚 俊慧 on 16/9/21.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZipArchive/ZipArchive.h>
#import "DataPackageInfoModel.h"
#import "DownloadManager.h"

typedef NS_ENUM(NSInteger, FileExsitType) {
    /// 不存在
    Empty = 0,
    /// 存在
    Exsit,
    /// 可更新
    HasNewVersion,
    /// 需要强制升级（当前版本不能用）
    NeedUpDate,
};

typedef NS_ENUM(NSInteger, DBFileType)
{
    /// 注解
    ZHUJIE = 0,
    
    /// 译文
    YIWEN,
    
    /// 赏析
    SHANGXI,
    
    /// 全部诗词
    FULL_POEM,
    
};

// index0: 文件名
// index1: 文件下载参数
// index2: 当前版本号(supportVersion)
// index3: 最小兼容的版本号(miniSupportVersion)
#define FILE_CONFIG [FileManager fileConfig]

@interface FileManager : NSObject<UIAlertViewDelegate>

AS_SINGLETON(FileManager);

@property (nonatomic, strong) NSMutableDictionary<NSString *, DataPackageInfoModel *> *dataPackageInfoDic;
@property (nonatomic, strong) NSArray<NSDictionary *> *packageVersionInfoArray; // 功能包版本更新信息

+ (void)creatCacheFolder;

+ (NSString *)getVoicePath;
+ (NSString *)getDBPath;
+ (NSString *)getMoviePath;
+ (NSString *)getTempPath;
+ (NSString *)getFontPath;

/**
 * @method 根据文件类型获取文件名
 * @param  DBFileType: 文件类型
 * @creat  2015-10-23
 * @创建人  龚俊慧
 * @return 文件名
 */
+ (NSString *)getFileNameByFileType:(DBFileType)type;

/**
 * @method 根据文件类型获取文件所在的沙盒路径
 * @param  DBFileType: 文件类型
 * @creat  2015-10-23
 * @创建人  龚俊慧
 * @return 文件所在路径
 */
+ (NSString *)getFilePathByFileType:(DBFileType)type;

/**
 * @method 根据zip包的下载url获取zip包的下载目标路径
 * @param  url: zip包的下载url
 * @creat  2016-07-18
 * @创建人  龚俊慧
 * @return zip包的下载目标路径
 */
+ (NSString *)getFileDownladTargetPathWithDownloadUrl:(NSString *)url;

/**
 * @method 检查相关数据库文件是否存在
 * @param  DBFileType: 数据库类型
 * @creat  2015-10-23
 * @创建人  龚俊慧
 * @return BOOL
 */
+ (BOOL)dbFileIsExsitWithDBFileType:(DBFileType)type;

/**
 * @method 检查相关数据库文件的存在类型
 * @param  DBFileType: 数据库类型
 * @creat  2015-10-23
 * @创建人  龚俊慧
 * @return FileExsitType
 */
+ (FileExsitType)dbFileExsitTypeWithDBFileType:(DBFileType)type;

/**
 * @method 检查相关数据库文件的存在类型是否有效
 * @param  DBFileType: 数据库类型
 * @creat  2015-12-21
 * @创建人  龚俊慧
 * @return BOOL
 */
+ (BOOL)isAbsoluteValidDBFile:(DBFileType)type;

/// 删除功能包
+ (void)deleteDBFileWithType:(DBFileType)type
              completeHandle:(void(^)())completeHandle;

/// 获取没有下载/可更新数据包的总数量
+ (NSInteger)getNotExsitFileNum;

/// 解压zip包，不自动删除zip包
+ (BOOL)unPackageFileWithPath:(NSString *)path
                       toPath:(NSString*)toPath;

/// 解压db的zip包，解压完成后自动删除zip包
+ (BOOL)unPackageFileWithToUnPackageFilePath:(NSString *)path
                                    fileType:(DBFileType)type;
+ (BOOL)unPackageFileWithPath:(NSString *)path
                       toPath:(NSString *)toPath
                     fileType:(DBFileType)type;

/// 保存数据包信息到磁盘
- (void)saveDataPackageInfoModels;

/// 检测数据包更新/自动下载数据包，autoDownload为YES时检测到有更新会自动下载，否则只进行版本检测
- (void)checkFileUpdateWithAutoDownload:(BOOL)autoDownload;

/// 根据下载地址获取数据包类型
- (DBFileType)getFileTypeByUrl:(NSString *)urlString;

/// 下载数据包
- (void)downloadPackageWithFileType:(DBFileType)type;
- (void)downloadPackageWithFileTypeAndShowNoticeString:(DBFileType)type;
- (void)downloadPackageWithFileType:(DBFileType)type
                          noticeStr:(NSString *)notice;

////////////////////////////////////////////////////////////////////////////////

/// 根据fileType获取功能包的大小(待实现...)
+ (NSString *)packageSizeWithFileType:(DBFileType)fileType;

@end
