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
                          @(NetUserCenterRequestType_Register): @"user/register",
                          @(NetUserCenterRequestType_Login): @"user/login",
                          @(NetUserCenterRequestType_Logout): @"",
                          @(NetUserCenterRequestType_ModifyPossword): @"user/changePwd",
                          
                          @(NetUserCenterRequestType_GetAccountInfo): @"account/my/info",
                          @(NetUserCenterRequestType_ChangeAccountInfo): @"user/changeInfo",
                          
                          // 上传deviceToken
                          @(NetUploadDeviceTokenRequestType_UploadDeviceToken): @"",
                          };
    });
    
    return urlForTypeDic[@(requestType)];
}

@end
