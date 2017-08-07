//
//  BaseNetworkViewController+NetRequestManager.m
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController+NetRequestManager.h"

@implementation BaseNetworkViewController (NetRequestManager)

+ (NSString*) getRequestURLStr:(NetRequestType)requestType
{
    // 与"NetProductRequestType"一一对应
    static NSDictionary<NSNumber *, NSString*> *urlForTypeDic = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeDic = @{
                          // 用户中心
                          @(NetUserCenterRequestType_Register): @"",
                          @(NetUserCenterRequestType_Login): @"",
                          @(NetUserCenterRequestType_Logout): @"",
                          @(NetUserCenterRequestType_ModifyPossword): @"",
                          
                          @(NetUserCenterRequestType_GetVerificationCode): @"",
                          @(NetUserCenterRequestType_VerificationCodeCheck): @"",
                          @(NetUserCenterRequestType_GetAccountInfo): @"",
                          @(NetUserCenterRequestType_ChangeAccountInfo): @"",
                          @(NetUserCenterRequestType_UploadUserHeaderImage): @"",
                          
                          // 上传deviceToken
                          @(NetUploadDeviceTokenRequestType_UploadDeviceToken): @"",
                          
                          // 上传IDFA
                          @(NetUploadIDFARequestType_UploadIDFA): @"",
                          
                          // 热修复
                          @(NetJSPatchRequestType_GetPatch): @"",
                          
                          // 首页
                          @(NetHomePageRequestType_GetRecommendList): @"list/hot",
                          };
    });
    
    return urlForTypeDic[@(requestType)];
}

@end
