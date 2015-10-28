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
#import "WaterPressureVC.h"
#import "PositioningVC.h"
#import "MonitoringStationsVC.h"
#import "SettingVC.h"
#import "CommonEntity.h"
#import "LoginVC.h"

@interface AppDelegate () <NetRequestDelegate>
{
    BaseTabBarVC *_baseTabBarController;
}

@end

@implementation AppDelegate

- (void)configureLocalData
{
    DataEntity *entityOne = [[DataEntity alloc] initWithNumber:@"001" nameStr:@"室外消防栓" position:@"奉化市滕头村内" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityTwo = [[DataEntity alloc] initWithNumber:@"002" nameStr:@"室外消防栓" position:@"奉化市江口民营科技园聚金路" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityThird = [[DataEntity alloc] initWithNumber:@"003" nameStr:@"室外消防栓" position:@"奉化市花鸟市场A区" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityFour = [[DataEntity alloc] initWithNumber:@"004" nameStr:@"室外消防栓" position:@"奉化市东郊开发区瑞峰路" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityFive = [[DataEntity alloc] initWithNumber:@"005" nameStr:@"室外消防栓" position:@"宁波市通途路与文化路交叉口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entitySix = [[DataEntity alloc] initWithNumber:@"006" nameStr:@"室外消防栓" position:@"宁波市康庄南路120号" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entitySeven = [[DataEntity alloc] initWithNumber:@"007" nameStr:@"室外消防栓" position:@"宁波市庄桥火车站门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityEight = [[DataEntity alloc] initWithNumber:@"008" nameStr:@"室外消防栓" position:@"宁波市海曙区环城西路电视台门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityNice = [[DataEntity alloc] initWithNumber:@"009" nameStr:@"室外消防栓" position:@"宁波市江东南路与道士堰路口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityTen = [[DataEntity alloc] initWithNumber:@"010" nameStr:@"室外消防栓" position:@"宁波市中兴路157号公安局门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityEleven = [[DataEntity alloc] initWithNumber:@"011" nameStr:@"室外消防栓" position:@"宁波市白鹤新村大门口左边" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    
    _tabDataArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:entityOne, entityTwo, entityThird, entityFour, entityFive, entitySix, entitySeven, entityEight, entityNice, entityTen, entityEleven, nil]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    [self configureLocalData];
    
    WaterPressureVC *waterPressure = [WaterPressureVC loadFromNib];
    waterPressure.title = @"实时水压";
    UINavigationController *waterPressureNav = [[UINavigationController alloc] initWithRootViewController:waterPressure];
    
    PositioningVC *positioning = [[PositioningVC alloc] init];
    positioning.title = @"位置定位";
    UINavigationController *positioningNav = [[UINavigationController alloc] initWithRootViewController:positioning];
    
    MonitoringStationsVC *monitoringStations = [[MonitoringStationsVC alloc] init];
    monitoringStations.title = @"监测点";
    UINavigationController *monitoringStationsNav = [[UINavigationController alloc] initWithRootViewController:monitoringStations];
    
    SettingVC *setting = [[SettingVC alloc] init];
    setting.title = @"基本设置";
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:setting];
    
    self.baseTabBarController = [[BaseTabBarVC alloc] init];
    _baseTabBarController.viewControllers = @[waterPressureNav, positioningNav, monitoringStationsNav, settingNav];
    
    // self.window.rootViewController = baseTabBarController;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginVC loadFromNib]];
    
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
    
    // 保存token值
    [UserInfoModel setUserDefaultDeviceToken:deviceTokenStr];
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
    [dic setObject:deviceToken forKey:@"deviceToken"];
    [dic setObject:@"ios" forKey:@"deviceType"];
    if ([UserInfoModel getUserDefaultUserId])
    {
        [dic setObject:[UserInfoModel getUserDefaultUserId] forKey:@"userId"];
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
