//
//  UserInfoModel.m
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "UserInfoModel.h"

// 设置信息key值
#define UserDefault_EmailKey             @"userDefault_EmailKey"            // 用户邮箱
#define UserDefault_SessionKey           @"userDefault_SessionKey"          // 登录的会话
#define UserDefault_UserIdKey            @"userDefault_UserIdKey"           // 用户ID
#define UserDefault_LoginNameKey         @"userDefault_LoginNameKey"        // 用户登录名
#define UserDefault_UserNameKey          @"userDefault_UserNameKey"         // 用户名
#define UserDefault_PasswordKey          @"userDefault_PasswordKey"         // 登录密码
#define UserDefault_UserHeaderImgIdKey   @"userDefault_UserHeaderImgIdKey"  // 用户图像ID
#define UserDefault_UserHeaderImgDataKey @"userDefault_UserHeaderImgDataKey"// 用户图像
#define UserDefault_LastLoginDateKey     @"userDefault_LastLoginDateKey"    // 用户最近登录时间
#define UserDefault_AreaCommunityKey     @"userDefault_AreaCommunityKey"    // 用户所在小区
#define UserDefault_IsBindGovWebKey      @"userDefault_IsBindGovWebKey"     // 用户是否实名认证
#define UserDefault_IdCardKey            @"userDefault_IdCardKey"           // 用户实名认证后的身份证号
#define UserDefault_UserObjKey           @"userDefault_UserObjKey"          // 用户对象

#define UserDefault_Brightness_Device    @"userDefault_Brightness_Device"   // 设备屏幕亮度
#define UserDefault_Brightness_App       @"userDefault_Brightness_App"      // 设备屏幕亮度

// o2o
#define UserDefault_UserLoginTokenKey       @"userDefault_UserLoginTokenKey"    // 用户登陆成功后服务器返回的token
#define UserDefault_UserLoginToken_VKey     @"userDefault_UserLoginToken_VKey"  // 用户登陆成功后服务器返回的token(加密版)
#define UserDefault_UserSearchHistroyKey    @"userDefault_UserSearchHistroyKey" // 用户搜索记录
#define UserDefault_CookiesArrayKey         @"userDefault_CookiesArrayKey"      // HTTP响应cookies
#define UserDefault_DeviceTokenKey          @"userDefault_DeviceTokenKey"       // 用户注册通知成功后返回的token



#define kUserInfoModelPlistFileName @"userInfo.plist"

@implementation UserInfoModel

+ (UserInfoModel *)sharedInstance
{
    static dispatch_once_t once;
    static UserInfoModel * singleton = nil;
    WEAKSELF
    dispatch_once( &once, ^{
        NSString *path = GetDocumentPathFileName(kUserInfoModelPlistFileName);
        if (IsFileExists(path)) {
            singleton = [weakSelf getUserInfoModelFromPath:path];
        } else {
            singleton = [[UserInfoModel alloc] init];
        }
    } );
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self configureDefaultValues];
    }
    return self;
}

// 设置每个属性的默认值
- (void)configureDefaultValues
{
   
}

- (void)saveGlobalUserInfoModel
{
    NSString *path = GetDocumentPathFileName(kUserInfoModelPlistFileName);
    if (IsFileExists(path)) {
        if (DeleteFiles(path)) {
            NSDictionary *dictionary = [self toDictionary];
            [dictionary writeToFile:path atomically:YES];
        }
    }
}

+ (UserInfoModel *)getUserInfoModelFromPath:(NSString *)path
{
    if (IsFileExists(path))
    {
        NSMutableDictionary *userInfoPlistDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
        UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:userInfoPlistDic];
        return model;
    }
    return [[UserInfoModel alloc] init];
}

@end
