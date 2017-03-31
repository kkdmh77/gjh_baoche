//
//  KKAdManager.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKAdManager.h"
#import "KKAdRequest.h"
#import "UrlManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
// #import "UtilsHelper.h"
#import "GCDThread.h"
#import "ATTimerManager.h"
#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>
#import "KKAdAnalytics.h"

#define Request_Ad_NameSpace @""

@interface KKAdManager ()<SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) id staticLaunchAdObj; ///< 最终平台的开屏广告对象
@property (nonatomic, strong) id staticInterstitialAdObj; ///< 最终平台的插播广告对象
@property (nonatomic, strong) id staticFullScreenAdObj; ///< 开播前广告对象

@end

@implementation KKAdManager

DEF_SINGLETON(KKAdManager);

#pragma mark - 开屏广告

- (void)loadLaunchAdAndShowWithPlacementId:(NSString *)placementId txAppKey:(NSString *)txAppKey txPlacementId:(NSString *)txPlacementId placeholderImage:(UIImage *)placeholderImage inWindow:(UIWindow *)window delegate:(id)delegate requestFailureAdNotShow:(void (^)(void))failure success:(void (^ _Nullable)(id _Nonnull))success {
    // 先请求自己的广告如果没有就显示腾讯广告
    if (![placementId isValidString] || ![txAppKey isValidString] || ![txPlacementId isValidString] || !window) {
        return;
    }
    
    // 放自己接口异步请求时的占位图
    UIImageView *requestPlaceholderImageView = [self addRequestPlaceholderImageViewToWindow:window
                                                                           placeholderImage:placeholderImage];
    
    WEAKSELF
    NSURL *ulr = [self url];
    NSDictionary *parameterDic = [self parameterDicWithPlacementId:placementId];
    
    [KKAdRequest sendAdRequest:ulr.absoluteString
                           tag:0
                    parameters:parameterDic
                       success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag) {
        // 移除占位图
        [weakSelf removeRequestPlaceholderImageView:requestPlaceholderImageView];
            
        // 如果没有自己的广告且需要显示腾讯广告（openThird = 1）时就显示腾讯广告
        NSArray *tempArray = [responseObject safeObjectForKey:@"ads"]; // 广告数据
        BOOL isNeedLoadTXAd = [[responseObject safeObjectForKey:@"openThird"] boolValue]; // 是否需要加载腾讯广告

        if ([tempArray isValidArray]) { // 加载自己的广告
            KKAdModel *adModel = [KKAdModel modelWithDictionary:tempArray.firstObject];
            adModel.requestId = [responseObject safeObjectForKey:@"reqId"];
            
            KKLaunchAd *launchAd = [[KKLaunchAd alloc] init];
            launchAd.delegate = delegate;
            launchAd.adModel = adModel;
            [launchAd loadAdWithPlaceholderImage:placeholderImage
                                 andShowInWindow:window];
            
            weakSelf.staticLaunchAdObj = launchAd;
            
            if (success) {
                success(launchAd);
            }
        } else if (isNeedLoadTXAd) { // 加载腾讯广告
            // 腾讯开屏广告只支持竖屏
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:txAppKey
                                                                placementId:txPlacementId];
                splashAd.delegate = delegate;
                // 针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
                UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"h%ld", (long)(IPHONE_HEIGHT * [UIScreen mainScreen].scale)]];
                splashAd.backgroundColor = [UIColor colorWithPatternImage:img];
                splashAd.backgroundColor = [UIColor colorWithPatternImage:placeholderImage];
                splashAd.fetchDelay = 2;
                [splashAd loadAdAndShowInWindow:window];
                
                weakSelf.staticLaunchAdObj = splashAd;
                
                if (success) {
                    success(splashAd);
                }
            } else {
                if (failure) {
                    failure();
                }
            }
        } else {
            weakSelf.staticLaunchAdObj = nil;
            
            if (failure) {
                failure();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag) {
        // 移除占位图
        [weakSelf removeRequestPlaceholderImageView:requestPlaceholderImageView];
        
        weakSelf.staticLaunchAdObj = nil;
        
        if (failure) {
            failure();
        }
    }];
}

- (void)loadFullScreenhAdAndShowWithPlacementId:(NSString *)placementId placeholderImage:(UIImage *)placeholderImage presentFromRootViewController:(UIViewController *)rootViewController delegate:(id)delegate requestFailureAdNotShow:(void (^)(void))failure success:(void (^ _Nullable)(id _Nonnull))success {
    if (![placementId isValidString] || !rootViewController) {
        return;
    }
    
    WEAKSELF
    NSURL *ulr = [self url];
    NSDictionary *parameterDic = [self parameterDicWithPlacementId:placementId];
    
    [KKAdRequest sendAdRequest:ulr.absoluteString
                           tag:0
                    parameters:parameterDic
                       success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag) {
       // 如果没有自己的广告且需要显示腾讯广告（openThird = 1）时就显示腾讯广告
       NSArray *tempArray = [responseObject safeObjectForKey:@"ads"]; // 广告数据
       // BOOL isNeedLoadTXAd = [[responseObject safeObjectForKey:@"openThird"] boolValue]; // 是否需要加载腾讯广告
       
       if ([tempArray isValidArray]) { // 加载自己的广告
           KKAdModel *adModel = [KKAdModel modelWithDictionary:tempArray.firstObject];
           adModel.requestId = [responseObject safeObjectForKey:@"reqId"];
           
           KKFullScreenAd *fullScreen = [[KKFullScreenAd alloc] init];
           fullScreen.delegate = delegate;
           fullScreen.adModel = adModel;
           [fullScreen loadAdWithPlaceholderImage:placeholderImage
                  presentFromRootViewController:rootViewController];
           
           weakSelf.staticFullScreenAdObj = fullScreen;
           
           if (success) {
               success(fullScreen);
           }
       } else {
           weakSelf.staticFullScreenAdObj = nil;
           
           if (failure) {
               failure();
           }
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag) {
       weakSelf.staticFullScreenAdObj = nil;
       
       if (failure) {
           failure();
       }
   }];
}

// 放自己接口异步请求时的占位图
- (UIImageView *)addRequestPlaceholderImageViewToWindow:(UIWindow *)window placeholderImage:(UIImage *)placeholderImage {
    UIImageView *requestPlaceholderImageView = [[UIImageView alloc] initWithFrame:window.bounds];
    [requestPlaceholderImageView keepAutoresizingInFull];
    requestPlaceholderImageView.image = placeholderImage;
    [window addSubview:requestPlaceholderImageView];
    
    return requestPlaceholderImageView;
}

// 移除占位图
- (void)removeRequestPlaceholderImageView:(UIImageView *)placeholderImageView {
    if (placeholderImageView) {
        [UIView animateWithDuration:0.3 animations:^{
            placeholderImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [placeholderImageView removeFromSuperview];
        }];
    }
}

#pragma mark - 插播广告

- (void)initInterstitialAndLoadWithPlacementId:(NSString *)placementId txAppKey:(NSString *)txAppKey txPlacementId:(NSString *)txPlacementId delegate:(id)delegate requestFailureAdNotShow:(void (^ __nullable)(void))failure success:(void (^ _Nullable)(id _Nonnull))success {
    // 先请求自己的广告如果没有就显示腾讯广告
    if (![placementId isValidString] || ![txAppKey isValidString] || ![txPlacementId isValidString]) {
        return;
    }
    
    WEAKSELF
    NSURL *ulr = [self url];
    NSDictionary *parameterDic = [self parameterDicWithPlacementId:placementId];
    
    [KKAdRequest sendAdRequest:ulr.absoluteString
                           tag:0
                    parameters:parameterDic
                       success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag) {
       // 如果没有自己的广告且需要显示腾讯广告（openThird = 1）时就显示腾讯广告
       NSArray *tempArray = [responseObject safeObjectForKey:@"ads"]; // 广告数据
       BOOL isNeedLoadTXAd = [[responseObject safeObjectForKey:@"openThird"] boolValue]; // 是否需要加载腾讯广告
       
       if ([tempArray isValidArray]) { // 加载自己的广告
           KKAdModel *adModel = [KKAdModel modelWithDictionary:tempArray.firstObject];
           adModel.requestId = [responseObject safeObjectForKey:@"reqId"];
           
           KKInterstitialAd *interstitialAd = [[KKInterstitialAd alloc] init];
           interstitialAd.delegate = delegate;
           interstitialAd.adModel = adModel;
          
           weakSelf.staticInterstitialAdObj = interstitialAd;
           
           if (success) {
               success(interstitialAd);
           }
       } else if (isNeedLoadTXAd) { // 加载腾讯广告
           GDTMobInterstitial *interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:txAppKey
                                                                                placementId:txPlacementId];
           interstitialObj.delegate = delegate;
           [interstitialObj loadAd];
           
           weakSelf.staticInterstitialAdObj = interstitialObj;
           
           if (success) {
               success(interstitialObj);
           }
       } else {
           weakSelf.staticInterstitialAdObj = nil;
           
           if (failure) {
               failure();
           }
       }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag) {
       weakSelf.staticInterstitialAdObj = nil;
        
        if (failure) {
            failure();
        }
    }];
}

- (void)loadInterstitialAd {
    if ([_staticInterstitialAdObj isKindOfClass:[KKInterstitialAd class]]) {
       
    } else if ([_staticInterstitialAdObj isKindOfClass:[GDTMobInterstitial class]]) {
        [((GDTMobInterstitial *)_staticInterstitialAdObj) loadAd];
    }
}

- (void)presentInterstitialAdFromRootViewController:(UIViewController *)rootViewController {
    if (rootViewController) {
        if ([_staticInterstitialAdObj isKindOfClass:[KKInterstitialAd class]]) {
            [((KKInterstitialAd *)_staticInterstitialAdObj) presentFromRootViewController:rootViewController];
        } else if ([_staticInterstitialAdObj isKindOfClass:[GDTMobInterstitial class]]) {
            [((GDTMobInterstitial *)_staticInterstitialAdObj) presentFromRootViewController:rootViewController];
        }
    }
}

- (void)hideInterstitialAdAnimated:(BOOL)animated adPresentingViewController:(UIViewController * _Nullable)adPresentingViewController {
    if ([_staticInterstitialAdObj isKindOfClass:[KKInterstitialAd class]]) {
        [((KKInterstitialAd *)_staticInterstitialAdObj) hideAdAnimated:animated];
    } else if ([_staticInterstitialAdObj isKindOfClass:[GDTMobInterstitial class]]) {
        if (adPresentingViewController &&
            adPresentingViewController.presentedViewController &&
            [adPresentingViewController.presentedViewController isKindOfClass:NSClassFromString(@"GDTBaseInterstitialDialog")]) {
            [adPresentingViewController.presentedViewController dismissViewControllerAnimated:animated
                                                                                   completion:nil];
        }
    }
}

#pragma mark - banner条广告

- (void)initInsertBannerAdWithFrame:(CGRect)frame placementId:(NSString *)placementId txAppKey:(NSString *)txAppKey txPlacementId:(NSString *)txPlacementId showInContainerViewController:(UIViewController *)containerViewController delegate:(id)delegate requestFailureAdNotShow:(void (^ __nullable)(void))failure success:(void (^ _Nullable)(id _Nonnull))success {
    if (![placementId isValidString] || ![txAppKey isValidString] || ![txPlacementId isValidString] || !containerViewController) {
        return;
    }
    
    NSURL *ulr = [self url];
    NSDictionary *parameterDic = [self parameterDicWithPlacementId:placementId];
    
    [KKAdRequest sendAdRequest:ulr.absoluteString
                           tag:0
                    parameters:parameterDic
                       success:^(AFHTTPRequestOperation *operation, id responseObject, NSInteger tag) {
       // 如果没有自己的广告且需要显示腾讯广告（openThird = 1）时就显示腾讯广告
       NSArray *tempArray = [responseObject safeObjectForKey:@"ads"]; // 广告数据
       BOOL isNeedLoadTXAd = [[responseObject safeObjectForKey:@"openThird"] boolValue]; // 是否需要加载腾讯广告
       
       if ([tempArray isValidArray]) { // 加载自己的广告
           KKAdModel *adModel = [KKAdModel modelWithDictionary:tempArray.firstObject];
           adModel.requestId = [responseObject safeObjectForKey:@"reqId"];
           
           KKInsertBannerAd *insertBannerAd = [[KKInsertBannerAd alloc] initWithFrame:frame];
           insertBannerAd.delegate = delegate;
           insertBannerAd.adModel = adModel;
           insertBannerAd.containerViewController = containerViewController;
           [insertBannerAd loadAdAndShow];
           
           if (success) {
               success(insertBannerAd);
           }
       } else if (isNeedLoadTXAd) { // 加载腾讯广告
           GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithFrame:frame
                                                                           appkey:txAppKey
                                                                      placementId:txPlacementId];
           bannerView.delegate = delegate;
           bannerView.currentViewController = containerViewController;
           bannerView.isAnimationOn = NO;
           bannerView.showCloseBtn = YES;
           bannerView.isGpsOn = YES;
           [bannerView loadAdAndShow];
           [containerViewController.view addSubview:bannerView];
           
           if (success) {
               success(bannerView);
           }
       } else {
           if (failure) {
               failure();
           }
       }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger tag) {
        if (failure) {
            failure();
        }
    }];
}

#pragma mark - 工具

- (NSURL *)url {
    return [UrlManager getRequestUrlByNameSpace:Request_Ad_NameSpace
                                     methodName:[BaseNetworkViewController getRequestURLStr:0]];
}

- (NSDictionary *)parameterDicWithPlacementId:(NSString *)placementId {
    /*
     platform	string	平台 ios android
     appId	string	应用ID
     uuid	string	用户唯一标识
     imei	string	手机IMEI号
     placeCode	string	广告位置代码
     */
    return @{@"platform": @"ios",
             @"appId": @"yingyu1",
             @"uuid": @"",
             @"placeCode": [placementId isValidString] ? placementId : @""};
}

- (void)presentViewControllerWithRootViewController:(UIViewController *)rootViewController adModel:(KKAdModel *)adModel animated:(BOOL)flag completion:(void (^)(void))completion {
    if (rootViewController) {
        switch (adModel.targetType) {
            case 1: {
                BaseWebViewController *webController = [[BaseWebViewController alloc] initWithUrl:[NSURL URLWithString:adModel.contentStr]];
                [rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:webController]
                                                 animated:flag
                                               completion:completion];
            }
                break;
            case 2: {
                // 如果是竖屏就跳内部，横屏就跳APP，横屏present SKStoreProductViewController会崩溃
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
                    storeProductVC.delegate = self;
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:adModel.contentStr
                                                                     forKey:SKStoreProductParameterITunesItemIdentifier];
                    [storeProductVC loadProductWithParameters:dict
                                              completionBlock:^(BOOL result, NSError *error) {
                                              }];
                    [rootViewController presentViewController:storeProductVC
                                                     animated:flag
                                                   completion:completion];
                } else {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", adModel.contentStr]];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                        
                        if (completion) {
                            completion();
                        }
                    }
                }
            }
                break;
            case 3: {
                
            }
            case 4: {
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - SKStoreProductViewControllerDelegate methods

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
}

@end
