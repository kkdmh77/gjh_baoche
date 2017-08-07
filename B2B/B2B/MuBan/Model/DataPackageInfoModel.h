//
//  DataPackageInfoModel.h
//  KKDictionary
//
//  Created by KungJack on 22/10/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "Jastor.h"

@interface DataPackageInfoModel : Jastor

@property (nonatomic, copy  ) NSString *appName;
@property (nonatomic, copy  ) NSString *channel;
@property (nonatomic, copy  ) NSString *downloadUrl;
@property (nonatomic,assign ) BOOL     hasNewVersion;
@property (nonatomic, copy  ) NSString *md5;                        // 校验全包的MD5
@property (nonatomic, copy  ) NSString *patchMd5;                   // 校验增量升级包的MD5
@property (nonatomic, copy  ) NSString *patchUrl;
@property (nonatomic, copy  ) NSString *sourceMd5;                  // 校验增量升级包和旧的全包合并包的MD5
@property (nonatomic, copy  ) NSString *resName;
@property (nonatomic,assign ) CGFloat  size;
@property (nonatomic, copy  ) NSString *supportVersion;
@property (nonatomic, copy  ) NSString *updateContent;
@property (nonatomic, copy  ) NSString *userVersion;
@property (nonatomic, copy  ) NSString *versionCode;                // 服务器最新的数据库版本号
@property (nonatomic, copy  ) NSString *allowCellular;              // 是否允许蜂窝数据进行下载(值为"1"时则允许)
@property (nonatomic,assign ) BOOL     isDownloading;
@property (nonatomic,assign ) CGFloat  percentDone;

@property (nonatomic, assign) BOOL     isManualTapDownload;         // 是否已经手动点击下载
@property (nonatomic, copy  ) NSString *dbMergeFailedVersionColde;  // 数据库包合并失败的版本号
@property (nonatomic, assign) BOOL     isUpPackageing;              // 是否正在解压

@end
