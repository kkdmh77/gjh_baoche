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
    static NSMutableArray *urlForTypeArray = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeArray = [NSMutableArray arrayWithObjects:
                           // 班车
                           @"cartInfoSearch",
                           @"origin",
                           @"origin/destination",
                           
                           // 用户中心
                           @"user/register",
                           @"user/login",
                           @"user/logout",
                           @"user/verifyCode",
                           
                           @"user",
                           @"user/changePwd",
                           @"user/uploadHeadPic",
                           
                           @"passengerList",
                           @"passenger",
                           @"passenger/delete",
                           @"passenger/update",
                           
                           // 忘记密码
                           @"user/retakeCode",
                           @"user/passwordRetake",
                           
                           // 订单
                           @"order",
                           @"orderListAll",
                           
                           @"backOrder/apply",
                           @"order/cancel",
                           
                           nil];

        
    });
    
    return urlForTypeArray[requestType];
}

@end
