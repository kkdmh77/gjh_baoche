//
//  AnalyticsIDManager.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/5/3.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define set_read_at_cellular_switch_on_click     @"set_read_at_cellular_switch_on_click"    // 设置-开启移动数据朗读
#define set_read_at_cellular_switch_off_click    @"set_read_at_cellular_switch_off_click"   // 设置-关闭移动数据朗读
#define set_clear_cache_click                    @"set_clear_cache_click"                   // 设置-清除缓存
#define set_encourage_resume                     @"set_encourage_resume"                    // 设置-鼓励我们
#define set_share_click                          @"set_share_click"                         // 设置-好友分享
#define set_share_email_click                    @"set_share_email_click"                   // 设置-邮件分享
#define set_share_sina_click                     @"set_share_sina_click"                    // 设置-新浪微博分享
#define set_share_wechat_click                   @"set_share_wechat_click"                  // 设置-微信分享
#define set_share_timeline_click                 @"set_share_timeline_click"                // 设置-微信朋友圈分享
#define set_share_qq_click                       @"set_share_qq_click"                      // 设置-QQ分享
#define set_share_qzone_click                    @"set_share_qzone_click"                   // 设置-QQ空间分享
#define download_pronunciation_to_download       @"download_pronunciation_to_download"      // 功能包下载-下载朗读包
#define download_pronunciation_to_update         @"download_pronunciation_to_update"        // 功能包下载-更新朗读包
#define download_pronunciation_to_delete         @"download_pronunciation_to_delete"        // 功能包下载-删除朗读包
#define download_textbook_to_download            @"download_textbook_to_download"           // 教材包下载-下载教材包
#define download_textbook_to_update              @"download_textbook_to_update"             // 教材包下载-更新教材包
#define download_textbook_to_delete              @"download_textbook_to_delete"             // 教材包下载-删除教材包
#define camera_barcode_type_click                @"camera_barcode_type_click"               // 拍照扫描-二维码扫描
#define camera_textbook_type_click               @"camera_textbook_type_click"              // 拍照扫描-拍封面
#define search_word_detail_resume                @"search_word_detail_resume"               // 搜索-从搜索跳转到单词详情
#define mine_login_of_wechat_click               @"mine_login_of_wechat_click"              // 我的-微信登录
#define mine_login_of_sina_click                 @"mine_login_of_sina_click"                // 我的-新浪微博登录
#define mine_login_of_qq_click                   @"mine_login_of_qq_click"                  // 我的-QQ登录
#define mine_login_of_kk_click                   @"mine_login_of_kk_click"                  // 我的-快快查登录
#define guide_skip_click                         @"guide_skip_click"                        // 用户引导-点击跳过
#define camera_scan_page                         @"camera_scan_page"                        // 拍照-拍内页
#define camera_scan_textbook                     @"camera_scan_textbook"                    // 拍照-拍封面
#define camera_scan_barcode                      @"camera_scan_barcode"                     // 拍照-扫条码
#define tab_bar_select_index_0                   @"tab_bar_select_index_0"                  // tabbar-选择学习
#define tab_bar_select_index_1                   @"tab_bar_select_index_1"                  // tabbar-选择我的
#define mine_recommended_product_zidian_resume   @"mine_recommended_product_zidian_resume"  // 我的-推荐应用-显示字典
#define mine_recommended_product_shici_resume    @"mine_recommended_product_shici_resume"   // 我的-推荐应用-显示诗词
#define mine_recommended_product_zhongxue_resume @"mine_recommended_product_zhongxue_resume"// 我的-推荐应用-显示中学版
#define homepage_searchword_button_click         @"homepage_searchword_button_click"        // 主页-单词查询
#define homepage_learningbook_button_click       @"homepage_learningbook_button_click"      // 主页-课本点读
#define homepage_rememberword_button_click       @"homepage_rememberword_button_click"      // 主页-记背单词

#define page_playvideo_button_continuous_click_disable  @"page_playvideo_button_continuous_click_disable"   //句子朗读-连读-禁用状态点击
#define page_playvideo_button_continuous_click_enable	@"page_playvideo_button_continuous_click_enable"    //句子朗读-连读-非禁用状态点击
#define page_playvideo_button_follow_click_disable      @"page_playvideo_button_follow_click_disable"       //句子朗读-跟读-禁用状态点击
#define page_playvideo_button_follow_click_enable       @"page_playvideo_button_follow_click_enable"        //句子朗读-跟读-非禁用状态点击
#define page_playvideo_button_list_click_disable        @"page_playvideo_button_list_click_disable"         //句子朗读-列表-禁用状态点击
#define page_playvideo_button_list_click_enable         @"page_playvideo_button_list_click_enable"          //句子朗读-列表-非禁用状态点击
#define page_playvideo_button_translate_click_disable	@"page_playvideo_button_translate_click_disable"    //句子朗读-翻译-禁用状态点击
#define page_playvideo_button_translate_click_enable	@"page_playvideo_button_translate_click_enable"     //句子朗读-翻译-非禁用状态点击
#define page_playvideo_button_pause_click_list          @"page_playvideo_button_pause_click_list"           //句子朗读-列表-暂停
#define page_playvideo_button_pause_click_page          @"page_playvideo_button_pause_click_page"           //句子朗读-图片-暂停

#define book_directory_click                            @"book_directory_click"                             //课本-目录表点击
#define book_phrase_click                               @"book_phrase_click"                                //课本-短语表点击
#define book_word_click                                 @"book_word_click"                                  //课本-单词表点击

#define word_detail_avo                                 @"word_detail_avo"                                  //单词详情-美式发音
#define word_detail_evo                                 @"word_detail_evo"                                  //单词详情-英式发音

#define word_detail_example_sentence_off                @"word_detail_example_sentence_off"                 //单词详情-例句收起
#define set_book_select_jefc                            @"set_book_select_jefc"                             //教材设置-初中
#define set_book_select_sefc                            @"set_book_select_sefc"                             //教材设置-高中
#define set_book_select_jefc_renjiao                    @"set_book_select_jefc_renjiao"                     //教材设置-初中-人教
#define set_book_select_jefc_yilin                      @"set_book_select_jefc_yilin"                       //教材设置-初中-牛津
#define set_book_select_sefc_renjiao                    @"set_book_select_sefc_renjiao"                     //教材设置-高中-人教

#define wordlist_worddetail                             @"wordlist_worddetail"                              //单词列表_单词详情
#define set_book_download_loading_wordcard_click        @"set_book_download_loading_wordcard_click"         //教材选择-loading页-单词卡片
#define set_book_select_count                           @"set_book_select_count"                            //教材设置-数量统计

#define picture_to_download                             @"picture_to_download"                              // 绘本列表-下载离线包

@interface AnalyticsIDManager : NSObject

/**
 * @method 统计事件的ID
 * @param  无
 * @return IDs{key: 控制器类名、或者UIControl的方法名, value: ID}
 * @创建人  龚俊慧
 * @creat  2016-05-03
 */
+ (NSDictionary<NSString *, NSString *> *)idsDic;

@end
