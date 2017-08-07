//
//  KKeyDefine.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/11/13.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#ifndef KKeyDefine_h
#define KKeyDefine_h

#define TABBAR_HEIGHT                       49        // TabBar高度
#define STATUS_BAR_HEIGHT                   20        // 状态栏高度
#define NAV_BAR_HEIGHT                      44        // 导航栏高度
#define IIDeckViewLeftSize                  40
#define ThinLineWidth                       0.5       // 细的线宽值
#define LineWidth                           1.0       // 全局线宽值  适用范围:cell的分割线、视图边框线宽
#define CellSeparatorSpace                  10        // 全局       tab中cell之间的分割距离
#define NotLoginStatusErrorCode             -10001    // 登陆的状态.10000:已登录,正常状态, -10001:未登陆或者登陆session已过期
#define RemoteNotificationIntervalTime      60 * 10   // 刷新远程推送数字的间隔时间: 10分钟
#define HUDAutoHideTypeShowTime             2.5       // HUD自动隐藏模式显示的时间:2.5秒
#define AnimationShowTime                   0.25      // 常见动画的持续时间:0.25秒
#define KeyboardHeight                      252       // 键盘的高度

/**************************** 统计 & 分享 ********************************/

/*
 极光推送：
 AppKey:063cbe4ed8b61e2b86a544eb
 Master Secret:a20cdf480e8152da5cebb587
 */

#define kUMengAppKey       @"58f38349cae7e771a600168d"

#define kWeiXinKey         @"wx740a9727e0e59866"
#define kWeiXinSecret      @"8254c2d4610f993932ef897355ee6e68"
#define kWeixinUrl         kAppDownloadUrl

#endif /* KKeyDefine_h */
