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
    NetUserCenterRequestType_Logout                          , // 登出
    NetUserCenterRequestType_GetVerificationCode             , // 获取验证码
    
    NetUserCenterRequestType_GetUserInfo                     , // 获取用户信息
    
    NetUserCenterRequestType_GetAllPassenger                 , // 获取所有乘客信息
    NetUserCenterRequestType_AddPassenger                    , // 添加一个乘客信息
    NetUserCenterRequestType_DeletePassenger                 , // 删除一个乘客信息
    
    // 订单
    NetOrderRequesertType_CreateOrder                        , // 创建订单
    NetOrderRequesertType_GetAllOrderList                    , // 查询所有订单
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

