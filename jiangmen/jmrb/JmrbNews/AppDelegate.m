//
//  AppDelegate.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AppDelegate.h"
#import "ZSCommunicateModel.h"
#import "ZhongShangContant.h"
#import "ZSSourceModel.h"
#import "Reachability.h"
#import "ImageContant.h"
#import "WBEngine.h"
#import "YungShareManager.h"
//#import "MobClick.h"
//#import "UIImageView+WebCache.h"
#import "CommonUtil.h"
#import "BaseTabBarVC.h"
#import "AppPropertiesInitialize.h"
#import "NewsManagerVC.h"
#import "ImageNewsListVC.h"
#import "VideoNewsListVC.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "UserInfoModel.h"

@interface AppDelegate(Private)

- (void)getStartData;

@end

@implementation AppDelegate
@synthesize startLoadNum;
@synthesize window = _window;

CG_INLINE  void deleteFile() {
//    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *searchPaths = NSTemporaryDirectory();
//    NSString *ZSRBfilePath = [NSString stringWithFormat:@"%@/ZhongShanRiBao",searchPaths];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:ZSRBfilePath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:ZSRBfilePath error:nil];
//    }
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *pathString = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [pathString appendString:fileName_ZhongShanRiBao_PNG];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
        [[NSFileManager defaultManager] removeItemAtPath:pathString error:nil];
    }
}

- (void)shareLogOut {
    [[YungShareManager defaultShare] clickLogOut];
}

- (void)releaseAll {
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    [[ZSSourceModel defaultSource] release];
    [[ZSCommunicateModel defaultCommunicate] release];
    [_loadBgImageView release];
    [_rootManager.view removeFromSuperview];
    [_rootManager release];
    [_loadingView release];
    [_activityView release];
    [_window release];
    
}

#pragma mark - Private
- (void)getStartData {
    _isEverLoad = YES;
    NSMutableDictionary *dic = nil;
    //获取新闻类别
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNewsType forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release]; 
    
    //获取焦点广告
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getAds forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    
    //获取列表新闻下广告
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_NewsListAdsShow forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    
//    //获取更多页面广告
//    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dic setObject:Web_moreAds forKey:Web_Key_urlString];
//    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//    [dic release];
    //           
    
//    //获取图片新闻
//    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dic setObject:Web_getHotPictureNews forKey:Web_Key_urlString];
//    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//    [dic release];
}

#pragma mark - Public
- (BOOL)isLoading {
    return [_activityView isAnimating];
}

- (void)tarBarStartLoading {
    [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.01]];
    [_activityView startAnimating];
    [self.window addSubview:_loadingView];
}

- (void)startLoading {
//    if (startLoadNum == 0) {
//        NSLog(@"send time:%@",[NSDate date]);
//    }
    [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3]];
    [_activityView startAnimating];
    [self.window addSubview:_loadingView];
}

- (void)stopLoading {
//    if (startLoadNum == 0) {
//        NSLog(@"receive time:%@",[NSDate date]);
//    }
    startLoadNum++;
    if (startLoadNum == 1 ) {        
        if ([_loadBgImageView alpha] > .2) {
            [UIView animateWithDuration:2 animations:^{
                [_loadBgImageView setAlpha:0]; 
            }];
        }
    }
    
    if (startLoadNum >= 5) {
//        NSTimeInterval late=[startnsDate timeIntervalSince1970]*1;
//        
//        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//        NSTimeInterval now=[dat timeIntervalSince1970]*1;
//        NSTimeInterval cha=now-late;
//        if (cha<3) {
//           // Sleep(2000);
//        }
        startLoadNum = 5;
        [_activityView setCenter:CGPointMake(160, 240)];
        [_loadBgImageView removeFromSuperview];
        [_activityView stopAnimating];
        [_loadingView removeFromSuperview];
        
        
    }
}


- (void) alertTishi:(NSString *) title detail:(NSString *) detail{
    
    hud = [[MBProgressHUD alloc] init];
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Errormark_.png"]] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    //HUD.delegate = self;
    hud.labelText = title;
    hud.labelFont = [UIFont boldSystemFontOfSize:14.0f];
    hud.detailsLabelText=detail;
    [self.window addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    
}


- (void) alertTishiSucc:(NSString *) title detail:(NSString *) detail{
    
    hud = [[MBProgressHUD alloc] init];
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    //HUD.delegate = self;
    //hud.mode=Mb
    hud.labelText = title;
    hud.labelFont = [UIFont boldSystemFontOfSize:14.0f];
    hud.detailsLabelText=detail;
    [self.window addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_loadBgImageView release];
    [_loadingView release];
    [_activityView release];
    [_rootManager release];
    [_window release];
    [hud release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [super dealloc];
}

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx4a5daec79d057d08"
                           appSecret:@"2ee5f23195aae0958901ee60ed55e531"
                           wechatCls:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [UserInfoModel setUserDefaultUserId:nil];
    [UserInfoModel setUserDefaultMobilePhoneNum:nil];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"4ad84fc80ed4"];
    [self initializePlat];
    
    NewsManagerVC *newsManager = [[[NewsManagerVC alloc] init] autorelease];
    UINavigationController *newsManagerNav = [[[UINavigationController alloc] initWithRootViewController:newsManager] autorelease];
    
    ImageNewsListVC *imageNewsList = [[[ImageNewsListVC alloc] init] autorelease];
    UINavigationController *imageNewsListNav = [[[UINavigationController alloc] initWithRootViewController:imageNewsList] autorelease];
    
    VideoNewsListVC *videoNewsList = [[[VideoNewsListVC alloc] init] autorelease];
    UINavigationController *videoNewsListNav = [[[UINavigationController alloc] initWithRootViewController:videoNewsList] autorelease];
    
    BaseTabBarVC *baseTabBarController = [[[BaseTabBarVC alloc] init] autorelease];
    baseTabBarController.viewControllers = @[newsManagerNav, imageNewsListNav, videoNewsListNav, [UIViewController new]];
    
    self.window.rootViewController = baseTabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
    
    /*
    //推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    UIImage *image;
    if (iPhone5) {
        image = [UIImage imageByName:@"default568" withExtend:@"png"];
    }else{
        image = [UIImage imageByName:@"default" withExtend:@"png"];
    }
    _loadBgImageView=[[UIImageView alloc] init];
    if([standardUserDefault valueForKey:Key_Loading_url] !=nil){
        NSString * strurl=[NSString stringWithFormat:@"%@%@",Web_URL,[standardUserDefault valueForKey:Key_Loading_url]];
        image = [imageQueue getImageForURL:strurl];
        //[strurl appendFormat:@"?%f", 1000*[[NSDate date] timeIntervalSince1970]];
        if (!image) {
            image = [UIImage imageNamed:@"default" ];
            [imageQueue addOperationToQueueWithURL:strurl atIndex:0];
        }
    }
    [_loadBgImageView setImage:image];
    startnsDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    
    //    Reachability *reach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
//    [reach startNotifer];
    
 //   [MobClick startWithAppkey:@"4fe9b056527015056d000002"];
//    [MobClick startWithAppkey:@"4fe9b056527015056d000002" reportPolicy:REALTIME channelId:nil];
 //   [MobClick checkUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStartData) name:Notification_WebServerTime object:nil];
   
    NSString *deviceIdString = [standardUserDefault objectForKey:Key_deviceId];
    if (deviceIdString == nil || [deviceIdString length] == 0) {
        CFUUIDRef deviceId = CFUUIDCreate (NULL);   
        CFStringRef deviceIdStringRef = CFUUIDCreateString(NULL,deviceId);
        CFRelease(deviceId);
        deviceIdString = (__bridge NSString *)deviceIdStringRef;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尊敬的中山日报客户" message:@"本程序将会使用你的UDID作为统计使用" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        deviceIdString = [[UIDevice currentDevice] uniqueIdentifier];
        [standardUserDefault setValue:deviceIdString forKey:Key_deviceId];
        [deviceIdString release];
        [standardUserDefault synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"17" forKey:Font_NewsInfoContent];
    NSInteger status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (status == 0) {
//#ifdef Web_Connect_Have
//        return NO;
//#endif
    }
    startLoadNum = 0;
    _isEverLoad = NO;
    loadingNum = 0;
    if (iPhone5) {
         _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
         _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
   
    [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3]];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityView setCenter:CGPointMake(160, 280)];
    [_loadingView addSubview:_activityView];
    
    [[ZSSourceModel defaultSource] readPlist];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    _rootManager = [[RootManager alloc] init];
    [self.window addSubview:_rootManager.view];
    

    if (iPhone5) {
        [_loadBgImageView setFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        [_loadBgImageView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
   
    [self.window addSubview:_loadBgImageView];
    [_activityView startAnimating];
    
    NSNumber *readModel = [[NSUserDefaults standardUserDefaults] objectForKey:More_ReadModel];
    if (readModel == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:More_ReadModel];
    }
    
    //测试用按钮
//    UIButton *btnRelease = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnRelease setFrame:CGRectMake(100, 100, 100, 100)];
//    [btnRelease addTarget:self action:@selector(releaseAll) forControlEvents:UIControlEventTouchUpInside];
//    [self.window addSubview:btnRelease];
    
    //保存uuid到设置里面
//    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
//    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
//    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
//    NSMutableDictionary *settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
//    NSMutableArray *array = [settingsDict objectForKey:@"PreferenceSpecifiers"];
//    NSMutableDictionary *dic = [array objectAtIndex:1];
//    NSString *uuidString = [standardUserDefault objectForKey:Key_deviceId];
//    [dic setObject:[uuidString substringToIndex:[uuidString length]/2] forKey:@"DefaultValue"];  
//    dic = [array objectAtIndex:2];
//    [dic setObject:[uuidString substringFromIndex:[uuidString length]/2] forKey:@"DefaultValue"];
//    [settingsDict writeToFile:finalPath atomically:YES];
    
    return YES;
     */
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setValue:[NSString stringWithFormat:@"%f",[[ZSSourceModel defaultSource] downLoadSummary]] forKey:Define_DownLoadDataSummary];
    [[ZSSourceModel defaultSource] writePlist];
    
//    deleteFile();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
    [[ZSSourceModel defaultSource] setDownLoadSummary:[[[NSUserDefaults standardUserDefaults] objectForKey:Define_DownLoadDataSummary] doubleValue]];
    [[ZSSourceModel defaultSource] collectDownLoadDataSummary];
    
    static BOOL startload = 1;
    if (startload) {
        startload = 0;
        startLoadNum = 0;
        [_loadBgImageView setAlpha:1];
        [self.window addSubview:_loadBgImageView];
        NSInteger testDay,currentDay;
        NSString *dateTest = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTest"];
        if (dateTest==nil||[dateTest length]==0) {
            NSDate *date = [NSDate date];
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSString *dateStringTemplate = @"YYMMdd";
            [dateFormatter setDateFormat:dateStringTemplate];
            dateTest = [dateFormatter stringFromDate:date];
            [dateFormatter release];
            [[NSUserDefaults standardUserDefaults] setObject:dateTest forKey:@"dateTest"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            testDay = [dateTest intValue];
            currentDay = testDay;
        }
        else {
            NSDate *date = [NSDate date];
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSString *dateStringTemplate = @"YYMMdd";
            [dateFormatter setDateFormat:dateStringTemplate];
            currentDay = [[dateFormatter stringFromDate:date] intValue];
            testDay = [dateTest intValue];
            [dateFormatter release];
        }
        if (currentDay-testDay>=1) {
            deleteFile();
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", currentDay] forKey:@"dateTest"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self performSelector:@selector(shareLogOut) withObject:nil afterDelay:1];
        NSInteger status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if (status == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请连接网络" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [alert show];
//            [alert release];
        }
        else {
            if (_isEverLoad == NO || startLoadNum < 6) {            
                //获取与服务器的时间撮差值
                NSMutableDictionary *dic = nil;
                dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                [dic setObject:Web_ServerTime forKey:Web_Key_urlString];
                [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
                [dic release];
            }
        }
    }
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ZSSourceModel defaultSource] writePlist];
//    deleteFile();
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    NSLog(@"regisger success:%@",pToken);
    //注册成功，将deviceToken保存到应用服务器数据库中
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail%@",error);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [_loadBgImageView setImage:_image];
}

@end
