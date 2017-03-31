//
//  KKAdPublic.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/27.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KKAdCode) {
    /**
     * 初始化
     */
    REPORT_INIT = 100,
    /**
     * 请求返回的结果时，控件为null
     */
    RESPONSE_VIEW_NULL = 101,
    /**
     * 请求返回结果回调对象为null
     */
    RESPONSE_CALLBACK_NULL = 102,
    /**
     * 请求返回的结果为null
     */
    RESPONSE_NULL = 103,
    /**
     * 请求返回的结果码错误
     */
    RESPONSE_CODE_ERROR = 104,
    /**
     * 请求返回的结果-未知错误
     */
    RESPONSE_UNKNOWN_ERROR = 105,
    /**
     * 解密返回的数据错误
     */
    DECRYPT_STRING_ERROR = 106,
    
    /**
     * 解密前的原始数据长度不够
     */
    DECRYPT_STRING_LENGTH_SORT =107,
    /**
     * 返回的数据状态码错误
     */
    RESPONSE_STATUS_ERROR = 108,
    /**
     * 解析返回的数据错误
     */
    PARSE_JSON_ERROR =109,
    /**
     * 快快查广告的点击后，控件为null
     */
    CLICKED_KKC_VIEW_NULL = 110,
    /**
     * 快快查广告的点击后，数据为null
     */
    CLICKED_KKC_INFO_NULL =111,
    /**
     * 解析返回的数据完成
     */
    RESPONSE_JSON_OK =112,
    
    
    /**
     * 请求返回结果—开启第三方广告
     */
    START_SHOW_KKC = 201,
    /**
     * 快快查广告中跳过按钮的点击
     */
    SKIP_CLICKED_KKC =202,
    /**
     * 快快查广告的点击
     */
    ADS_CLICKED_KKC = 203,
    /**
     * 快快查广告自动关闭
     */
    AUTO_CLOSE_KKC =204,
    /**
     * 快快查广告关闭按钮点击
     */
    CLOSE_CLICKED =205,
    
    
    /**
     * 请求返回结果—开启第三方广告
     */
    START_SHOW_TX = 501,
    /**
     * 第三方广告中跳过按钮的点击
     */
    SKIP_CLICKED_TX =502,
    /**
     * 第三方广告的点击
     */
    ADS_CLICKED_TX = 503,
    /**
     * 第三方广告自动关闭
     */
    AUTO_CLOSE_TX =504,
    /**
     * 第三方广告关闭按钮点击
     */
    CLOSE_CLICKED_TX =505,
};

typedef NS_ENUM(NSInteger, KKAdClosedType) {
    /**
     * 点击跳过按钮
     */
    KKAdClosedType_Skip = 202,
    /**
     * 倒计时自动
     */
    KKAdClosedType_Auto = 204,
    /**
     * 点击叉叉
     */
    KKAdClosedType_CloseBtn = 205,
    /**
     * 点击广告
     */
    KKAdClosedType_ClickAd = 203,
};
