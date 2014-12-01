//
//  ZSCommunicateModel.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-8.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define MyUTF8   NSUTF8StringEncoding

#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"
#import <CoreTelephony/CTCALL.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
#import "ImageContant.h"

@interface ZSCommunicateModel()

- (void)delaySendBaoLiaoData;
NSInteger Compare(id num1, id num2, void *context);
- (id)changeStyleToMultable:(id)changeItem;

@end

static ZSCommunicateModel *_default = nil;

@implementation ZSCommunicateModel
@synthesize BLsendImage, BLsendDic;

+ (id)defaultCommunicate {
    if (!_default) {
        _default = [[ZSCommunicateModel alloc] init];
    }
    return _default;
}

- (void)dealloc {
    [self setBLsendImage:nil];
    [self setBLsendDic:nil];
    if (_urlConnection) {
        [_urlConnection release];
    }
    [_receiveData release];
    [newsListNumDic release];
    [_nowWeb release];
    [_default release];
    _default = nil;
    [super dealloc];
}

- (id)init {
    if (!_default) {
        _default = [[ZSCommunicateModel alloc] init];
    }
    return _default;
}

+ (id)alloc {
    if (!_default) {
        _default = [super alloc];
    }
    return _default;
}

#pragma mark - Public
- (void)clearHotNewsList {
    hotPictureNum = 1;
    [[ZSSourceModel defaultSource] setHotPictureDic:nil];
}

- (void)clearHotVideoList {
    hotVideoNum = 1;
    [[ZSSourceModel defaultSource] setHotVideoDic:nil];
}

- (void)clearVoteList {
    voteNum = 1;
    [[ZSSourceModel defaultSource] setVotelistDic:nil];
}

- (void)clearAllNewsList {
    [newsListNumDic removeAllObjects];
    [[ZSSourceModel defaultSource] setNewsListDataDic:nil];
}

- (void)clearAllSpecialList {
    nowSpecialContetNum =1;
    [[ZSSourceModel defaultSource] setSpecialContentDic:nil];
}

- (void)sendBaoLiaoImage:(UIImage *)baoliaoImage Info:(NSDictionary *)getDic {
    @synchronized ([ZSCommunicateModel class]) {
        if (_isBusy) {
            [self setBLsendDic:getDic];
            [self setBLsendImage:baoliaoImage];
            [self performSelector:@selector(delaySendBaoLiaoData) withObject:nil afterDelay:1];
            return;
        }
        _isBusy = YES;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate startLoading];
        if (_receiveData == nil) {
            timeBetweenServer = 0;
            _receiveData = [[NSMutableData alloc] init];
            hotPictureNum = 1;
            newsListNumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            _isBusy = NO;
        }
        [_receiveData setData:nil];
        if (_nowWeb) {
            [_nowWeb release];
        }
        _nowWeb = [Web_BaoLiao retain];
        NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",Web_URL, Web_BaoLiao];
        NSMutableDictionary *canshuDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [canshuDic removeObjectForKey:Web_Key_urlString];
        [canshuDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:Key_deviceId] forKey:@"imsi"];
        [canshuDic setObject:@"NULL" forKey:@"esn"];
        [canshuDic setObject:@"iphone" forKey:@"category"];
        [canshuDic setObject:@"NULL" forKey:@"termcode"];
        [canshuDic setObject:[NSString stringWithFormat:@"%.0f",timeBetweenServer + 1000.0*[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
        [canshuDic setObject:@"手机客户端" forKey:@"channel"];
        [canshuDic setObject:@"1.0" forKey:@"v"];
        [canshuDic setObject:@"1" forKey:@"format"];
        
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_Category] forKey:@"cid"];
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_baoLiaoPerson] forKey:@"provider"];
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_Telephone] forKey:@"providerNum"];
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_StartTime] forKey:@"time"];
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_HappenAddress] forKey:@"place"];
        [canshuDic setObject:[getDic objectForKey:Key_BaoLiao_Content] forKey:@"newsInfo"];
        
        NSMutableString *sigString = [NSMutableString stringWithFormat:@""];
        NSArray *keyArray = [canshuDic allKeys];
        if ([keyArray count] > 0) {
            NSArray *sortKeyArray = [keyArray sortedArrayUsingFunction:Compare context:nil];
            NSString *key = [sortKeyArray objectAtIndex:0];
            [url appendString:[NSString stringWithFormat:@"?%@=%@",key, [canshuDic objectForKey:key]]];
            [sigString appendString:key];
            [sigString appendString:[canshuDic objectForKey:key]];
            for (int i = 1; i < [sortKeyArray count]; i++) {
                key = [sortKeyArray objectAtIndex:i];
                NSString *encodeContent = [[canshuDic objectForKey:key] URLEncodedString1];
                NSString *encodeKey = [key URLEncodedString1];
                [url appendString:[NSString stringWithFormat:@"&%@=%@",encodeKey, encodeContent]];
                [sigString appendString:encodeKey];
                [sigString appendString:encodeContent];
            }
        }
        [sigString appendString:@"394578347696734954332017"];
        const char *sigChars = [sigString UTF8String];
        unsigned char sig[16];
        CC_MD5(sigChars, strlen(sigChars), sig);
        NSMutableString *sigMD5String = [NSMutableString stringWithFormat:@""];
        for (int i = 0; i < 16; i++) {
            [sigMD5String appendString:[NSString stringWithFormat:@"%02X",sig[i]]];
        }
        [url appendString:[NSString stringWithFormat:@"&sig=%@",sigMD5String]];
        NSURL *myURL = [NSURL URLWithString:url];
        
//        NSLog(@"myURL:%@",myURL);
        NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];
        NSString *myContent = [NSString stringWithFormat:@"text/plan"];
        [myRequest setValue:myContent forHTTPHeaderField:@"Content-type"];
        [myRequest setHTTPMethod:@"POST"];
        [myRequest setHTTPBody:nil];
        NSData *mySend=UIImagePNGRepresentation(baoliaoImage);
        [myRequest setHTTPBody:mySend];
        if (_urlConnection) {
            [_urlConnection release];
            _urlConnection = nil;
        }
        _urlConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
        [_urlConnection start];
    }
}

- (void)getWebData:(NSDictionary *)getDic {
    @synchronized ([ZSCommunicateModel class]) {
        NSString *urlString = [getDic objectForKey:Web_Key_urlString];
        if (_receiveData == nil) {
            _receiveData = [[NSMutableData alloc] init];
            hotPictureNum = 1;
            newsListNumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            _isBusy = NO;
        }
        if (_isBusy) {
            float delayTimer = arc4random()%5/10;
            [self performSelector:@selector(getWebData:) withObject:getDic afterDelay:delayTimer];
            return;
        }
        if (_nowWeb) {
            [_nowWeb release];
        }
        _nowWeb = [urlString retain];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate startLoading];
        [_receiveData setData:nil];
        _isBusy = YES;
        
        NSMutableDictionary *canshuDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
        [canshuDic removeObjectForKey:Web_Key_urlString];
        [canshuDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:Key_deviceId] forKey:@"imsi"];
        [canshuDic setObject:@"NULL" forKey:@"esn"];
        [canshuDic setObject:@"iphone" forKey:@"category"];
        [canshuDic setObject:@"NULL" forKey:@"termcode"];
        [canshuDic setObject:[NSString stringWithFormat:@"%.0f",timeBetweenServer + 1000.0*[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
        [canshuDic setObject:@"手机客户端" forKey:@"channel"];
        [canshuDic setObject:@"1.0" forKey:@"v"];
        [canshuDic setObject:@"1" forKey:@"format"];
        
        NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",Web_URL, urlString];
        if ([_nowWeb isEqualToString:Web_addComment]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_getAds]) {
            //[canshuDic setObject:@"1" forKey:@"adId"];
        }
        else if ([_nowWeb isEqualToString:Web_getComment]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_getNews]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_getSpecialNews]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_getSpecialNewsContent]) {
            //nowSpecialId = [[getDic objectForKey:Key_Special_List_Id_Number] intValue];
           // NSInteger nowItemListNum;
            //if
            
            [canshuDic setObject:[NSString stringWithFormat:@"%i",nowSpecialContetNum] forKey:@"pageNum"];
            [canshuDic setObject:@"20" forKey:@"pageSize"];

            
        }
        else if ([_nowWeb isEqualToString:Web_getNewsList]) {
            nowNewStype = [[getDic objectForKey:Key_News_List_Id_Number] intValue];
            NSInteger nowItemListNum;
            if ([newsListNumDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStype]]) {
                nowItemListNum =  [[newsListNumDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStype]] intValue];
            }
            else {
                nowItemListNum = 1;
            }
            [canshuDic setObject:[NSString stringWithFormat:@"%i",nowItemListNum] forKey:@"pageNum"];
            [canshuDic setObject:@"20" forKey:@"pageSize"];
        }
        else if ([_nowWeb isEqualToString:Web_getNewsType]) {
            
        }
        else if([_nowWeb isEqualToString:Web_getHotPictureNews]) {
            [canshuDic setObject:[NSString stringWithFormat:@"%i",hotPictureNum] forKey:@"pageNum"];
            [canshuDic setObject:@"20" forKey:@"pageSize"];
        }
        else if([_nowWeb isEqualToString:Web_getVoteList]) {
            [canshuDic setObject:[NSString stringWithFormat:@"%i",voteNum] forKey:@"pageNum"];
            [canshuDic setObject:@"20" forKey:@"pageSize"];
        }
        else if([_nowWeb isEqualToString:Web_getHotVideoNews]) {
            [canshuDic setObject:[NSString stringWithFormat:@"%i",hotVideoNum] forKey:@"pageNum"];
            [canshuDic setObject:@"20" forKey:@"pageSize"];
        }
        else if ([_nowWeb isEqualToString:Web_local_Reporter_Login]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_moreAds]) {
            
        }
        else if ([_nowWeb isEqualToString:Web_NewsListAdsShow]) {
            
        }
        NSMutableString *sigString = [NSMutableString stringWithFormat:@""];
        NSArray *keyArray = [canshuDic allKeys];
        if ([keyArray count] > 0) {
            NSArray *sortKeyArray = [keyArray sortedArrayUsingFunction:Compare context:nil];
            NSString *key = [sortKeyArray objectAtIndex:0];
            [url appendString:[NSString stringWithFormat:@"?%@=%@",key, [canshuDic objectForKey:key]]];
            [sigString appendString:key];
            [sigString appendString:[canshuDic objectForKey:key]];
            for (int i = 1; i < [sortKeyArray count]; i++) {
                key = [sortKeyArray objectAtIndex:i];
                NSString *encodeContent = [[canshuDic objectForKey:key] URLEncodedString1];
                NSString *encodeKey = [key URLEncodedString1];
                [url appendString:[NSString stringWithFormat:@"&%@=%@",encodeKey, encodeContent]];
                [sigString appendString:encodeKey];
                [sigString appendString:encodeContent];
            }
        }
        [sigString appendString:@"394578347696734954332017"];

        const char *sigChars = [sigString UTF8String];
        unsigned char sig[16];
        CC_MD5(sigChars, strlen(sigChars), sig);
        NSMutableString *sigMD5String = [NSMutableString stringWithFormat:@""];
        for (int i = 0; i < 16; i++) {
            [sigMD5String appendString:[NSString stringWithFormat:@"%02X",sig[i]]];
        }
        [url appendString:[NSString stringWithFormat:@"&sig=%@",sigMD5String]];
        NSURL *myURL = [NSURL URLWithString:url];
//        NSLog(@"%@",url);
        
        NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];
        [myRequest setHTTPMethod:@"GET"];
        [myRequest setHTTPBody:nil];
        if (_urlConnection) {
            [_urlConnection release];
            _urlConnection = nil;
        }
        _urlConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
        [_urlConnection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection cancel];
    if (_urlConnection) {
        [_urlConnection release];
        _urlConnection = nil;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器连接错误" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    _isBusy = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    _responseCode = [httpResponse statusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {  
    double oldDownLoadData = [[ZSSourceModel defaultSource] downLoadSummary];
    [[ZSSourceModel defaultSource] setDownLoadSummary:[_receiveData length]*1.0/1000.0+oldDownLoadData];
    
    if (_responseCode != 200) {
        [_urlConnection cancel];
        if (_urlConnection) {
            [_urlConnection release];
            _urlConnection = nil;
        }
        _isBusy = NO;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate stopLoading];
        return;
    }
    NSDictionary *dicDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:_receiveData error:nil];
    NSMutableDictionary *dic = [self changeStyleToMultable:dicDic];
//    NSLog(@"%@",dic);
    //NSNumber *errorNum = [dic objectForKey:@"errorcode"];
    NSString *errorcode = [dic objectForKey:@"errorcode"];
    if ((dic != nil && [errorcode isEqualToString:@"00"]) || [_nowWeb isEqualToString:Web_local_Reporter_Login]) {
    }else if([errorcode isEqualToString:@"01"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNewsList_None object:nil];
    }
    else {
        NSMutableData *logData = [[NSMutableData alloc] initWithData:_receiveData];
        NSString *logString = [NSString stringWithFormat:@"%f", 1000*[[NSDate date] timeIntervalSince1970]];
        [[[ZSSourceModel defaultSource] logCommunicationDic] setObject:logData forKey:logString];
        [logData release];
        
        NSString *msg = [dic objectForKey:@"msg"];
        [_urlConnection cancel];
        if (_urlConnection) {
            [_urlConnection release];
            _urlConnection = nil;
        }
        _isBusy = NO;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate stopLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"服务器数据错误:%@",errorcode] message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    [_urlConnection cancel];
    if ([_nowWeb isEqualToString:Web_addComment]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_addComment object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_getAds]) {
        [[ZSSourceModel defaultSource] setAdsDataDic:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_getAds object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_getComment]) {
        [[ZSSourceModel defaultSource] setCommentDataDic:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_getComment object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_getNews]) {
        if (dic == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNews_Error object:nil];
            [_urlConnection cancel];
            if (_urlConnection) {
                [_urlConnection release];
                _urlConnection = nil;
            }
            _isBusy = NO;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate stopLoading];
            return ;
        }
        NSDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemDic = [responseDic objectForKey:@"item"];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[itemDic objectAtIndex:0]];
        [[ZSSourceModel defaultSource] setNewsDataDic:dataDic];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNews object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_getNewsList]) {
        if (dic == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNewsList_Error object:nil];
            [_urlConnection cancel];
            if (_urlConnection) {
                [_urlConnection release];
                _urlConnection = nil;
            }
            _isBusy = NO;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate stopLoading];
            return;
        }
        NSDictionary *responseDic = [dic objectForKey:@"response"];
        NSArray *itemArray = [responseDic objectForKey:@"item"];
        if (itemArray == nil || [itemArray count] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNewsList_None object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNewsList object:nil];
            [_urlConnection cancel];
            if (_urlConnection) {
                [_urlConnection release];
                _urlConnection = nil;
            }
            _isBusy = NO;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate stopLoading];
            return;
        }
        
        NSMutableDictionary *dataListDic = [[ZSSourceModel defaultSource] newsListDataDic];
        if (dataListDic == nil) {
            dataListDic = [NSMutableDictionary dictionaryWithCapacity:0];
        }
        NSMutableArray *stypeItemArray = [dataListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStype]];
        if (stypeItemArray == nil) {
            stypeItemArray = [NSMutableArray arrayWithCapacity:0];
        }
        
        NSInteger nowItemListNum;
        if ([newsListNumDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStype]] != nil) {
            nowItemListNum =  [[newsListNumDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStype]] intValue];
        }
        else {
            nowItemListNum = 1;
        }
        //图了，
        //NSString * newshost=[responseDic objectForKey:@"newshot"];
        if (nowItemListNum==1) {
            [stypeItemArray addObject:[responseDic objectForKey:@"newshot"]];
        }
        
        
        nowItemListNum++;
        [newsListNumDic setObject:[NSNumber numberWithInt:nowItemListNum] forKey:[NSString stringWithFormat:@"%i",nowNewStype]];
        
        
        
        [stypeItemArray addObjectsFromArray:itemArray];
        [dataListDic setObject:stypeItemArray forKey:[NSString stringWithFormat:@"%i",nowNewStype]];
        [[ZSSourceModel defaultSource] setNewsListDataDic:dataListDic];
        
        

        [[NSNotificationCenter defaultCenter] postNotificationName:notification_getNewsList object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_getNewsType]) {
        [[ZSSourceModel defaultSource] setNewsTypeDataDic:dic];
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        NSMutableDictionary *orderSequenceDic = [[ZSSourceModel defaultSource] newsOrderSequenceDic];
        for (int i = 0; i < [itemArray count]; i++) {
            NSMutableDictionary *itemDic = [itemArray objectAtIndex:i];
            NSNumber *orderSequenceNumber = [orderSequenceDic objectForKey:[itemDic objectForKey:@"newstypeSort"]];
            if (i == 0) {
                [itemDic setObject:[NSNumber numberWithInt:0] forKey:Key_More_Order_Sequence_Num];
            }
            else if (orderSequenceNumber) {
                [itemDic setObject:orderSequenceNumber forKey:Key_More_Order_Sequence_Num];
            }
            else {
                orderSequenceNumber = [orderSequenceDic objectForKey:More_News_Order_Sequence_Max];
                if (orderSequenceNumber != nil) {
                    [itemDic setObject:orderSequenceNumber forKey:Key_More_Order_Sequence_Num];
                    [orderSequenceDic setObject:[NSNumber numberWithInt:[orderSequenceNumber intValue]+1] forKey:More_News_Order_Sequence_Max];
                }
                else {
                    NSLog(@"error Max order Sequence");
                }
            }
        }
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:Key_More_Order_Sequence_Num ascending:YES]; 
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1]; 
        NSArray *sortedArray = [itemArray sortedArrayUsingDescriptors:sortDescriptors];
        [sorter release];
        [sortDescriptors release];
        [itemArray removeAllObjects];
        [itemArray addObjectsFromArray:sortedArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getNewsType object:nil];
    }
    else if([_nowWeb isEqualToString:Web_getHotPictureNews]) {
        NSMutableArray *hotPictureNewsDic = nil;
        if ([[ZSSourceModel defaultSource] hotPictureDic] == nil) {
            hotPictureNewsDic = [NSMutableArray arrayWithCapacity:0];
        }
        else {
            hotPictureNewsDic = [NSMutableArray arrayWithArray:[[ZSSourceModel defaultSource] hotPictureDic]];
        }
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        [hotPictureNewsDic addObjectsFromArray:itemArray];
        [[ZSSourceModel defaultSource ] setHotPictureDic:hotPictureNewsDic];
        hotPictureNum ++;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getHotPictureNews object:nil];
    }
    else if([_nowWeb isEqualToString:Web_getVoteList]) {
        NSMutableArray *votelistDic = nil;
        if ([[ZSSourceModel defaultSource] votelistDic] == nil) {
            votelistDic = [NSMutableArray arrayWithCapacity:0];
        }
        else {
            votelistDic = [NSMutableArray arrayWithArray:[[ZSSourceModel defaultSource] votelistDic]];
        }
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        
        //有抽奖活动
        if (![[responseDic objectForKey:@"lottery"] isEqual:nil] && voteNum==1) {
            [votelistDic addObject:[responseDic objectForKey:@"lottery"]];
        }

        
        [votelistDic addObjectsFromArray:itemArray];
        
        
        
        [[ZSSourceModel defaultSource ] setVotelistDic:votelistDic];
        voteNum ++;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getVoteListNews object:nil];
    }
    else if([_nowWeb isEqualToString:Web_getHotVideoNews]) {
        NSMutableArray *hotPictureNewsDic = nil;
        if ([[ZSSourceModel defaultSource] hotVideoDic] == nil) {
            hotPictureNewsDic = [NSMutableArray arrayWithCapacity:0];
        }
        else {
            hotPictureNewsDic = [NSMutableArray arrayWithArray:[[ZSSourceModel defaultSource] hotVideoDic]];
        }
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        [hotPictureNewsDic addObjectsFromArray:itemArray];
        [[ZSSourceModel defaultSource ] setHotVideoDic:hotPictureNewsDic];
        hotVideoNum ++;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getVideoInfor object:nil];
    }
    else if([_nowWeb isEqualToString:Web_getHotVideoLive]) {
        //NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getVideoLive object:nil];
    }
    
    
    else if([_nowWeb isEqualToString:Web_getSpecialNews]) {
        NSMutableArray *hotPictureNewsDic = nil;
       // if ([[ZSSourceModel defaultSource] specialDic] == nil) {
            hotPictureNewsDic = [NSMutableArray arrayWithCapacity:0];
       // }
       // else {
       //     hotPictureNewsDic = [NSMutableArray arrayWithArray:[[ZSSourceModel defaultSource] specialDic]];
       // }
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        [hotPictureNewsDic addObjectsFromArray:itemArray];
        [[ZSSourceModel defaultSource ] setSpecialDic:hotPictureNewsDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getSpecialNews object:nil];
    }
    else if([_nowWeb isEqualToString:Web_getSpecialNewsContent]) {
        NSMutableArray *hotPictureNewsDic = nil;
        if ([[ZSSourceModel defaultSource] specialContentDic] == nil) {
            hotPictureNewsDic = [NSMutableArray arrayWithCapacity:0];
        }else {
             hotPictureNewsDic = [NSMutableArray arrayWithArray:[[ZSSourceModel defaultSource] specialContentDic]];
        }
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        [hotPictureNewsDic addObjectsFromArray:itemArray];
        [[ZSSourceModel defaultSource ] setSpecialContentDic:hotPictureNewsDic];
        nowSpecialContetNum++;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getSpecialNewsContent object:nil];
    }
    else if ([_nowWeb isEqualToString:Web_local_Reporter_Login]) {
        NSMutableDictionary *responseDic = [dic objectForKey:@"response"];
        BOOL loginIsTrue = ![[dic objectForKey:@"error"] boolValue];
        if (loginIsTrue) {
            [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:More_Login_Name] forKey:More_Login_Name];
            [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:More_Login_Reporter_id] forKey:More_Login_Reporter_id];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"%@",msg);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginIsSuccess object:[NSNumber numberWithBool:loginIsTrue]];
    }
    else if ([_nowWeb isEqualToString:Web_moreAds]) {
        if (dic != nil) {
            [[ZSSourceModel defaultSource] setMoreNewsAdsDic:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MoreAds object:nil];
        }
    }
    else if ([_nowWeb isEqualToString:Web_BaoLiao]) {
        if (dic) {
            NSString *error = [[dic objectForKey:@"error"] stringValue];
            if ([error intValue] == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SendBaoLiaoSuccess object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SendBaoLiaoFail object:nil];
            }
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SendBaoLiao_Error object:nil];
        }
    }
    else if ([_nowWeb isEqualToString:Web_NewsListAdsShow]) {
        if (dic != nil) {
            NSDictionary *responseDic = [dic objectForKey:@"response"];
            NSArray *itemArray = [responseDic objectForKey:@"item"];
            NSMutableArray *saveArray = [NSMutableArray arrayWithArray:itemArray];
            [[ZSSourceModel defaultSource] setNewsListAdsArray:saveArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsListAdsShow object:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsListAdsShow_Error object:nil];
        }
    }
    else if ([_nowWeb isEqualToString:Web_ServerTime]){
        if (dic) {
            NSNumber *responseNumber = [[dic objectForKey:@"response"] objectForKey:@"downloadAddress"];
            timeBetweenServer = [responseNumber floatValue] - [[NSDate date] timeIntervalSince1970] * 1000;
            NSString *error = [dic objectForKey:@"errorcode"];
            if ([error isEqualToString:@"00"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_WebServerTime object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_WebServerTime_Error object:nil];
            }
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_WebServerTime_Error object:nil];
        }
    }
    _isBusy = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
}

#pragma mark - Private
- (id)changeStyleToMultable:(id)changeItem {
    if ([changeItem isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)changeItem;
        NSArray *keyArray = [dic allKeys];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString *keyString in keyArray) {
            id mutableId = [self changeStyleToMultable:[dic objectForKey:keyString]];
            [mutableDic setObject:mutableId forKey:keyString];
        }
        return mutableDic;
    }
    else if ([changeItem isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)changeItem;
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [array count]; i++) {
            id mutableId = [self changeStyleToMultable:[array objectAtIndex:i]];
            [mutableArray insertObject:mutableId atIndex:i];
        }
        return mutableArray;
    }
    return changeItem;
}

NSInteger Compare(id num1, id num2, void *context)
{
    NSString *value1 = (NSString *) num1;
    NSString *value2 = (NSString *) num2;
    return [value1 compare:value2];
}

- (void)delaySendBaoLiaoData {
    [self sendBaoLiaoImage:BLsendImage Info:BLsendDic]; 
}

@end







