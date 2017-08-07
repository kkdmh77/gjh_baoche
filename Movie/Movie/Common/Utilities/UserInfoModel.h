//
//  UserInfoModel.h
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "UserInfoEntity.h"

@interface UserInfoModel : Jastor

AS_SINGLETON(UserInfoModel);

/// 保存用户信息到磁盘
- (void)saveGlobalUserInfoModel;

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@property (nonatomic, strong) NSMutableDictionary *parameterDic;

@property (nonatomic, strong) UserInfoEntity *userInfo;         //!< 用户信息对象
@property (nonatomic, assign) BOOL isAutoDownloadPackage;       //!< 是否自动下载功能包
@property (nonatomic, assign) BOOL isNightThemeStyle;           //!< 是否夜间模式
@property (nonatomic, copy  ) NSString *deviceToken;            //!< 推送设备Token
@property (nonatomic, copy  ) NSString *userPositionIp;         //!< 用户的地理位置IP地址
@property (nonatomic, copy  ) NSString *userGuideKey;           //!< 显示用户引导的版本号

/****************************************用户向导相关**************************************/

@end
