//
//  KKInterstitialAd.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/1.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKBaseAd.h"
#import "KKAdModel.h"
#import "KKAdPublic.h"

NS_ASSUME_NONNULL_BEGIN

@class KKInterstitialAd;

@protocol KKInterstitialAdDelegate <NSObject>

@optional

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)kkInterstitialSuccessToLoadAd:(KKInterstitialAd *)interstitial;

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)kkInterstitialFailToLoadAd:(KKInterstitialAd *)interstitial error:(NSError *)error;

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)kkInterstitialWillBePresentScreen:(KKInterstitialAd *)interstitial;

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)kkInterstitialDidBePresentScreen:(KKInterstitialAd *)interstitial;

/**
 *  插屏广告将要展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)kkInterstitialWillClosed:(KKInterstitialAd *)interstitial closeType:(KKAdClosedType)type;

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)kkInterstitialDidClosed:(KKInterstitialAd *)interstitial closeType:(KKAdClosedType)type;

/**
 *  插屏广告点击回调
 */
- (void)kkInterstitialClicked:(KKInterstitialAd *)interstitial;

/**
 *  点击插屏广告以后即将弹出全屏广告页
 */
- (void)kkInterstitialWillPresentFullScreenModal:(KKInterstitialAd *)interstitial;

/**
 *  点击插屏广告以后弹出全屏广告页
 */
- (void)kkInterstitialDidPresentFullScreenModal:(KKInterstitialAd *)interstitial;

@end

/*
 * 插播广告
 */
@interface KKInterstitialAd : KKBaseAd

@property (nonatomic, weak) id<KKInterstitialAdDelegate> delegate;

/// 必选
@property (nonatomic, strong) KKAdModel *adModel;

/**
 *  广告展示方法
 *  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
 */
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

/// 关闭广告
- (void)hideAdAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
