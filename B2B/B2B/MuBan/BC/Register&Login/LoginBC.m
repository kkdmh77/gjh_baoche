//
//  LoginBC.m
//  o2o
//
//  Created by leo on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "LoginBC.h"
#import "HUDManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"
#import "InterfaceHUDManager.h"
#import "StringJudgeManager.h"
#import "RegisterBC.h"

NSString * const kMobilePhoneErrorMessage = @"请输入正确的手机号码";

@interface LoginBC ()
{
    successHandle   _success;
    failedHandle    _failed;
}

@end

@implementation LoginBC

DEF_SINGLETON(LoginBC);

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password showHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:userName regexStr:MobilePhoneNumRegex])
    {
        if ([RegisterBC passwordIsAbsoluteValid:password])
        {
            _success = success;
            _failed = failed;
            
            if (show)
            {
                [HUDManager showHUDWithToShowStr:LocalizedStr(Login_Loading)
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Login];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];

            NSDictionary *dic = @{@"phone": userName,
                                  @"passwd": password};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:NetUserCenterRequestType_Login
                                                   delegate:self
                                                   userInfo:nil];
        }
        else
        {
            [HUDManager showAutoHideHUDWithToShowStr:LocalizedStr(Register_PleaseInputPassword) HUDMode:MBProgressHUDModeText];
        }
    }
    else
    {
        [HUDManager showAutoHideHUDWithToShowStr:kMobilePhoneErrorMessage HUDMode:MBProgressHUDModeText];
    }
}

- (void)dynamicLoginWithPhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)code autoLogin:(BOOL)autoLogin showHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:phoneNumber regexStr:MobilePhoneNumRegex])
    {
        if ([code isValidString])
        {
            _success = success;
            _failed = failed;
            
            if (show)
            {
                [HUDManager showHUDWithToShowStr:LocalizedStr(Login_Loading)
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:88];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            NSDictionary *dic = @{@"username": phoneNumber,
                                  @"checkCode": code,
                                  @"rememberMe": (autoLogin ? @"on" : @"")};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:88
                                                   delegate:self
                                                   userInfo:nil];
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入验证码"];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:kMobilePhoneErrorMessage];
    }
}

- (void)thirdPlatformLoginWithPlatformType:(LoginThirdPlatformType)platformType thirdUserId:(NSString *)thirdUserId accessToken:(NSString *)accessToken showHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([thirdUserId isValidString]) {
        if ([accessToken isValidString]) {
            _success = success;
            _failed = failed;
            
            if (show) {
                [HUDManager showHUDWithToShowStr:LocalizedStr(Login_Loading)
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Login];
            NSURL *url = [UrlManager getRequestUrlByNameSpace:Request_NameSpace methodName:methodNameStr];
            
            NSString *thirdPlatformName = nil;
            switch (platformType) {
                case LoginThirdPlatformType_Wechat:
                    thirdPlatformName = @"weixin";
                    break;
                case LoginThirdPlatformType_QQ:
                    thirdPlatformName = @"qq";
                    break;
                case LoginThirdPlatformType_Sina:
                    thirdPlatformName = @"sina";
                    break;
                case LoginThirdPlatformType_KK:
                    thirdPlatformName = @"kk";
                    break;
                    
                default:
                    break;
            }
            
            NSDictionary *dic = @{@"appCode": @"union",
                                  @"thirdType": thirdPlatformName,
                                  @"openId": thirdUserId,
                                  @"token": accessToken};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:NetUserCenterRequestType_Login
                                                   delegate:self
                                                   userInfo:nil];
        } else {
            [HUDManager showAutoHideHUDWithToShowStr:@"请输入access token" HUDMode:MBProgressHUDModeText];
        }
    } else {
        [HUDManager showAutoHideHUDWithToShowStr:@"请输入user id" HUDMode:MBProgressHUDModeText];
    }
}

- (void)logoutWithSuccessHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    _success = success;
    _failed = failed;
    
    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Logout];
    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:nil
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetUserCenterRequestType_Logout
                                           delegate:self
                                           userInfo:nil];
}

- (void)getUserInfoWithShowHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed {
    
    _success = success;
    _failed = failed;
    
    if (show) {
        
        [HUDManager showHUDWithToShowStr:@"获取用户信息..."
                                 HUDMode:MBProgressHUDModeIndeterminate
                                autoHide:NO
                  userInteractionEnabled:NO];
    }
    
    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_GetAccountInfo];
    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:nil
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetUserCenterRequestType_GetAccountInfo
                                           delegate:self
                                           userInfo:nil];
}

- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

- (void)executeLoginSuccessActionWithInfoObj:(NSDictionary *)infoObj
{
    if ([infoObj isSafeObject] && [infoObj isKindOfClass:[NSDictionary class]])
    {
        UserInfoEntity *userInfo = [UserInfoEntity new];
        // 解析数据...
        
        [UserInfoModel sharedInstance].userInfo = userInfo;
    }
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationKey object:nil];
    
    // 注册push通知(让服务器把deviceToken和userId关联)
    // [UIFactory registerRemoteNotification];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [HUDManager hideHUD];
    
    NSString *errorMessage = SafetyObject(error.localizedDescription) ? error.localizedDescription : OperationFailure;
    [HUDManager showAutoHideHUDWithToShowStr:errorMessage HUDMode:MBProgressHUDModeText];
    
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    
    // 登录成功后执行相关操作
    if (request.tag == NetUserCenterRequestType_Login)
    {
        [self executeLoginSuccessActionWithInfoObj:infoObj];
    }
    /*
    // 获取用户信息
    else if (request.tag == NetUserCenterRequestType_GetAccountInfo)
    {
        [self executeLoginSuccessActionWithInfoObj:infoObj];
    }
    */
    // 退出登录成功
    else if (request.tag == NetUserCenterRequestType_Logout)
    {
        // 清空数据
        [UserInfoModel sharedInstance].userInfo = nil;
        [UserInfoModel setObject:nil forKey:kCookiesKey];
    }
    
    if (_success)
    {
        _success(infoObj);
    }
}

@end
