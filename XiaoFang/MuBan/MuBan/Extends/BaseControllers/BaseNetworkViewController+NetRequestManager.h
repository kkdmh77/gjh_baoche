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
    NetUserCenterRequestType_Login                              = 0, // 登录(POST)
    NetUserCenterRequestType_Register                              , // 注册(POST)
    
    // 实时水压
    NetWaterPressureRequestType_GetWaterPressureList               , // 获取实时水压列表(POST)
    NetWaterPressureRequestType_GetWaterPressureDetail             , // 获取实时水压详情(POST)
    
    NetWaterPressureRequestType_GetMonitoringStationsList          , // 获取监测点列表(POST)
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

