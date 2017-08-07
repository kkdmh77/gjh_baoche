//
//  AnalyticsIDManager.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/5/3.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "AnalyticsIDManager.h"
#import "LearningBookVocabularyListVC.h"
#import "LearningAllSectionInUnitVC.h"
#import "LoginForPlatformVC.h"
#import "UserInfoVC.h"
#import "DownloadPackageVC.h"
#import "SettingViewController.h"
#import "RecommendedProductVC.h"
#import "UMFeedbackViewController.h"
#import "AboutViewController.h"

@implementation AnalyticsIDManager

+ (NSDictionary<NSString *,NSString *> *)idsDic
{
    static NSDictionary<NSString *,NSString *> *idsDic = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        idsDic = @{@"jumpToGradeControl:":                                  @"home_change_book_click",          // 主页-点击切换课本
                   @"jumpToSearchControl:":                                 @"home_search_click",               // 主页-点击搜索
                   @"clickUnitDetailBtn:":                                  @"home_unit_block_list_click",      // 主页-显示blosk列表
                   NSStringFromClass([LearningBookVocabularyListVC class]): @"home_vocabulary_list_resume",     // 主页-显示单词总表
                   @"clickCenterActionBtn:":                                @"camera_page_click",               // 拍照-拍内页
                   NSStringFromClass([LearningAllSectionInUnitVC class]):   @"home_all_unit_resume",            // 主页-显示section列表
                   NSStringFromClass([LoginForPlatformVC class]):           @"mine_login_for_platform_resume",  // 我的-显示平台登录
                   NSStringFromClass([UserInfoVC class]):                   @"mine_user_info_resume",           // 我的-显示用户资料编辑
                   NSStringFromClass([DownloadPackageVC class]):            @"mine_download_package_resume",    // 我的-显示功能包下载
                   NSStringFromClass([SettingViewController class]):        @"mine_setting_resume",             // 我的-显示设置
                   @"themeStyleSwithHandle:":                               @"mine_theme_style_switch_click",   // 我的-点击日间夜间模式切换
                   NSStringFromClass([RecommendedProductVC class]):         @"mine_recommended_product_resume", // 我的-显示推荐应用
                   @"clickClearHistoryBtn:":                                @"search_clear_history_click",      // 搜索-点击清除搜索历史
                   @"clickFlashStatusBtn:":                                 @"camera_flash_status_click",       // 拍照-点击闪光灯
                   NSStringFromClass([UMFeedbackViewController class]):     @"set_feedback_resume",             // 设置-显示用户反馈
                   NSStringFromClass([AboutViewController class]):          @"set_about_resume",                // 设置-显示关于
                   @"clickSkipBtn:":                                        @"guide_start_use_app",             // 用户引导-点击开始
                   @"cameraBtnPress:":                                      @"set_book_camera_button_click",    //设置教材-拍照按钮
                   @"changeBookBtnPress:":                                  @"set_book_change_button_click",    //教材选择-切换教材按钮
                   @"wordBtnPress:":                                        @"mybook_bookword",                 //我的课本-单词表
                   @"downloadBtnPress:":                                    @"mybook_download_textbook",        //我的课本-下载离线包
                   @"continuousBtnPress:":                                  @"page_continuous_click",           //课文学习_连读
                   @"followReadingBtnPress:":                               @"page_follow_click",               //课文学习_跟读
                   @"translateBtnPress:":                                   @"page_translate_click",            //课文学习_翻译
                   @"voiceBtnPress:":                                       @"wordlist_voice",                  //单词列表_读音
                   @"feedbackBtnPress:":                                    @"set_book_nobook_button_click",    //教材选择-找不到教材
                   @"offlineButtonPress:":                                  @"set_book_download_package",       //教材选择-下载离线教材
                   @"onlineButtonPress:":                                   @"set_book_online_read",            //教材选择-在线阅读
                   @"bgDownloadBtnPress:":                                  @"set_book_download_loading_background_click"  //教材选择-loading页-后台下载
                   };
    });
    
    return idsDic;
}

@end
