//
//  BaseNetworkViewController+NetRequestManager.h
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef enum
{
    // 用户中心
    NetUserCenterRequestType_Register                        = 0, // 注册(POST)
    NetUserCenterRequestType_Login                              , // 登录
    NetUserCenterRequestType_Logout                             , // 退出登录(POST)
    NetUserCenterRequestType_ModifyPossword                     , // 修改密码(POST)
    
    NetUserCenterRequestType_GetVerificationCode                , // 获取验证码
    NetUserCenterRequestType_VerificationCodeCheck              , // 校验验证码
    NetUserCenterRequestType_GetAccountInfo                     , // 个人信息获取(GET)
    NetUserCenterRequestType_ChangeAccountInfo                  , // 修改个人信息 (POST)
    NetUserCenterRequestType_UploadUserHeaderImage              , // 上传用户头像
    
    // 上传deviceToken
    NetUploadDeviceTokenRequestType_UploadDeviceToken           , // 上传deviceToken
    
    // 上传IDFA
    NetUploadIDFARequestType_UploadIDFA                         , // 上传IDFA
    
    // 热修复
    NetJSPatchRequestType_GetPatch                              , // 获取补丁
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

