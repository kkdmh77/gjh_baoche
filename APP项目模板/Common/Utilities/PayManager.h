//
//  PayManager.h
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PayPlatform)
{
    /// 支付宝
    PayPlatform_Alipay = 0,
    /// 微信
    PayPlatform_WeChat,
    /// 银联
    PayPlatform_ChinaUnionPay
};

typedef void (^completeHandle) (BOOL isSuccess);

@interface Product : NSObject

@property (nonatomic, assign) double   price;           // 商品价格
@property (nonatomic, copy)   NSString *productName;    // 商品名称
@property (nonatomic, copy)   NSString *productDesc;    // 商品描述
@property (nonatomic, copy)   NSString *orderId;        // 订单ID

@end

@interface PayManager : NSObject

AS_SINGLETON(PayManager);

/// 支付
- (void)payOrderWithProduct:(Product *)product payPlatform:(PayPlatform)platform completeHandle:(completeHandle)handle;

/// 独立客户端支付结果检验
- (void)verifyPayResultWithHandleOpenURL:(NSURL *)url application:(UIApplication *)application;

@end
