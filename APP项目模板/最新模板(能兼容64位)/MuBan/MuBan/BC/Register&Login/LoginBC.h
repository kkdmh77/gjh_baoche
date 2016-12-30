//
//  LoginBC.h
//  o2o
//
//  Created by leo on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestManager.h"

static NSString * const kLoginSuccessNotificationKey = @"kLoginSuccessNotificationKey";

typedef void (^successHandle) (id successInfoObj);
typedef void (^failedHandle)  (NSError *error);

typedef NS_ENUM(NSInteger, LoginThirdPlatformType)
{
    /// 微信
    LoginThirdPlatformType_Wechat = 0,
    /// QQ
    LoginThirdPlatformType_QQ,
    /// 新浪
    LoginThirdPlatformType_Sina,
    /// 快快查
    LoginThirdPlatformType_KK
};

@interface LoginBC : NSObject<NetRequestDelegate>

AS_SINGLETON(LoginBC);

// 账号密码登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  showHUD:(BOOL)show
            successHandle:(successHandle)success
             failedHandle:(failedHandle)failed;

// 动态验证码登录
- (void)dynamicLoginWithPhoneNumber:(NSString *)phoneNumber
                   verificationCode:(NSString *)code
                          autoLogin:(BOOL)autoLogin
                            showHUD:(BOOL)show
                      successHandle:(successHandle)success
                       failedHandle:(failedHandle)failed;
/// 退出登录
- (void)logoutWithSuccessHandle:(successHandle)success
                   failedHandle:(failedHandle)failed;

/**
 * @method 第三方平台登录
 * @param  platformType: 平台类型, thirdUserId: 第三方用户ID, accessToken: 第三方 access token
 * @return void
 * @创建人  龚俊慧
 * @creat  2016-03-23
 */
- (void)thirdPlatformLoginWithPlatformType:(LoginThirdPlatformType)platformType
                               thirdUserId:(NSString *)thirdUserId
                               accessToken:(NSString *)accessToken
                                   showHUD:(BOOL)show
                             successHandle:(successHandle)success
                              failedHandle:(failedHandle)failed;

/**
 * @method 登录成功后获取用户信息
 * @param  无
 * @return void
 * @创建人  龚俊慧
 * @creat  2016-12-28
 */
- (void)getUserInfoWithShowHUD:(BOOL)show
                 successHandle:(successHandle)success
                  failedHandle:(failedHandle)failed;

@end
