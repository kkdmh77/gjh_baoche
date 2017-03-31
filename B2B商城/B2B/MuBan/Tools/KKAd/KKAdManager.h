//
//  KKAdManager.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKLaunchAd.h"
#import "KKInterstitialAd.h"
#import "KKInsertBannerAd.h"
#import "KKAdModel.h"
#import "GDTMobInterstitial.h"
#import "GDTMobBannerView.h"
#import "GDTSplashAd.h"
#import "KKFullScreenAd.h"

NS_ASSUME_NONNULL_BEGIN
/*
 * 通过这个类来加载自己的广告和腾讯广告
 */
@interface KKAdManager : NSObject

AS_SINGLETON(KKAdManager);

/**************************** 开屏广告 ********************************/
/**
 * @method 加载并展示开屏广告，会自动判断加载自己的广告还是腾讯广告
 * @param  placementId: 自己平台的广告位ID
 * @param  txAppKey: 腾讯广告平台的key
 * @param  requestFailureAdNotShow: 广告数据请求失败，广告将不会显示
 * @param  success: 广告数据请求成功，toShowAdObj：用来展示的广告对象
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)loadLaunchAdAndShowWithPlacementId:(NSString *)placementId
                                  txAppKey:(NSString *)txAppKey
                             txPlacementId:(NSString *)txPlacementId
                          placeholderImage:(UIImage *)placeholderImage
                                  inWindow:(UIWindow *)window
                                  delegate:(id __nullable)delegate
                   requestFailureAdNotShow:(void (^ __nullable)(void))failure
                                   success:(void (^ __nullable)(id toShowAdObj))success;

/**************************** 开播前广告 ********************************/

/**
 * @method 加载并展示全屏广告，只支持自己的广告平台
 * @param  placementId: 自己平台的广告位ID
 * @param  requestFailureAdNotShow: 广告数据请求失败，广告将不会显示
 * @param  success: 广告数据请求成功，toShowAdObj：用来展示的广告对象
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)loadFullScreenhAdAndShowWithPlacementId:(NSString *)placementId
                               placeholderImage:(UIImage *)placeholderImage
                  presentFromRootViewController:(UIViewController *)rootViewController
                                       delegate:(id __nullable)delegate
                        requestFailureAdNotShow:(void (^ __nullable)(void))failure
                                        success:(void (^ __nullable)(id toShowAdObj))success;

/**************************** 插播广告 ********************************/

/**
 * @method 初始化并预加载插播广告
 * @param  placementId: 自己平台的广告位ID
 * @param  txAppKey: 腾讯广告平台的key
 * @param  requestFailureAdNotShow: 广告数据请求失败，广告将不会显示
 * @param  success: 广告数据请求成功，toShowAdObj：用来展示的广告对象
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)initInterstitialAndLoadWithPlacementId:(NSString *)placementId
                                      txAppKey:(NSString *)txAppKey
                                 txPlacementId:(NSString *)txPlacementId
                                      delegate:(id __nullable)delegate
                       requestFailureAdNotShow:(void (^ __nullable)(void))failure
                                       success:(void (^ __nullable)(id toShowAdObj))success;

/**
 * @method 刷新插播广告，发起拉取广告请求
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)loadInterstitialAd;

/**
 * @method 展示插播广告
 * @param  rootViewController: 执行present广告控制器的UIViewController
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)presentInterstitialAdFromRootViewController:(UIViewController *)rootViewController;

/**
 * @method 关闭插播广告
 * @param  adPresentingViewController: 执行present广告控制器的UIViewController，如果关闭腾讯的插播广告就必传，因为腾讯插播广告没有提供关闭的接口
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)hideInterstitialAdAnimated:(BOOL)animated
        adPresentingViewController:(UIViewController * _Nullable)adPresentingViewController;

/**************************** banner条广告 ********************************/

/**
 * @method 初始化、加载并展示banner条广告
 * @param  placementId: 自己平台的广告位ID
 * @param  txAppKey: 腾讯广告平台的key
 * @param  containerViewController: 显示banner条广告的UIViewController
 * @param  requestFailureAdNotShow: 广告数据请求失败，广告将不会显示
 * @param  success: 广告数据请求成功，toShowAdObj：用来展示的广告对象
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)initInsertBannerAdWithFrame:(CGRect)frame
                        placementId:(NSString *)placementId
                           txAppKey:(NSString *)txAppKey
                      txPlacementId:(NSString *)txPlacementId
      showInContainerViewController:(UIViewController *)containerViewController
                           delegate:(id __nullable)delegate
            requestFailureAdNotShow:(void (^ __nullable)(void))failure
                            success:(void (^ __nullable)(id toShowAdObj))success;

/**************************** 工具 ********************************/
/**
 * @method 点击广告做相应的跳转
 * @param  rootViewController: 执行present的控制器
 * @return void
 * @创建人  龚俊慧
 * @creat  2017-02-27
 */
- (void)presentViewControllerWithRootViewController:(UIViewController *)rootViewController
                                            adModel:(KKAdModel *)adModel
                                           animated:(BOOL)flag
                                         completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
