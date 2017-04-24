//
//  KColorDefine.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/11/13.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#ifndef KColorDefine_h
#define KColorDefine_h

#define kCurThemeColor          [UserInfoModel sharedInstance].isNightThemeStyle ? Common_ThemeColor_Night : Common_ThemeColor

/**************************** 日间模式 ********************************/

// 文字颜色
#define Common_BlackColor              HEXCOLOR(0X3D3D3D)   // 黑色    适用范围:TAB的主标题
#define Common_LiteGrayColor           HEXCOLOR(0X999999)   // 浅灰色  适用范围:...
#define Common_YellowColor             HEXCOLOR(0XCEAD52)   // 黄色

#define NavTextColor                   HEXCOLOR(0X000000)   // 导航栏字体 黑色
#define TabBarTextColor                HEXCOLOR(0X000000)   // tabBar文字颜色 黑色
#define TextPlaceholderColor           HEXCOLOR(0X999999)   // 灰色

// 全局控件
#define PageBackgroundColor            HEXCOLOR(0X181818)   // 灰色  viewController的背景色
#define CellSeparatorColor             HEXCOLOR(0XD9D4CE)   // 灰色  tabViewCell的间隔线
#define CellBgColor                    HEXCOLOR(0XFFFFFF)   //
#define CellSelectedBgColor            HEXCOLOR(0XF5F3EF)   //
#define TabBarColor                    HEXCOLOR(0XF5F5F5)   // 灰色

#define Common_ThemeColor              HEXCOLOR(0XFFFFFF)   // 主题颜色 淡黄色

/**************************** 夜间模式 ********************************/

// 文字颜色
#define Common_BlackColor_Night        Common_BlackColor    // 银白色  适用范围:导航栏字体和大字体
#define Common_LiteGrayColor_Night     Common_LiteGrayColor // 浅灰色  适用范围:...
#define Common_YellowColor_Night       Common_YellowColor   // 黄色

#define NavTextColor_Night             NavTextColor         // 导航栏字体 白色
#define TabBarTextColor_Night          TabBarTextColor      // tabBar文字颜色 黑色
#define TextPlaceholderColor_Night     TextPlaceholderColor // 灰色

// 全局控件
#define PageBackgroundColor_Night      PageBackgroundColor  // 黑色  viewController的背景色
#define CellSeparatorColor_Night       CellSeparatorColor   // 黑色  tabViewCell的间隔线
#define CellBgColor_Night              CellBgColor          //
#define CellSelectedBgColor_Night      CellSelectedBgColor  //
#define TabBarColor_Night              TabBarColor          // 灰色

#define Common_ThemeColor_Night        Common_ThemeColor    // 主题颜色 墨色

#endif /* KColorDefine_h */
