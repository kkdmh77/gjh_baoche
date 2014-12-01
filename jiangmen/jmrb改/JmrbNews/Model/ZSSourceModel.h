//
//  ZSSourceModel.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-8.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSourceModel : NSObject

+ (id)defaultSource;
@property (nonatomic, retain) NSMutableDictionary *adsDataDic;
@property (nonatomic, retain) NSMutableDictionary *newsListDataDic;
@property (nonatomic, retain) NSMutableDictionary *newsDataDic;
@property (nonatomic, retain) NSMutableDictionary *commentDataDic;
@property (nonatomic, retain) NSMutableDictionary *newsTypeDataDic;
@property (nonatomic, retain) NSMutableArray *hotPictureDic;
@property (nonatomic, retain) NSMutableArray *hotVideoDic;
@property (nonatomic, retain) NSMutableArray *specialDic;
@property (nonatomic, retain) NSMutableArray *specialContentDic;
@property (nonatomic, retain) NSMutableArray *votelistDic;
@property (nonatomic, retain) NSMutableArray *KeepArray;
@property (nonatomic, retain) NSMutableDictionary *moreNewsAdsDic;
@property (nonatomic, retain) NSMutableArray *newsListAdsArray;
@property (nonatomic, retain) NSMutableArray *succlogininfoArray;
@property (nonatomic, retain) NSMutableDictionary *newsOrderSequenceDic;
@property (nonatomic, retain) NSMutableDictionary *logCommunicationDic;
@property (nonatomic, retain) NSDictionary *succLoginDic;
@property (nonatomic, retain) NSDictionary *hotVideoLiveDic;
@property (nonatomic, assign) double downLoadSummary;


- (void)createPlist;
- (void)writePlist;
- (void)readPlist;
- (void)collectDownLoadDataSummary;

@end
