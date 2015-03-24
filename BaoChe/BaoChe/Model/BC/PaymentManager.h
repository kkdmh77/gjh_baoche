//
//  PaymentManager.h
//  BaoChe
//
//  Created by swift on 15/3/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayManager.h"

@interface PaymentManager : NSObject

/// 支付
+ (void)toPayWithOrderNo:(NSString *)orderNo
                totalFee:(double)totalFee
             productName:(NSString *)name
             productDesc:(NSString *)desc
           suceessHandle:(void (^) (void))handle;

@end
