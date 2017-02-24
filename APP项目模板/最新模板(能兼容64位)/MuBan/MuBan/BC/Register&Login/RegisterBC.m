//
//  RegisterBC.m
//  o2o
//
//  Created by swift on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "RegisterBC.h"
#import "HUDManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"
#import "StringJudgeManager.h"
#import "InterfaceHUDManager.h"

extern NSString * const kMobilePhoneErrorMessage;

@interface RegisterBC ()
{
    successHandle   _success;
    failedHandle    _failed;
}

@end

@implementation RegisterBC

DEF_SINGLETON(RegisterBC);

- (void)getVerificationCodeWithMobilePhoneNumber:(NSString *)phoneNumber isModifyPassword:(BOOL)isModifyPassword successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:phoneNumber regexStr:MobilePhoneNumRegex])
    {
        _success = success;
        _failed = failed;
        
        NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_GetVerificationCode];
        NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
        
        NSDictionary *dic = @{@"phone": phoneNumber,
                              @"type": (isModifyPassword ? @(1) : @(0))};
        
        [[NetRequestManager sharedInstance] sendRequest:url
                                           parameterDic:dic
                                      requestMethodType:RequestMethodType_POST
                                             requestTag:0
                                               delegate:self
                                               userInfo:nil];
    }
    else
    {
        [HUDManager showAutoHideHUDWithToShowStr:kMobilePhoneErrorMessage HUDMode:MBProgressHUDModeText];
    }
}

- (void)verificationCodeCheckWithMobilePhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)verificationCode successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:phoneNumber regexStr:MobilePhoneNumRegex])
    {
        if ([verificationCode isValidString])
        {
            _success = success;
            _failed = failed;
            
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_VerificationCodeCheck];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            
            NSDictionary *dic = @{@"phone": phoneNumber,
                                  @"auth": verificationCode};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:0
                                                   delegate:self
                                                   userInfo:nil];
        }
        else
        {
            [HUDManager showAutoHideHUDWithToShowStr:@"请输入验证码" HUDMode:MBProgressHUDModeText];
        }
    }
    else
    {
        [HUDManager showAutoHideHUDWithToShowStr:kMobilePhoneErrorMessage HUDMode:MBProgressHUDModeText];
    }
}

- (void)registerWithMobilePhoneUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm verificationCode:(NSString *)verificationCode successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:userName regexStr:MobilePhoneNumRegex])
    {
        if ([[self class] passwordIsAbsoluteValid:password])
        {
            if ([[self class] passwordIsAbsoluteValid:passwordConfirm])
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    if ([verificationCode isValidString])
                    {
                        _success = success;
                        _failed = failed;
                        
                        // 进行注册操作
                        NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                        NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                        
                        NSDictionary *dic = @{@"phone": userName,
                                              @"passwd": password,
                                              @"auth": verificationCode};
                        
                        [[NetRequestManager sharedInstance] sendRequest:url
                                                           parameterDic:dic
                                                      requestMethodType:RequestMethodType_POST
                                                             requestTag:NetUserCenterRequestType_Register
                                                               delegate:self
                                                               userInfo:nil];
                    }
                    else
                    {
                        [HUDManager showAutoHideHUDWithToShowStr:@"请输入验证码" HUDMode:MBProgressHUDModeText];
                    }
                }
                else
                {
                    [HUDManager showAutoHideHUDWithToShowStr:@"2次密码输入不一致" HUDMode:MBProgressHUDModeText];
                }
            }
            else
            {
                [HUDManager showAutoHideHUDWithToShowStr:@"请再次输入密码" HUDMode:MBProgressHUDModeText];
            }
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

- (void)registerWithEmailUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:userName regexStr:EmailRegex])
    {
        if ([[self class] passwordIsAbsoluteValid:password])
        {
            if ([[self class] passwordIsAbsoluteValid:passwordConfirm])
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    _success = success;
                    _failed = failed;
                    
                    // 进行注册操作
                    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                    NSDictionary *dic = @{@"username": userName,
                                          @"password": password};
                    
                    [[NetRequestManager sharedInstance] sendRequest:url
                                                       parameterDic:dic
                                                  requestMethodType:RequestMethodType_POST
                                                         requestTag:NetUserCenterRequestType_Register
                                                           delegate:self
                                                           userInfo:nil];
            
                }
                else
                {
                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"2次密码输入不一致"];
                }
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请再次输入密码"];
            }
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:LocalizedStr(Register_PleaseInputPassword)];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入正确的邮箱"];
    }
}

- (void)registerWithNormalUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([userName isValidString])
    {
        if ([[self class] passwordIsAbsoluteValid:password])
        {
            if ([[self class] passwordIsAbsoluteValid:passwordConfirm])
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    _success = success;
                    _failed = failed;
                    
                    // 进行注册操作
                    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                    NSDictionary *dic = @{@"username": userName,
                                          @"password": password};
                    
                    [[NetRequestManager sharedInstance] sendRequest:url
                                                       parameterDic:dic
                                                  requestMethodType:RequestMethodType_POST
                                                         requestTag:NetUserCenterRequestType_Register
                                                           delegate:self
                                                           userInfo:nil];
                    
                }
                else
                {
                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"2次密码输入不一致"];
                }
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请再次输入密码"];
            }
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:LocalizedStr(Register_PleaseInputPassword)];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入用户名"];
    }
}

- (void)modifyPasswordWithMobilePhoneNum:(NSString *)phoneNum newPassword:(NSString *)password passwordConfirm:(NSString *)passwordConfirm verificationCode:(NSString *)verificationCode successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:phoneNum regexStr:MobilePhoneNumRegex])
    {
        if ([[self class] passwordIsAbsoluteValid:password])
        {
            if ([[self class] passwordIsAbsoluteValid:passwordConfirm])
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    if ([verificationCode isValidString])
                    {
                        _success = success;
                        _failed = failed;
                        
                        // 进行修改密码操作
                        NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_ModifyPossword];
                        NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                        
                        NSDictionary *dic = @{@"phone": phoneNum,
                                              @"passwd": password,
                                              @"auth": verificationCode};
                        
                        [[NetRequestManager sharedInstance] sendRequest:url
                                                           parameterDic:dic
                                                      requestMethodType:RequestMethodType_POST
                                                             requestTag:NetUserCenterRequestType_Register
                                                               delegate:self
                                                               userInfo:nil];
                    }
                    else
                    {
                        [HUDManager showAutoHideHUDWithToShowStr:@"请输入验证码" HUDMode:MBProgressHUDModeText];
                    }
                }
                else
                {
                    [HUDManager showAutoHideHUDWithToShowStr:@"2次密码输入不一致" HUDMode:MBProgressHUDModeText];
                }
            }
            else
            {
                [HUDManager showAutoHideHUDWithToShowStr:@"请再次输入密码" HUDMode:MBProgressHUDModeText];
            }
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

+ (BOOL)passwordIsAbsoluteValid:(NSString *)password {
    
    return [password isValidString] && password.length >= 6 && password.length <= 18;
}

- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    NSString *errorMessage = SafetyObject(error.localizedDescription) ? error.localizedDescription : OperationFailure;
    [HUDManager showAutoHideHUDWithToShowStr:errorMessage HUDMode:MBProgressHUDModeText];
    
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (_success)
    {
        _success(infoObj);
    }
}

@end
