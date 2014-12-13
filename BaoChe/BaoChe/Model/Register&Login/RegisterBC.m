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

@interface RegisterBC ()
{
    successHandle   _success;
    failedHandle    _failed;
}

@end

@implementation RegisterBC

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    _success = success;
    _failed = failed;

    /*
    if ([userName isAbsoluteValid])
    {
        if ([password isAbsoluteValid] && password.length >= 6)
        {
            if ([passwordConfirm isAbsoluteValid] && passwordConfirm.length >= 6)
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    // 进行注册操作
                    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                    NSDictionary *dic = @{@"userName": userName, @"password": password};
                    
                    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetUserCenterRequestType_Register delegate:self userInfo:nil];
                }
                else
                {
                    [HUDManager showAutoHideHUDWithToShowStr:[LanguagesManager getStr:Login_PasswordNotEqualShowInfoKey] HUDMode:MBProgressHUDModeText];
                }
            }
            else
            {
                [HUDManager showAutoHideHUDWithToShowStr:[LanguagesManager getStr:Login_NoPasswordConfirmShowInfoKey] HUDMode:MBProgressHUDModeText];
            }
        }
        else
        {
            [HUDManager showAutoHideHUDWithToShowStr:[LanguagesManager getStr:Login_NoPasswordShowInfoKey] HUDMode:MBProgressHUDModeText];
        }
    }
    else
    {
        [HUDManager showAutoHideHUDWithToShowStr:[LanguagesManager getStr:Login_NoUserShowInfoKey] HUDMode:MBProgressHUDModeText];
    }
     */
}

- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
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
