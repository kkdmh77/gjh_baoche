//
//  DataPackageInfoModel.h
//  KKDictionary
//
//  Created by KungJack on 22/10/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "Jastor.h"

@interface DataPackageInfoModel : Jastor

@property (nonatomic,strong ) NSString *appName;
@property (nonatomic,strong ) NSString *channel;
@property (nonatomic,strong ) NSString *downloadUrl;
@property (nonatomic,assign ) BOOL     hasNewVersion;
@property (nonatomic,strong ) NSString *md5;            // 校验全包的MD5
@property (nonatomic,strong ) NSString *patchMd5;       // 校验增量升级包的MD5
@property (nonatomic,strong ) NSString *patchUrl;
@property (nonatomic, copy  ) NSString *sourceMd5;      // 校验增量升级包和旧的全包合并包的MD5
@property (nonatomic,strong ) NSString *resName;
@property (nonatomic,assign ) CGFloat  size;
@property (nonatomic,strong ) NSString *supportVersion;
@property (nonatomic,strong ) NSString *updateContent;
@property (nonatomic,strong ) NSString *userVersion;
@property (nonatomic,strong ) NSString *versionCode;    // 服务器最新的数据库版本号
@property (nonatomic,strong ) NSString *allowCellular;  // 是否允许蜂窝数据进行下载(值为"1"时则允许)
@property (nonatomic,assign ) BOOL     isDownLoading;
@property (nonatomic,assign ) BOOL     isAutoDownLoading;
@property (nonatomic,assign ) CGFloat  percentDone;

@property (nonatomic, assign) BOOL     isManualTapDownload;         // 是否已经手动点击下载
@property (nonatomic, copy  ) NSString *dbMergeFailedVersionColde;  // 数据库包合并失败的版本号
@property (nonatomic, assign) BOOL     isUpPackageing;              // 是否正在解压

@end
