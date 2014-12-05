//
//  BaseNetworkViewController+NetRequestManager.h
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef enum
{
    // 新闻
    NetNewsRequestType_GetAllNewsType                       = 0, // 获取新闻所有分类(GET)
    NetNewsRequestType_GetNewsList                             , // 获取普通新闻列表(POST)
    
    NetNewsRequestType_GetNewsDeatil                           , // 获取新闻详情(POST)
    
    // 图片
    NetImagesRequestType_GetImagesList                         , // 获取图片新闻列表(POST)
    
    // 视频
    NetVideosRequestType_GetVideosList                         , // 获取视频新闻列表(POST)
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

