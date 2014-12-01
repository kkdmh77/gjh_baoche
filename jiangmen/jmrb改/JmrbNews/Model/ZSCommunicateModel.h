//
//  ZSCommunicateModel.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-8.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhongShangContant.h"

@interface ZSCommunicateModel : NSObject<NSURLConnectionDelegate>{
    NSMutableData *_receiveData;
    BOOL _isBusy;
    NSString *_nowWeb;
    NSInteger nowNewStype;
    NSInteger nowSpecialContetNum;
    NSInteger hotPictureNum;
    NSInteger hotVideoNum;
    NSInteger voteNum;
    NSMutableDictionary *newsListNumDic;
    NSURLConnection *_urlConnection;
    NSInteger _responseCode;
    CGFloat timeBetweenServer;
}

@property (nonatomic, retain) UIImage *BLsendImage;
@property (nonatomic, retain) NSDictionary *BLsendDic;

+ (id)defaultCommunicate;
- (void)getWebData:(NSDictionary *)getDic;
- (void)sendBaoLiaoImage:(UIImage *)baoliaoImage Info:(NSDictionary *)getDic;
- (void)clearAllNewsList;
- (void)clearVoteList;
- (void)clearHotNewsList;
- (void)clearHotVideoList;
- (void)clearAllSpecialList;

@end


