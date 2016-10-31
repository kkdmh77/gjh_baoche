//
//  LanguagesManager.h
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBCConvertor.h"

#define LocalizedStr(key) [LanguagesManager getStr:key]

static NSString * const SimpleChinese       = @"zh-Hans";
static NSString * const TradictionalChinese = @"zh-Hant";
static NSString * const English             = @"en";

static NSString * const LanguageTypeDidChangedNotificationKey = @"LanguageTypeDidChangedNotificationKey";

@interface LanguagesManager : NSObject

+ (void)initialization;
+ (NSArray *)getAppLanguagesTypeArray;
+ (void)setLanguage:(NSString *)languageType;
+ (NSString *)curLanguagesType;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate;

////////////////////////////////////////////////////////////////////////////////

/// 把str转换为当前语言类型的字符串(只支持简体<->繁体)
+ (NSString *)getCurLanguagesTypeStrWithStr:(NSString *)str;

@end

// 所有模块
static NSString * const All_DataSourceNotFoundKey  = @"All_DataSourceNotFound";
static NSString * const All_Delete                 = @"All_Delete";
static NSString * const All_Check                  = @"All_Check";
static NSString * const All_Edit                   = @"All_Edit";
static NSString * const All_Confirm                = @"All_Confirm";
static NSString * const All_Cancel                 = @"All_Cancel";
static NSString * const All_PickFromCamera         = @"All_PickFromCamera";
static NSString * const All_PickFromAlbum          = @"All_PickFromAlbum";
static NSString * const All_SaveToAlbum            = @"All_SaveToAlbum";
static NSString * const All_SaveSuccess            = @"All_SaveSuccess";
static NSString * const All_OperationFailure       = @"All_OperationFailure";
static NSString * const All_Notification           = @"All_Notification";
static NSString * const All_No                     = @"All_No";
static NSString * const All_Yes                    = @"All_Yes";

// 字体
static NSString * const Font_Size                  = @"Font_Size";
static NSString * const Font_Select                = @"Font_Select";
static NSString * const Font_More                  = @"Font_More";

// 设置
static NSString * const Setting_My_Collect         = @"Setting_My_Collect";
static NSString * const Setting_Package_Download   = @"Setting_Package_Download";
static NSString * const Setting_Invite_Friend      = @"Setting_Invite_Friend";
static NSString * const Setting_Set                = @"Setting_Set";

// 注册&登陆
static NSString * const Login_Login                        = @"Login_Login";
static NSString * const Login_UserName                     = @"Login_UserName";
static NSString * const Login_Password                     = @"Login_Password";
static NSString * const Login_AutoLogin                    = @"Login_AutoLogin";
static NSString * const Login_ForgetPassword               = @"Login_ForgetPassword";
static NSString * const Login_LoginNow                     = @"Login_LoginNow";

static NSString * const Register_Register                  = @"Register_Register";
static NSString * const Register_MobileNumber              = @"Register_MobileNumber";
static NSString * const Register_Email                     = @"Register_Email";
static NSString * const Register_PleaseInputPassword       = @"Register_PleaseInputPassword";
static NSString * const Register_PleaseInputPasswordAgain  = @"Register_PleaseInputPasswordAgain";
static NSString * const Register_VerificationCode          = @"Register_VerificationCode";
static NSString * const Register_GetVerificationCode       = @"Register_GetVerificationCode";
static NSString * const Register_RegisterNow               = @"Register_RegisterNow";
static NSString * const Register_UseMobileNumberToRegister = @"Register_UseMobileNumberToRegister";
static NSString * const Register_UseEmailToRegister        = @"Register_UseEmailToRegister";

static NSString * const Login_NoUser                       = @"Login_NoUser";
static NSString * const Login_NoPassword                   = @"Login_NoPassword";
static NSString * const Login_NoPasswordConfirm            = @"Login_NoPasswordConfirm";
static NSString * const Login_PasswordNotEqual             = @"Login_PasswordNotEqual";
static NSString * const Login_NoAgreeProtocol              = @"Login_NoAgreeProtocol";
static NSString * const Login_LoginFail                    = @"Login_LoginFail";
static NSString * const Login_Loading                      = @"Login_Loading";

// 其他

// 搜索页

// 版本检测
static NSString * const Version_NowNewVersion      = @"Version_NowNewVersion";
static NSString * const Version_LoadingShow        = @"Version_LoadingShow";

// 各控制器导航栏标题
static NSString * const NavTitle_HomePage          = @"NavTitle_HomePage";
static NSString * const NavTitle_MyCollection      = @"NavTitle_MyCollection";
static NSString * const NavTitle_RandomRecommended = @"NavTitle_RandomRecommended";
static NSString * const NavTitle_ReadingHistory    = @"NavTitle_ReadingHistory";
static NSString * const NavTitle_Setting           = @"NavTitle_Setting";
static NSString * const NavTitle_FontSelect        = @"NavTitle_FontSelect";
static NSString * const NavTitle_PackageDownload   = @"NavTitle_PackageDownload";
static NSString * const NavTitle_Feedback          = @"NavTitle_Feedback";
static NSString * const NavTitle_About             = @"NavTitle_About";



