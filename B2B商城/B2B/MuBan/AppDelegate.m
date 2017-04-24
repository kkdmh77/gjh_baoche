//
//  AppDelegate.m
//  rest_test
//
//  Created by swift on 15/1/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "AppDelegate.h"
#import "AppPropertiesInitialize.h"
#import "PRPAlertView.h"
#import "UrlManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "BaseNavigationController.h"
#import "ShopViewController.h"
#import "ServiceViewController.h"
#import "ProductViewController.h"
#import "ShareViewController.h"
#import "MineViewController.h"
#import "PDRCore.h"
#import "AFNetworkingTool.h"
#import "RequestParameterTool.h"
#import "KKAdManager.h"
// #import "KKDAnalytics.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GCDThread.h"

@interface AppDelegate () <NetRequestDelegate> {
    
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    NSDictionary *parameter = [RequestParameterTool parameterWithMethodName:@"system.init"];
    [AFNetworkingTool request:kUlrStr
                          tag:0
                   methodType:POST
                   parameters:[parameter modelToJSONString]
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSInteger tag) {
        [[UserInfoCache cache] setObject:[responseObject safeObjectForKey:@"appid"]
                                  forKey:kAppIdKey];
        [[UserInfoCache cache] setObject:[responseObject safeObjectForKey:@"appkey"]
                                  forKey:kMD5KeyKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, NSInteger tag) {
        
    }];
    
    // 统计
#ifndef DEBUG
    /*
    [[KKDAnalytics sharedInstance] startWithAppkey];
    [[KKDAnalytics sharedInstance] setAppVersion:APP_VERSION];
     */
#endif
    
    // 社会化分享
    [GCDThread enqueueBackground:^{
        [[UMSocialManager defaultManager] setUmSocialAppkey:kUMengAppKey];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                              appKey:kWeiXinKey
                                           appSecret:kWeiXinSecret
                                         redirectURL:kWeixinUrl];
        [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_WechatFavorite];
    }];
    
    // 控制器
    ShopViewController *shop = [[ShopViewController alloc] init];
    BaseNavigationController *shopNav = [[BaseNavigationController alloc] initWithRootViewController:shop];
    
    ServiceViewController *service = [[ServiceViewController alloc] init];
    BaseNavigationController *serviceNav = [[BaseNavigationController alloc] initWithRootViewController:service];
    
    ProductViewController *product = [[ProductViewController alloc] init];
    BaseNavigationController *productNav = [[BaseNavigationController alloc] initWithRootViewController:product];
    
    ShareViewController *share = [[ShareViewController alloc] init];
    BaseNavigationController *shareNav = [[BaseNavigationController alloc] initWithRootViewController:share];
    
    MineViewController *mine = [[MineViewController alloc] init];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mine];
    
    self.baseTabBarController = [[BaseTabBarVC alloc] init];
    self.baseTabBarController.viewControllers = @[shopNav, serviceNav, productNav, shareNav, mineNav];
    
    self.window.rootViewController = _baseTabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 请求广告页&tabBarItem等数据
//    @weakify(self);
//    [[KKAdManager sharedInstance] loadLaunchAdAndShowWithPlacementId:@""
//                                                            txAppKey:@""
//                                                       txPlacementId:@""
//                                                    placeholderImage:[UIImage new]
//                                                            inWindow:self.window
//                                                            delegate:nil
//                                             requestFailureAdNotShow:^{
//         
//     } success:^(id  _Nonnull toShowAdObj) {
//         [weak_self.baseTabBarController refreshTabItemAttributes:[UserInfoCache sharedInstance].tabBarItemModelArray];
//     }];
    
    // 设置当前SDK运行模式
    // 使用WebView集成时使用的启动参数
    return [PDRCore initEngineWihtOptions:launchOptions withRunMode:PDRCoreRunModeWebviewClient];
    
    // return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterBackground withObject:nil];
    
    [[UserInfoModel sharedInstance] saveGlobalUserInfoModel];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterForeGround withObject:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [[UserInfoModel sharedInstance] saveGlobalUserInfoModel];
}

#pragma mark -  URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self application:application handleOpenURL:url];
    
    return YES;
}

/*
 * @Summary:程序被第三方调用，传入参数启动
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventOpenURL withObject:url];
    
    return YES;
}

#pragma mark - /***************************推送相关***************************/

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // DLog(@"token = %@", deviceTokenStr);
    
    // 保存token值
    [UserInfoModel sharedInstance].deviceToken = deviceTokenStr;
    [self sendDeviceToken:deviceTokenStr];
    
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevDeviceToken withObject:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotificationWithApplication:application notification:userInfo];
    
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevRemoteNotification withObject:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self handleRemoteNotificationWithApplication:application notification:userInfo];
    
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevRemoteNotification withObject:userInfo];
}

////////////////////////////////////////////////////////////////////////////////

- (void)sendDeviceToken:(NSString *)deviceToken
{
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetUploadDeviceTokenRequestType_UploadDeviceToken]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceToken forKey:@"deviceToken"];
    [dic setObject:@"ios" forKey:@"deviceType"];
    if ([UserInfoModel sharedInstance].userInfo.userId)
    {
        [dic setObject:[UserInfoModel sharedInstance].userInfo.userId forKey:@"userId"];
    }
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:dic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:1000
                                           delegate:self
                                           userInfo:nil];
}

- (void)handleRemoteNotificationWithApplication:(UIApplication *)application notification:(NSDictionary *)userInfo
{
    NSDictionary *apsDic = [userInfo safeObjectForKey:@"aps"];
    
    NSString *alertBodyStr = [apsDic safeObjectForKey:@"alert"];
    NSNumber *commentId = [userInfo safeObjectForKey:@"id"];
    NSInteger type = [[userInfo safeObjectForKey:@"type"] integerValue];
    
    // 应用正在使用状态
    if (application.applicationState == UIApplicationStateActive)
    {
        // 弹窗提示再跳转
        WEAKSELF
        [PRPAlertView showWithTitle:@"推送信息"
                            message:alertBodyStr
                        cancelTitle:LocalizedStr(All_Cancel)
                        cancelBlock:^{
                            
                        } otherTitle:@"查看" otherBlock:^{
                            
                            [weakSelf pushToCommentDetailVCWithCommentId:commentId type:type];
                        }];
    }
    else
    {
        // 打开应用后直接跳转
        [self pushToCommentDetailVCWithCommentId:commentId type:type];
    }
    
    [UIFactory clearApplicationBadgeNumber];
}

// type 0: 晒单 1: 视频
- (void)pushToCommentDetailVCWithCommentId:(NSNumber *)commentId type:(NSInteger)type
{
    UIViewController *curSelectedController = [_baseTabBarController selectedViewController];
    
    if ([curSelectedController isKindOfClass:[UINavigationController class]])
    {
        if (0 == type)
        {
            /*
            CommentDetailVC *commentDetail = [[CommentDetailVC alloc] initWithCommentId:commentId.integerValue];
            commentDetail.isFromShareOrderVC = YES;
            commentDetail.hidesBottomBarWhenPushed = YES;
            
            [(UINavigationController *)curSelectedController pushViewController:commentDetail animated:YES];
             */
        }
        else if (1 == type)
        {
            
        }
    }
}

#pragma mark - NetRequestDelegate Methods

// 发生请求成功时
- (void)netRequest:(NetRequest *)request successWithDicInfo:(NSDictionary *)info
{
    NSLog(@"send the token success");
}

// 发送请求失败时
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    NSLog(@"send the token error : %@",error);
}

@end
