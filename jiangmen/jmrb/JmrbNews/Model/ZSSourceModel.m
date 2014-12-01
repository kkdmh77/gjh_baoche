//
//  ZSSourceModel.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-8.
//  Copyright (c) 2012年 XPG. All rights reserved.
//
#define ModelData_PlistName @"ModelData_PlistName.plist"
#define ModelData_NewsOrderSequece_PlistName @"ModelData_NewsOrderSequece_PlistName.plist"
#define ModelData_Log_Information_PlistName @"ModelData_Log_Information.plist"

#import "ZSSourceModel.h"


static ZSSourceModel *_default;

@implementation ZSSourceModel
@synthesize logCommunicationDic;
@synthesize moreNewsAdsDic;
@synthesize hotPictureDic;
@synthesize specialDic;
@synthesize specialContentDic;
@synthesize hotVideoDic;
@synthesize adsDataDic;
@synthesize commentDataDic;
@synthesize newsListDataDic;
@synthesize newsDataDic;
@synthesize newsTypeDataDic;
@synthesize KeepArray;
@synthesize newsListAdsArray;
@synthesize newsOrderSequenceDic;
@synthesize succLoginDic;
@synthesize downLoadSummary;

#pragma mark - Single
+ (id)alloc {
    if (!_default) {
        _default = [super alloc];
    }
    return _default;
}

- (id)init {
    if (!_default) {
        _default = [[ZSSourceModel alloc] init];
        _default.downLoadSummary = 0;
    }
    return _default;
}

+ (id)defaultSource {
    if (!_default) {
        _default = [[ZSSourceModel alloc] init];
    }
    return _default;
}

- (void)dealloc {
    [self setLogCommunicationDic:nil];
    [self setNewsOrderSequenceDic:nil];
    [self setMoreNewsAdsDic:nil];
    [self setAdsDataDic:nil];
    [self setCommentDataDic:nil];
    [self setNewsListDataDic:nil];
    [self setHotPictureDic:nil];
    [self setHotVideoDic:nil];
    [self setKeepArray:nil];
    [self setNewsDataDic:nil];
    [self setNewsTypeDataDic:nil];
    [self setNewsListAdsArray:nil];
    [super dealloc];
}

#pragma mark - Public

- (void)createPlist {
    NSFileManager *fileManager = nil;
    NSString *path = nil;
    fileManager = [NSFileManager defaultManager];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *ZSRBfilePath = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [ZSRBfilePath appendString:fileName_ZhongShanRiBao];
    if (![fileManager fileExistsAtPath:ZSRBfilePath]) {
        [fileManager createDirectoryAtPath:ZSRBfilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
//    NSString *ZSRBfilePath = NSTemporaryDirectory();
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath,ModelData_PlistName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath,ModelData_NewsOrderSequece_PlistName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[NSNumber numberWithInt:1] forKey:More_News_Order_Sequence_Max];
    [dic writeToFile:path atomically:YES];
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath,ModelData_Log_Information_PlistName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic writeToFile:path atomically:YES];
}

- (void)writePlist {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *ZSRBfilePath = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [ZSRBfilePath appendString:fileName_ZhongShanRiBao];
    
//    NSString *ZSRBfilePath = NSTemporaryDirectory();
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath,ModelData_PlistName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:KeepArray,@"keepArray", nil];
    [dic writeToFile:path atomically:YES];
    [dic release];
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath, ModelData_NewsOrderSequece_PlistName];
    [newsOrderSequenceDic writeToFile:path atomically:YES];
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath, ModelData_Log_Information_PlistName];
    [logCommunicationDic writeToFile:path atomically:YES];
}

- (void)readPlist {
    NSFileManager *fileManager = nil;
    NSString *path = nil;
    fileManager = [NSFileManager defaultManager];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *ZSRBfilePath = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [ZSRBfilePath appendString:fileName_ZhongShanRiBao];
    
//    NSString *ZSRBfilePath = NSTemporaryDirectory();
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath, ModelData_PlistName];
    if (![fileManager fileExistsAtPath:path]) {
        [self createPlist];
    }
    if (KeepArray == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [self setKeepArray:array];
        [array release];
    }
    [KeepArray removeAllObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [KeepArray addObjectsFromArray:[dic objectForKey:@"keepArray"]];
    [dic release];
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath ,ModelData_NewsOrderSequece_PlistName];
    if (![fileManager fileExistsAtPath:path]) {
        [self createPlist];
    }
    if (newsOrderSequenceDic == nil) {
        NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if ([orderDic objectForKey:More_News_Order_Sequence_Max] == nil) {
            [orderDic setObject:[NSNumber numberWithInt:1] forKey:More_News_Order_Sequence_Max];
        }
        [self setNewsOrderSequenceDic:orderDic];
        [orderDic release];
    }
    
    path = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath, ModelData_Log_Information_PlistName];
    if (![fileManager fileExistsAtPath:path]) {
        [self createPlist];
    }
    if (logCommunicationDic == nil) {
        NSMutableDictionary *logDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [self setLogCommunicationDic:logDic];
        [logDic release];
    }
}

- (void)collectDownLoadDataSummary {
    //NSDate *date = [NSDate date];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateStringTemplate = @"YYMMdd";
    [dateFormatter setDateFormat:dateStringTemplate];
   // NSString *currentDayString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:currentDayString message:[NSString stringWithFormat:@"%f", self.downLoadSummary] delegate:nil cancelButtonTitle:@"canccel" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    
    //[MobClick event:currentDayString label:[NSString stringWithFormat:@"%f", self.downLoadSummary]];
    self.downLoadSummary = 0;
    
}

@end











