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
    
    NetWaterPressureRequestType_GetMapPositionList                 , // 获取地图点列表(POST)
    
    NetWaterPressureRequestType_GetMonitoringDataList              , // 获取最新监测数据列表(POST)
    NetWaterPressureRequestType_GetMonitoringValueDetail           , // 获取最新监测数据详情(POST)
    
    NetWaterPressureRequestType_GetWarningDataList                 , // 获取最新报警数据列表(POST)
    NetWaterPressureRequestType_GetWarningValueDetail              , // 获取最新报警数据详情(POST)
    
    // 通知
    NetUploadDeviceTokenRequestType_UploadDeviceToken              ,
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

