//
//  YahooWeather.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define YahooWeatherServiceURLStr @"http://weather.yahooapis.com/forecastrss"
#import "YahooWeather.h"
@interface YahooWeather()

- (void)initXMLParser;

@end

@implementation YahooWeather
@synthesize _dayWeather;

#pragma mark - System
- (void)dealloc {
    [tempatureDic release];
    [xmlParser release];
    [self set_dayWeather:nil];
    [xmlWeatherStringArray release];
    [super dealloc];
}

- (id)init{
	self = [super init];
	if (self) {
		xmlWeatherStringArray = [[NSMutableArray alloc] init];
        [self initXMLParser];
	}
	return self;
}

#pragma mark - Private
- (void)initXMLParser {
	NSString *weatherRequestUrlStr = [NSString stringWithFormat:@"%@?w=2161847&u=c",YahooWeatherServiceURLStr];
	NSData *weatherReponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherRequestUrlStr]];
	xmlParser = [[NSXMLParser alloc] initWithData:weatherReponseData];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
    YahooDayWeather *dayWeather = [[YahooDayWeather alloc] init];
    [self set_dayWeather:dayWeather];
    [dayWeather release];
    tempatureDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [tempatureDic setObject:@"龙卷风" forKey:@"0"];
    [tempatureDic setObject:@"热带风暴" forKey:@"1"];
    [tempatureDic setObject:@"飓风" forKey:@"2"];
    [tempatureDic setObject:@"猛烈的雷暴" forKey:@"3"];
    [tempatureDic setObject:@"雷暴" forKey:@"4"];
    [tempatureDic setObject:@"雨夹雪" forKey:@"5"];
    [tempatureDic setObject:@"雨夹冰雹" forKey:@"6"];
    [tempatureDic setObject:@"雪夹冰雹" forKey:@"7"];
    [tempatureDic setObject:@"冰冷细雨" forKey:@"8"];
    [tempatureDic setObject:@"细雨" forKey:@"9"];
    [tempatureDic setObject:@"冰雨" forKey:@"10"];
    [tempatureDic setObject:@"阵雨" forKey:@"11"];
    [tempatureDic setObject:@"阵雨" forKey:@"12"];
    [tempatureDic setObject:@"阵雪" forKey:@"13"];
    [tempatureDic setObject:@"小雪" forKey:@"14"];
    [tempatureDic setObject:@"飞雪" forKey:@"15"];
    [tempatureDic setObject:@"下雪" forKey:@"16"];
    [tempatureDic setObject:@"冰雹" forKey:@"17"];
    [tempatureDic setObject:@"冰雹" forKey:@"18"];
    [tempatureDic setObject:@"灰尘" forKey:@"19"];
    [tempatureDic setObject:@"多雾" forKey:@"20"];
    [tempatureDic setObject:@"薄雾" forKey:@"21"];
    [tempatureDic setObject:@"大烟" forKey:@"22"];
    [tempatureDic setObject:@"狂风" forKey:@"23"];
    [tempatureDic setObject:@"大风" forKey:@"24"];
    [tempatureDic setObject:@"冷" forKey:@"25"];
    [tempatureDic setObject:@"多云" forKey:@"26"];
    [tempatureDic setObject:@"多云" forKey:@"27"];
    [tempatureDic setObject:@"多云" forKey:@"28"];
    [tempatureDic setObject:@"局部多云" forKey:@"29"];
    [tempatureDic setObject:@"局部多云" forKey:@"30"];
    [tempatureDic setObject:@"天晴" forKey:@"31"];
    [tempatureDic setObject:@"天晴" forKey:@"32"];
    [tempatureDic setObject:@"转晴" forKey:@"33"];
    [tempatureDic setObject:@"转晴" forKey:@"34"];
    [tempatureDic setObject:@"雨夹冰雹" forKey:@"35"];
    [tempatureDic setObject:@"高温" forKey:@"36"];
    [tempatureDic setObject:@"局部雷暴" forKey:@"37"];
    [tempatureDic setObject:@"局部雷暴" forKey:@"38"];
    [tempatureDic setObject:@"局部雷暴" forKey:@"39"];
    [tempatureDic setObject:@"零星阵雨" forKey:@"40"];
    [tempatureDic setObject:@"大雪" forKey:@"41"];
    [tempatureDic setObject:@"局部阵雪" forKey:@"42"];
    [tempatureDic setObject:@"大雪" forKey:@"43"];
    [tempatureDic setObject:@"局部多云" forKey:@"44"];
    [tempatureDic setObject:@"雷阵雨" forKey:@"45"];
    [tempatureDic setObject:@"阵雪" forKey:@"46"];
    [tempatureDic setObject:@"局部雷阵雨" forKey:@"47"];
    [tempatureDic setObject:@"天晴" forKey:@"3200"];
}

- (void)startXMLParser {
	// 开始解析
	[xmlParser parse];
}

#pragma mark xml parser delegate
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//	NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
//	string = [string stringByTrimmingCharactersInSet:whitespace];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (_dayWeather.dayText && [_dayWeather.dayText length] > 0) {
        return;
    }
    [xmlWeatherStringArray addObject:elementName];
    [xmlWeatherStringArray addObject:attributeDict];
    if ([elementName isEqualToString:@"yweather:forecast"]) {
        NSString *codeString = [attributeDict objectForKey:@"code"];
        NSString *dateString = [attributeDict objectForKey:@"date"];
        NSString *dayString = [attributeDict objectForKey:@"day"];
        NSString *highString = [attributeDict objectForKey:@"high"];
        NSString *lowString = [attributeDict objectForKey:@"low"];
        NSString *textString = [attributeDict objectForKey:@"text"];
        if (codeString && dateString && dayString && highString && lowString && textString) {
            [_dayWeather setDayText:dayString];
            [_dayWeather setImageName:[NSString stringWithFormat:@"weather_%@",codeString]];
            [_dayWeather setHighTemperature:highString];
            [_dayWeather setLowTemperature:lowString];
            [_dayWeather setTextTemperature:[tempatureDic objectForKey:[NSString stringWithFormat:@"%@",codeString]]];
            if (_dayWeather.textTemperature == nil || [_dayWeather.textTemperature length] == 0) {
                [_dayWeather setTextTemperature:textString];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	NSLog(@"%@", [parseError description]);
}

@end
