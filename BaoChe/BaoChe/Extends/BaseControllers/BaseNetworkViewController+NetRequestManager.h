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
    NetUserCenterRequestType_ModifyPossword                  , // 修改密码
    NetUserCenterRequestType_ModifyUserHeaderImage           , // 修改用户头像(POST)
    
    NetUserCenterRequestType_GetAllPassenger                 , // 获取所有乘客信息
    NetUserCenterRequestType_AddPassenger                    , // 添加一个乘客信息
    NetUserCenterRequestType_DeletePassenger                 , // 删除一个乘客信息
    NetUserCenterRequestType_ModifyPassenger                 , // 修改一个乘客信息
    
    // 忘记密码
    NetForgetPasswordRequestType_GetVerificationCode         , // 忘记密码->获取短信验证码(POST)
    NetForgetPasswordRequestType_ModifyPassword              , // 忘记密码->用验证码修改密码(POST)
    
    // 订单
    NetOrderRequesertType_CreateOrder                        , // 创建订单
    NetOrderRequesertType_GetAllOrderList                    , // 查询所有订单
    
    NetOrderRequesertType_ToRefundTicket                     , // 申请退票
    NetOrderRequesertType_CancelOrder                        , // 取消订单
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

