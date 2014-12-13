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

@implementation LoginBC
{
    successHandle   _success;
    failedHandle    _failed;
}


- (void)loginWithUserName:(NSString *)userName password:(NSString *)password keepLogin:(NSNumber *)keep successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    _success = success;
    _failed = failed;
    
    /*
    if ([userName isAbsoluteValid])
    {
        if ([password isAbsoluteValid] && password.length >= 6)
        {
            [HUDManager showHUDWithToShowStr:[LanguagesManager getStr:Login_LoadingShowInfoKey] HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0.1 userInteractionEnabled:NO];
            //登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Login];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            NSDictionary *dic = @{@"userName": userName, @"password": password};
            
            [[NetRequestManager sharedInstance] sendRequest:url parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetUserCenterRequestType_Login delegate:self userInfo:nil];
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
    [HUDManager hideHUD];
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    if (_success)
    {
        _success(infoObj);
    }
}


@end
