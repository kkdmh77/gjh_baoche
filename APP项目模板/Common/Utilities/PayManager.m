//
//  PayManager.m
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PayManager.h"

// 支付宝
#import "AlixLibService.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

// 支付宝
// 合作身份者id，以2088开头的16位纯数字
#define PartnerID       @"2088801555613602"
// 收款支付宝账号
#define SellerID        @"fd@yijushang.cn"
/*
// 安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY         @""
 */
// 商户私钥，自助生成
#define PartnerPrivKey  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOEoOCAtSR8L7DVaRUdmMtoCgY4JchBFymXatEnQAZk4lGAXEDs3/lfgY9UAgURhbITo9GSr8GCckCxJG7Ozleb6diuqiJPkqwJq2rl4A7YbrgQRRjUdxkpUyynFiB6WuIRe7Bs3B+DqH/NdlG+uvbf9qnktmUjqCN1IePxd3GvlAgMBAAECgYAH9O/m0zLeUgGK8SG5oDbz1VrWtia9xHmel9f/M8aar5EuxCHitdvbJybgBCCNVhQLrl/Unu7juyStK/g6pYIKkpxNR6feeyydXgaMxc7+tzVnnmJKumOTJZdY56M1S8eP7BK4TiFK2rStj6WFRTpwiA8SdCa6HGIWG2xFpC3akQJBAPkuOzcxJ3NwzLMvtV+iYBtZkbfEUoLIN5O1gBtM5NkM1iSxw56S0go0ZRn/ishkvuBFxarf9e24ZkAV2JS/0+8CQQDnUa2xHURQKqzNyMW2sU49xjTqUZGeRmorXXS4Xg0yTRhhuoV7+81wHClredJ32B2JUdqBRFlGIVKcPeHbS5lrAkEA1Z6EtXQ2VglF8/fajfouWkQXYGu2MNhkjQT0pnLtXgZbL2oWQkOsPYNdiURCPjngSXSHWU5XD00em6Ie4qbxkQJAUz/ABPgFd9yD6GOTVFanU/AbZyEICTBKUWUG9rtSgIHifnmERMSwgOKBvZ5QMrVim+MLgm44utaPRo+20xd4FQJBAK6JkWU3AYHYLg81l7QI0DGgwy7zpzp10UOMyuR0bf/VMPG0nvCp4gvxXF6wtzCnEc1qoYF3KVuYcf0Rni/R8SY="
// 支付宝公钥
#define AlipayPubKey    @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

@implementation Product

@end

@interface PayManager ()
{
    
}

@property (nonatomic, copy) completeHandle completeHandle;

@end

@implementation PayManager

DEF_SINGLETON(PayManager);

- (void)payOrderWithProduct:(Product *)product payPlatform:(PayPlatform)platform completeHandle:(completeHandle)handle
{
    self.completeHandle = handle;
    
    switch (platform)
    {
        case PayPlatform_Alipay:
        {
            NSString *appScheme = @"o2o";
            NSString *orderInfo = [self getOrderInfoWithProduct:product];
            
            NSString *signedStr = [self doRsa:orderInfo];
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            
            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 支付宝相关方法

// 校验支付结果
- (void)verifyPayResultWithResultStr:(NSString *)str
{
    // 结果处理
    AlixPayResult *result = [[AlixPayResult alloc] initWithString:str];
    
    if (result)
    {
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            // 交易成功
            NSString* key = AlipayPubKey;   // 签约帐户后获取到的支付宝公钥
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                // 验证签名成功,交易结果无篡改
                _completeHandle(YES);
            }
        }
        else
        {
            // 交易失败
            _completeHandle(NO);
        }
    }
    else
    {
        // 失败
        _completeHandle(NO);
    }
}

// 独立客户端支付结果检验
- (void)verifyPayResultWithHandleOpenURL:(NSURL *)url application:(UIApplication *)application
{
    NSString *query = nil;
    
    if (url != nil && [[url host] compare:@"safepay"] == 0)
    {
        query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self verifyPayResultWithResultStr:query];
}

// wap网页版回调函数
- (void)paymentResult:(NSString *)resultd
{
    [self verifyPayResultWithResultStr:resultd];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 生成订单
- (NSString*)getOrderInfoWithProduct:(Product *)product
{
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    /*
    order.tradeNO = [self generateTradeNO];                             // 生成订单ID(由商家自行制定)
     */
    order.tradeNO = product.orderId;
    order.productName = product.productName;                            // 商品名称
    order.productDescription = product.productDesc;                     // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price];   // 商品价格
    order.notifyURL = @"http%3A%2F%2F125.89.8.15:9999/pay/notify";     // 回调URL
    
    return [order description];
}

// 加密订单
- (NSString*)doRsa:(NSString *)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

// 生成订单ID(由商家自行制定)
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

@end
