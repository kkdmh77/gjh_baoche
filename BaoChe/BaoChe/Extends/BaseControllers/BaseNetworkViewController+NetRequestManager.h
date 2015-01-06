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
    // 班车
    NetBusRequestType_GetAllBusList                       = 0, // 获取所有班车列表(GET)
    NetBusRequestType_GetAllStartStationList                 , // 获取所有起始站点(GET)
    NetBusRequestType_GetAllEndStationList                   , // 获取所有终点站点(GET)
    
    // 用户中心
    NetUserCenterRequestType_Register                        , // 注册
    NetUserCenterRequestType_Login                           , // 登录
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

