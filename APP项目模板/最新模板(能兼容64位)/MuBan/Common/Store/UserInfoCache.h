//
//  UserInfoCache.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/22.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoEntity.h"

@interface UserInfoCache : NSObject

AS_SINGLETON(UserInfoCache);

+ (YYCache *)cache;

@property (nonatomic, strong) NSArray<NSObject *> *tabBarItemModelArray;

@property (nonatomic, strong) UserInfoEntity *userInfo;         //!< 用户信息对象
@property (nonatomic, assign) BOOL isAutoDownloadPackage;       //!< 是否自动下载功能包
@property (nonatomic, assign) BOOL isNightThemeStyle;           //!< 是否夜间模式
@property (nonatomic, copy  ) NSString *deviceToken;            //!< 推送设备Token
@property (nonatomic, copy  ) NSString *userPositionIp;         //!< 用户的地理位置IP地址
@property (nonatomic, copy  ) NSString *userGuideKey;           //!< 显示用户引导的版本号

/****************************************用户向导相关**************************************/

@end
