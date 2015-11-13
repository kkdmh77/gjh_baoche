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
#define IIDeckViewLeftSize                  40
#define ThinLineWidth                       0.5       // 细的线宽值
#define LineWidth                           1.0       // 全局线宽值  适用范围:cell的分割线、视图边框线宽
#define CellSeparatorSpace                  10        // 全局       tab中cell之间的分割距离
#define NotLoginStatusErrorCode             -10001    // 登陆的状态.10000:已登录,正常状态, -10001:未登陆或者登陆session已过期
#define RemoteNotificationIntervalTime      60 * 10   // 刷新远程推送数字的间隔时间: 10分钟
#define HUDAutoHideTypeShowTime             2.5       // HUD自动隐藏模式显示的时间:2.5秒
#define AnimationShowTime                   0.25      // 常见动画的持续时间:0.25秒
#define KeyboardHeight                      252       // 键盘的高度

// 分享
#define Share_Content_Img_key                           @"share_Content_Img_key"
#define Share_Content_Text_key                          @"share_Text_Img_key"

// 网络
#define UserDefault_JustWifiKey                         @"userDefault_JustWifiKey"
#define UserDefault_NoPictureModeKey                    @"userDefault_NoPictureModeKey"

// 轮询
#define UserDefault_RemoteNotificationServiceTimeKey    @"userDefault_RemoteNotificationServiceTimeKey"
#define UserDefault_RemoteNotificationNewsIdKey         @"userDefault_RemoteNotificationNewsIdKey"
#define UserDefault_RemoteNotificationNewsTimeKey       @"userDefault_RemoteNotificationNewsTimeKey"
#define UserDefault_RemoteNotificationSurveyTimeKey     @"userDefault_RemoteNotificationSurveyTimeKey"

#define UserDefault_IsNotFirstLoadAnswerQuestionVCKey   @"UserDefault_IsNotFirstLoadAnswerQuestionVCKey" // 是否第一次登陆答题界面

#endif /* KKeyDefine_h */
