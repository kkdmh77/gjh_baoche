//
//  KKInsertBannerAd.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/2.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAdModel.h"
#import "KKAdPublic.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * banner条广告
 */
@class KKInsertBannerAd;

@protocol KKInsertBannerAdDelegate <NSObject>

@optional

/**
 *  请求banner条数据成功后调用
 */
- (void)kkInsertBannerViewLoadSuccess:(KKInsertBannerAd *)insertBannerAd;

/**
 *  请求banner条数据失败后调用
 */
- (void)kkInsertBannerViewLoadFailed:(KKInsertBannerAd *)insertBannerAd withError:(NSError *)error;

/**
 *  banner条将要关闭回调
 */
- (void)kkInsertBannerViewWillClosed:(KKInsertBannerAd *)insertBannerAd closeType:(KKAdClosedType)type;

/**
 *  banner条已经被关闭回调
 */
- (void)kkInsertBannerViewDidClosed:(KKInsertBannerAd *)insertBannerAd closeType:(KKAdClosedType)type;

/**
 *  banner条点击回调
 */
- (void)kkInsertBannerViewClicked:(KKInsertBannerAd *)insertBannerAd;

/**
 *  点击banner条广告以后即将弹出全屏广告页
 */
- (void)kkInsertBannerViewWillPresentFullScreenModal:(KKInsertBannerAd *)insertBannerAd;

/**
 *  点击banner条广告以后弹出全屏广告页
 */
- (void)kkInsertBannerViewDidPresentFullScreenModal:(KKInsertBannerAd *)insertBannerAd;

@end

@interface KKInsertBannerAd : UIView
/**
 *  父视图
 *  详解：[必选]需设置为显示广告的UIViewController
 */
@property (nonatomic, weak) UIViewController *containerViewController;

@property (nonatomic, weak) id<KKInsertBannerAdDelegate> delegate;

/// 必选
@property (nonatomic, strong) KKAdModel *adModel;

/**
 *  Banner条展示关闭按钮，默认打开
 */
@property (nonatomic, assign) BOOL showCloseBtn;

/**
 *  拉取并展示广告
 */
- (void)loadAdAndShow;

@end

NS_ASSUME_NONNULL_END
