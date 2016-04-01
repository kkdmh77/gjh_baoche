//
//  FileManager.h
//  KKDictionary
//
//  Created by KungJack on 11/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
#import "DataPackageInfoModel.h"

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

#define kChannelID       @"AppStore"
#define kPrivateKey      @"654321"

#define VOICE_FOLDER_NAME @"Voice"
#define DB_FOLDER_NAME    @"DB"
#define VIDEO_FOLDER_NAME @"Video"
#define TEMP_FOLDER_NAME  @"Tempp"
#define FONT_FOLDER_NAME  @"Font"

typedef NS_ENUM(NSInteger, DBFileType)
{
    /// 详解功能包
    XIANG_JIE_INDEX = 0,
    /// 汉字读音
    VOICE_INDEX,
    /// 学习资料
    XUE_XI_ZI_LIAO_INDEX,
    /// 汉语词典精简包
    CIKU_INDEX,
    /// 古汉语字典
    GU_HAN_YU_INDEX,
    /// 笔顺演示
    MOVIE_INDEX,
    /// 汉语词典扩展包
    CIKU_FULL_INDEX,
    /// 字源字形
    ZI_YUAN_ZI_XING_INDEX,
    /// 康熙字典
    KANG_XI_ZI_DIAN_INDEX,
    /// 说文解字
    SHUO_WEN_JIE_ZI_INDEX,
    /// 宋本广韵
    SONG_BEN_GUANG_YUN_INDEX,
    /// 方言汇集
    FANG_YAN_HUI_JI_INDEX,
    /// 大字集
    TYPEFACE_INDEX
};

// index0: 文件名
// index1: 文件下载参数
// index2: 当前版本号(supportVersion)
// index3: 最小兼容的版本号(miniSupportVersion)
#define FILE_CONFIG_ARRAY @[@[@"xiangjie.db",   @"xiangjie_ios",        @"1", @"1"],\
                            @[@"voice.db",      @"voice_ios",           @"1", @"1"],\
                            @[@"datum.db",      @"datum_ios",           @"1", @"1"],\
                            @[@"ciku.db",       @"ciku_ios",            @"1", @"1"],\
                            @[@"guhanyu.db",    @"guhanyu_ios",         @"1", @"1"],\
                            @[@"movie.db",      @"movie_ios",           @"1", @"1"],\
                            @[@"ciku_full.db",  @"ciku_full_ios",       @"1", @"1"],\
                            @[@"zyzx.db",       @"zyzx_ios",            @"1", @"1"],\
                            @[@"kangxi.db",     @"kangxi_ios",          @"1", @"1"],\
                            @[@"shuowen.db",    @"shuowen_ios",         @"1", @"1"],\
                            @[@"songben.db",    @"songben_ios",         @"1", @"1"],\
                            @[@"fangyan.db",    @"fangyan_ios",         @"1", @"1"],\
                            @[@"Font",          @"typeface_kkdict_ios", @"1", @"1"]]

#define UN_PARKAGE_FILE_SUCCESS @"UN_PARKAGE_FILE_SUCCESS"
#define UN_PARKAGE_FILE_ERROR   @"UN_PARKAGE_FILE_ERROR"

@interface FileManager : NSObject<UIAlertViewDelegate>

AS_SINGLETON(FileManager);

@property (nonatomic, strong) NSMutableDictionary<NSString *, DataPackageInfoModel *> *dataPackageInfoDic;

+ (void)creatCacheFolder;

+ (NSString *)getVoicePath;
+ (NSString *)getDBPath;
+ (NSString *)getMoviePath;
+ (NSString *)getTempPath;
+ (NSString *)getFontPath;

/**
 * @method 根据文件类型获取文件所在路径
 * @param  DBFileType: 文件类型
 * @creat  2015-10-23
 * @创建人  龚俊慧
 * @return 文件所在路径
 */
+ (NSString *)getFilePathByFileType:(DBFileType)type;

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

/// 获取没有下载的数据包的数量
+(NSInteger)getNotExsitFileNum;

/// 解压数据包
// +(BOOL)unParkageFileWithPath:(NSString *)path toPath:(NSString*)toPath;
+ (BOOL)unPackageFileWithPath:(NSString *)path toPath:(NSString *)toPath fileType:(DBFileType)type;
+ (void)unPackageFileWithToUnPackageFilePath:(NSString *)path fileType:(DBFileType)type;

/// 保存数据包信息到磁盘
- (void)saveDataPackageInfoModels;

// - (void)removeFileWithPath:(NSString *)path;
+ (float)getUnpackageTimePercent:(DBFileType)type;

/// 检测数据包更新
- (void)checkFileUpdateWithAutoDownload:(BOOL)autoDownload;

/// 根据下载地址获取数据包类型
- (DBFileType)getFileIdByUrl:(NSString *)urlString;

/// 下载数据包
- (void)downloadPackageWithFileType:(DBFileType)type;
- (void)downloadPackageWithFileTypeAndShowNoticeString:(DBFileType)type;
- (void)downloadPackageWithFileType:(DBFileType)type noticeStr:(NSString *)notice;

@end
