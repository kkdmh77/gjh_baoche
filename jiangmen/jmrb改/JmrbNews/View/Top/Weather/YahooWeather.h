//
//  YahooWeather.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YahooDayWeather.h"

@interface YahooWeather : NSObject <NSXMLParserDelegate>{
	NSXMLParser *xmlParser;
	NSMutableArray *xmlWeatherStringArray; 
    NSMutableDictionary *tempatureDic;
}

@property (nonatomic, retain) YahooDayWeather *_dayWeather;

- (void)startXMLParser;

@end
