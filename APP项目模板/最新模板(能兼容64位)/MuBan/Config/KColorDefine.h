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
#define Common_BlackColor              HEXCOLOR(0X3D3D3D) // 黑色    适用范围:TAB的主标题
#define Common_LiteGrayColor           HEXCOLOR(0X999999) // 浅灰色  适用范围:...
#define Common_YellowColor             HEXCOLOR(0XCEAD52) // 黄色

#define NavTextColor                   HEXCOLOR(0X000000) // 导航栏字体 黑色

// 视图颜色
#define PageBackgroundColor            HEXCOLOR(0XF8F6F4) // 灰色  viewController的背景色
#define CellSeparatorColor             HEXCOLOR(0XD9D4CE) // 灰色  tabViewCell的间隔线
#define Common_ThemeColor              HEXCOLOR(0XFDFBF8) // 主题颜色 淡黄色
#define CellBgColor                    PageBackgroundColor //
#define CellSelectedBgColor            HEXCOLOR(0XF5F3EF) //

/**************************** 夜间模式 ********************************/

// 文字颜色
#define Common_BlackColor_Night        HEXCOLOR(0XF6F6F6) // 银白色  适用范围:导航栏字体和大字体
#define Common_LiteGrayColor_Night     HEXCOLOR(0X777777) // 浅灰色  适用范围:...
#define Common_YellowColor_Night       HEXCOLOR(0XCEAD52) // 黄色

#define NavTextColor_Night             HEXCOLOR(0XFFFFFF) // 导航栏字体 白色

// 视图颜色
#define PageBackgroundColor_Night      HEXCOLOR(0X1F1F1F) // 黑色  viewController的背景色
#define CellSeparatorColor_Night       HEXCOLOR(0X3C3C3C) // 黑色  tabViewCell的间隔线
#define Common_ThemeColor_Night        HEXCOLOR(0X292929) // 主题颜色 墨色
#define CellBgColor_Night              PageBackgroundColor_Night //
#define CellSelectedBgColor_Night      HEXCOLOR(0X262626) //

#endif /* KColorDefine_h */
