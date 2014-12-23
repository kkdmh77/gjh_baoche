//
//  BaseNetworkViewController+NetRequestManager.m
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController+NetRequestManager.h"

@implementation BaseNetworkViewController (NetRequestManager)

+ (NSString*) getRequestURLStr:(NetRequestType)requestType
{
    // 与"NetProductRequestType"一一对应
    static NSMutableArray *urlForTypeArray = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeArray = [NSMutableArray arrayWithObjects:
                           // 新闻
                           @"getNewsType.action",
                           @"getNewsList.action",
                           @"getAds.action",
                           
                           @"getNews.action",
                           @"getComment.action",
                           @"addComment.action",
                           
                           // 图片
                           @"getHotNewsPic.action",
                           
                           // 视频
                           @"getVideoInfor.action",
                           
                           // 用户中心
                           @"logon.action",
                           @"addUser.action",
                           
                           nil];
    });
    
    return urlForTypeArray[requestType];
}

@end
