//
//  KKLaunchAd.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKBaseAd.h"
#import "KKAdModel.h"
#import "KKAdPublic.h"

NS_ASSUME_NONNULL_BEGIN
/*
 * 开屏广告
 */
@class KKLaunchAd;

@protocol KKLaunchAdDelegate <NSObject>

@optional

/**
 *  开屏广告成功展示
 */
-(void)kkLaunchAdLoadSuccess:(KKLaunchAd *)launchAd;

/**
 *  开屏广告展示失败
 */
-(void)kkLaunchAdLoadFailed:(KKLaunchAd *)launchAd withError:(NSError *)error;

/**
 *  开屏广告将要关闭回调
 */
- (void)kkLaunchAdWillClosed:(KKLaunchAd *)launchAd closeType:(KKAdClosedType)type;

/**
 *  开屏广告关闭回调
 */
- (void)kkLaunchAdDidClosed:(KKLaunchAd *)launchAd closeType:(KKAdClosedType)type;

/**
 *  开屏广告点击回调
 */
- (void)kkLaunchAdClicked:(KKLaunchAd *)launchAd;

/**
 *  点击开屏广告以后即将弹出全屏广告页
 */
- (void)kkLaunchAdWillPresentFullScreenModal:(KKLaunchAd *)launchAd;

/**
 *  点击开屏广告以后弹出全屏广告页
 */
- (void)kkLaunchAdDidPresentFullScreenModal:(KKLaunchAd *)launchAd;

@end

@interface KKLaunchAd : KKBaseAd

@property (nonatomic, weak) id<KKLaunchAdDelegate> delegate;

@property (nonatomic, assign) UIOffset skipBtnOffset; ///< 跳过按钮位置, 负值表示反方向值，5代表约束左边margin，-5表示约束右边的margin

/// 必选
@property (nonatomic, strong) KKAdModel *adModel;

/// 加载请求及展示广告（开屏广告用）
- (void)loadAdWithPlaceholderImage:(UIImage *)placeholderImage
                   andShowInWindow:(UIWindow *)window;

/// 加载请求及展示广告（全屏广告用）
- (void)loadAdWithPlaceholderImage:(UIImage *)placeholderImage
     presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
