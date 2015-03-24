//
//  PaymentManager.m
//  BaoChe
//
//  Created by swift on 15/3/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "PaymentManager.h"
#import "InterfaceHUDManager.h"

@implementation PaymentManager

// 支付
+ (void)toPayWithOrderNo:(NSString *)orderNo totalFee:(double)totalFee productName:(NSString *)name productDesc:(NSString *)desc suceessHandle:(void (^)(void))handle
{
    Product *p = [[Product alloc] init];
    p.price = totalFee;
    p.productName = name;
    p.productDesc = desc;
    p.orderId = orderNo;
    
    [[PayManager sharedInstance] payOrderWithProduct:p completeHandle:^(AlipayResultStatusCode statusCode) {
        
        switch (statusCode)
        {
            case AlipayResultStatusCode_Success:
            {
                // 支付成功
                if (handle) handle();
            }
                break;
            case AlipayResultStatusCode_Failed:
            {
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil message:@"支付失败，请重试" buttonTitle:Confirm];
            }
                break;
                
            case AlipayResultStatusCode_UserCancel:
            {
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil message:@"您已取消支付" buttonTitle:Confirm];
            }
                break;
            case AlipayResultStatusCode_NetworkConnectionError:
            {
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil message:@"网络连接出错，请稍后重试" buttonTitle:Confirm];
            }
                break;
                
            default:
                break;
        }
        
    }];
}

@end
