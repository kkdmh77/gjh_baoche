//
//  AppDelegate.m
//  rest_test
//
//  Created by swift on 15/1/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarVC.h"
#import "AppPropertiesInitialize.h"
#import "PRPAlertView.h"
#import "UrlManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface AppDelegate () <NetRequestDelegate>
{
    BaseTabBarVC *_baseTabBarController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    self.window.rootViewController = [UIViewController new];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
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
    
    [self sendDeviceToken:deviceTokenStr];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotificationWithApplication:application notification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self handleRemoteNotificationWithApplication:application notification:userInfo];
}

////////////////////////////////////////////////////////////////////////////////

- (void)sendDeviceToken:(NSString *)deviceToken
{
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetUploadDeviceTokenRequestType_UploadDeviceToken]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceToken forKey:@"token"];
    if ([UserInfoModel getUserDefaultUserId])
    {
        [dic setObject:[UserInfoModel getUserDefaultUserId] forKey:@"userId"];
    }
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:dic
                                         requestTag:1000
                                           delegate:self
                                           userInfo:nil];
}

- (void)handleRemoteNotificationWithApplication:(UIApplication *)application notification:(NSDictionary *)userInfo
{
    NSDictionary *apsDic = [userInfo safeObjectForKey:@"aps"];
    
    NSString *alertBodyStr = [apsDic safeObjectForKey:@"alert"];
    NSNumber *commentId = [userInfo safeObjectForKey:@"commentId"];
    
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
                            
                            [weakSelf pushToCommentDetailVCWithCommentId:commentId];
                        }];
    }
    else
    {
        // 打开应用后直接跳转
        [self pushToCommentDetailVCWithCommentId:commentId];
    }
}

- (void)pushToCommentDetailVCWithCommentId:(NSNumber *)commentId
{
    UIViewController *curSelectedController = [_baseTabBarController selectedViewController];
    
    if ([curSelectedController isKindOfClass:[UINavigationController class]])
    {
        /*
        CommentDetailVC *commentDetail = [[CommentDetailVC alloc] initWithCommentId:commentId.integerValue];
        commentDetail.isFromShareOrderVC = YES;
        commentDetail.hidesBottomBarWhenPushed = YES;
        
        [(UINavigationController *)curSelectedController pushViewController:commentDetail animated:YES];
         */
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
