//
//  KKAdAnalytics.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKAdAnalytics.h"
// #import "Aspects.h"
#import "KKAdRequest.h"
#import "UrlManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "GDTSplashAd.h"
#import "KKAdManager.h"
#import "UtilsHelper.h"
#import "KKDAnalytics.h"

static NSString * const kUMLaunchAdEventId       = @"ad_launch_show";
static NSString * const kUMInterstitialAdEventId = @"ad_interstitial_show";
static NSString * const kUMFullScreenAdEventId   = @"ad_full_screen_show";
static NSString * const kUMInsertBannerAdEventId = @"ad_insert_banner_show";

@implementation KKAdAnalytics

+ (void)uploadAdEvent:(NSObject *)adObjToAnalytics stateCode:(NSInteger)stateCode adStartShowTimeInterval:(NSTimeInterval)adStartShowTimeInterval {
    if (!adObjToAnalytics) return;
    
    KKAdModel *adModel = nil;
    NSString *UMEventId = nil;
    
    // 开屏广告的统计
    if ([adObjToAnalytics isKindOfClass:[KKLaunchAd class]] || [adObjToAnalytics isKindOfClass:[GDTSplashAd class]]) {
        if ([adObjToAnalytics isKindOfClass:[KKLaunchAd class]]) {
            adModel = ((KKLaunchAd *)adObjToAnalytics).adModel;
        }
        UMEventId = kUMLaunchAdEventId;
    } else if ([adObjToAnalytics isKindOfClass:[KKInterstitialAd class]] || [adObjToAnalytics isKindOfClass:[GDTMobInterstitial class]]) { // 插播广告
        if ([adObjToAnalytics isKindOfClass:[KKInterstitialAd class]]) {
            adModel = ((KKInterstitialAd *)adObjToAnalytics).adModel;
        }
        UMEventId = kUMInterstitialAdEventId;
    } else if ([adObjToAnalytics isKindOfClass:[KKInsertBannerAd class]] || [adObjToAnalytics isKindOfClass:[GDTMobBannerView class]]) { // banner条广告
        if ([adObjToAnalytics isKindOfClass:[KKInsertBannerAd class]]) {
            adModel = ((KKInsertBannerAd *)adObjToAnalytics).adModel;
        }
        UMEventId = kUMInsertBannerAdEventId;
    } else if ([adObjToAnalytics isKindOfClass:[KKFullScreenAd class]]) { // 开播前广告
        adModel = ((KKFullScreenAd *)adObjToAnalytics).adModel;
        UMEventId = kUMFullScreenAdEventId;
    }
    
    long adStartShowTime = (long)(adStartShowTimeInterval * 1000); // 广告开始显示的时间
    long adEndShowTime = (long)([[NSDate date] timeIntervalSince1970] * 1000); // 广告结束显示的时间
    long adShowDuration = adEndShowTime - adStartShowTime; // 广告的显示时长
    
    NSDictionary *parameterDic = [self parameterDicWithAdId:adModel ? adModel.adId : 0
                                                  stateCode:stateCode
                                                   duration:adShowDuration
                                                       time:adEndShowTime
                                                  requestId:adModel ? adModel.requestId : nil];
    // 自己的平台上报
    [self uploadAdEventWithParameter:parameterDic
                  failureRetryNumber:3];
    
    // 友盟平台上报
    [[KKDAnalytics sharedInstance] event:UMEventId attributes:parameterDic];
}

+ (void)uploadAdEventWithParameter:(NSDictionary *)parameterDic failureRetryNumber:(NSUInteger)retryNumber {
    if (retryNumber > 0) {
        NSURL *url = [self url];
        
        WEAKSELF
        [KKAdRequest sendAdAnalyticsRequest:url.absoluteString
                                        tag:NetAdRequestType_UploadAdAnalytics
                                 parameters:parameterDic
                                    success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag) {
            [weakSelf uploadAdEventWithParameter:parameterDic
                              failureRetryNumber:retryNumber - 1];
        }];
    }
}

+ (NSURL *)url {
    return [UrlManager getRequestUrlByNameSpace:Request_Ad_NameSpace
                                     methodName:[BaseNetworkViewController getRequestURLStr:NetAdRequestType_UploadAdAnalytics]];
}

+ (NSDictionary *)parameterDicWithAdId:(NSInteger)adId stateCode:(NSInteger)stateCode duration:(long)duration time:(long)time requestId:(NSString *)requestId {
    /*
     platform	string	平台 ios android
     adid	int	广告id
     state	int	KKAdCode
     duration	long	展示时间
     uuid	string	用户唯一ID
     imei	string	用户IMEI
     time	long	时间戳
     requestId int 请求ID
     sign	string	签名 md5(adid + duration + imei + uuid + state + time + key)
     */
    NSString *adMd5Key = @"sjklx76^45(dedf#$(&*>kl";
    
    NSArray *values = @[@(adId),
                        @(duration),
                        [[UtilsHelper getDeviceID] isValidString] ? [UtilsHelper getDeviceID] : @"",
                        @(stateCode),
                        @(time)];
    NSArray *keys = @[@"adid",
                      @"duration",
                      @"uuid",
                      @"state",
                      @"time"];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    [parameterDic setObject:@"ios" forKey:@"platform"];
    if ([requestId isValidString]) {
        [parameterDic setObject:requestId forKey:@"reqid"];
    }
    
    NSString *token = [[NSString stringWithFormat:@"%@%@", [values componentsJoinedByString:@""], adMd5Key] MD5Sum];
    [parameterDic setObject:token forKey:@"sign"];
    
    return parameterDic;
}

@end
