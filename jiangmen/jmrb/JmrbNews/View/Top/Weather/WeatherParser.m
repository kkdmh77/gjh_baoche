//
//  WeatherParse.m
//  WeatherParser
//
//  Created by jimneylee on 11-4-20.
//  Copyright 2011 open source. All rights reserved.
//

#import "WeatherParser.h"

@interface WeatherParser(private)
- (void)initCityLocation;
- (void)initXMLParser;

- (NSUInteger)calculateWeekNum:(NSString*)dateStr;
- (void)splitXmlWeatherInfo;

- (void)outputParseInfo;
- (void)outputDayWeatherInfo;
@end
#define kQQWebServiceURLStr @"http://fw.qq.com/ipaddress"
#define kWeatherServiceURLStr @"http://webservice.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName?theCityName="

@implementation WeatherParser
@synthesize parseSuccssful;
@synthesize dayWeatherArray;
- (id)init{
	self = [super init];
	if (self) {
		xmlWeatherStringArray = [[NSMutableArray alloc] init];
		dayWeatherArray = [[NSMutableArray alloc] init];
		weekNameArray = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];

		[self initCityLocation];
		[self initXMLParser];
	}
	return self;
}

- (void)dealloc{
	[xmlParser release];
	
	[xmlWeatherStringArray release];
	[dayWeatherArray release];
	[super dealloc];
}

- (void)initCityLocation{
}

- (void)initXMLParser{
    NSString *city = @"江门";
	NSString *weatherRequestUrlStr = [NSString stringWithFormat:@"%@%@",kWeatherServiceURLStr,[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	NSLog(@"request = %@", weatherRequestUrlStr);
	NSData *weatherReponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherRequestUrlStr]];

// 高速访问方式，免费未提供
//	NSString *datastr = [NSString stringWithContentsOfURL:[NSURL URLWithString:weatherRequestUrlStr]
//												 encoding:NSUTF8StringEncoding error:nil];
//	NSLog(@"data xml = %@", datastr);
	
	xmlParser = [[NSXMLParser alloc] initWithData:weatherReponseData];
	
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
}

- (void)startParse{
	// 开始解析
	[xmlParser parse];
	
}
#pragma mark NSXMLParserDelegate

/*
 * 目前依旧采用jy的方法
 * 问题：晚上时，显示时间是明天 后天 大后天,这样取的时间不准 
 */
#pragma mark xml parser delegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
	string = [string stringByTrimmingCharactersInSet:whitespace];
	
	if (![string isEqualToString:@"\n"]) {
		[xmlWeatherStringArray addObject:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	NSLog(@"%@", [parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	[self outputParseInfo];
	
	//取出xml中数据后提取信息 
	[self splitXmlWeatherInfo];
}	

#pragma mark split info
/*
 2011-05-04 10:08:40.038 WeatherParser[1018:207] <0>江苏
 2011-05-04 10:08:40.050 WeatherParser[1018:207] <1>常州
 2011-05-04 10:08:40.057 WeatherParser[1018:207] <2>58343
 2011-05-04 10:08:40.068 WeatherParser[1018:207] <3>58343.jpg
 2011-05-04 10:08:40.075 WeatherParser[1018:207] <4>2011-5-4 10:04:54
 2011-05-04 10:08:40.088 WeatherParser[1018:207] <5>14
 2011-05-04 10:08:40.094 WeatherParser[1018:207] <6>℃/24℃
 2011-05-04 10:08:40.130 WeatherParser[1018:207] <7>5
 2011-05-04 10:08:40.141 WeatherParser[1018:207] <8>月4日 多云
 2011-05-04 10:08:40.156 WeatherParser[1018:207] <9>东南风3-4级
 2011-05-04 10:08:40.169 WeatherParser[1018:207] <10>1.gif
 2011-05-04 10:08:40.184 WeatherParser[1018:207] <11>1.gif
 2011-05-04 10:08:40.196 WeatherParser[1018:207] <12>今日天气实况：气温：20℃；风向/风力：东南风 2级；湿度：49%；空气质量：良；紫外线强度：弱
 2011-05-04 10:08:40.215 WeatherParser[1018:207] <13>穿衣指数：建议着薄型套装等春秋过渡装。年老体弱者宜着套装。但昼夜温差较大，注意适当增减衣服。
 感冒指数：昼夜温差较大，较易发生感冒，请适当增减衣服。体质较弱的朋友请注意防护。
 运动指数：天气较好，请减少运
 2011-05-04 10:08:40.231 WeatherParser[1018:207] <14>动时间并降低运动强度，因紫外线强且风力较大，户外运动避风防晒。
 洗车指数：适宜洗车，未来持续两天无雨天气较好，适合擦洗汽车，蓝天白云、风和日丽将伴您的车子连日洁净。
 晾晒指数：多云，适宜晾晒。赶紧把久未见
 2011-05-04 10:08:40.235 WeatherParser[1018:207] <15>阳光的衣物搬出来吸收一下太阳的味道吧！
 旅游指数：白云飘飘，温度适宜，但风稍微有点大。这样的天气很适宜旅游，您可以尽情地享受大自然的无限风光。
 路况指数：晴天，条件适宜，路面比较干燥，路况较好。
 舒适度指
 2011-05-04 10:08:40.237 WeatherParser[1018:207] <16>数：白天不太热也不太冷，风力不大，相信您在这样的天气条件下，应会感到比较清爽和舒适。
 2011-05-04 10:08:40.240 WeatherParser[1018:207] <17>14
 2011-05-04 10:08:40.243 WeatherParser[1018:207] <18>℃/28℃
 2011-05-04 10:08:40.245 WeatherParser[1018:207] <19>5
 2011-05-04 10:08:40.247 WeatherParser[1018:207] <20>月5日 多云
 2011-05-04 10:08:40.250 WeatherParser[1018:207] <21>西南风3-4级
 2011-05-04 10:08:40.252 WeatherParser[1018:207] <22>1.gif
 2011-05-04 10:08:40.254 WeatherParser[1018:207] <23>1.gif
 2011-05-04 10:08:40.256 WeatherParser[1018:207] <24>15
 2011-05-04 10:08:40.258 WeatherParser[1018:207] <25>℃/30℃
 2011-05-04 10:08:40.261 WeatherParser[1018:207] <26>5
 2011-05-04 10:08:40.263 WeatherParser[1018:207] <27>月6日 阴转多云
 2011-05-04 10:08:40.265 WeatherParser[1018:207] <28>西南风3-4级
 2011-05-04 10:08:40.267 WeatherParser[1018:207] <29>2.gif
 2011-05-04 10:08:40.270 WeatherParser[1018:207] <30>1.gif
 2011-05-04 10:08:40.272 WeatherParser[1018:207] <31>常州处于美丽富饶的长江金三角地区，与上海、南京两大都市等距相望，与苏州、无锡联袂成片，构成了苏锡常都市圈。常州有着十分优越的区位条件和便捷的水陆空交通条件，市区北临长江，南濒太湖，沪宁铁路、沪宁高速公
 2011-05-04 10:08:40.275 WeatherParser[1018:207] <32>路、312国道、京杭大运河穿境而过。全市水网纵横交织，连江通海。长江常州港作为国家一类开放口岸，年货物吞吐量超过百万吨。常州是一座有着2500多年文字记载历史的文化古城（历史上有“龙城”别称），同时又是一座充满
 2011-05-04 10:08:40.277 WeatherParser[1018:207] <33>现代气息、经济较发达的新兴工业城市。常州现辖金坛、溧阳两个县级市以及武进、新北、天宁、钟楼、戚墅堰五个行政区，全市总面积4375平方公里，全市户籍总人口354.7万人。
*/
/*
 * 注意：
 * 1、晚上七八点时接受到的信息是明后三天,bug已修复
 * 2、天气实况信息的行数不稳定，需动态查找，bug已修复
 */
- (void)splitXmlWeatherInfo{
	DayWeather *dayWeather;
	NSString *dateAndBasicInfo;
	NSArray *dateAndBasicInfoArray;
	NSUInteger weekNum;
	
	if ([xmlWeatherStringArray count] >= 30) {
		// 获取今天的天气 5-11
		dayWeather = [[DayWeather alloc] init];
		weekNum = [self calculateWeekNum:[xmlWeatherStringArray objectAtIndex:4]];
		[dayWeather setWeekStr:[weekNameArray objectAtIndex:weekNum]];
		[dayWeather setTemperatureRangeInfo:[NSString stringWithFormat:@"%@%@", 
		[xmlWeatherStringArray objectAtIndex:5], [xmlWeatherStringArray objectAtIndex:6]]];
		
		dateAndBasicInfo = [NSString stringWithFormat:@"%@%@",
		[xmlWeatherStringArray objectAtIndex:7], [xmlWeatherStringArray objectAtIndex:8]];
		dateAndBasicInfoArray = [dateAndBasicInfo componentsSeparatedByString:@" "];
		if ([dateAndBasicInfoArray count] >= 2) {
			[dayWeather setDateStr:[dateAndBasicInfoArray objectAtIndex:0]];
			[dayWeather setBasicInfo:[dateAndBasicInfoArray objectAtIndex:1]];
		}
		[dayWeather setWindInfo:[xmlWeatherStringArray objectAtIndex:9]];
		
		[dayWeather setPicureStartName:[xmlWeatherStringArray objectAtIndex:10]];
		[dayWeather setPicureEndName:[xmlWeatherStringArray objectAtIndex:11]];
		
#if 0//old method
		[dayWeather setRealtimeInfo:[NSString stringWithFormat:@"%@%@%@%@%@", 
									 [xmlWeatherStringArray objectAtIndex:12], 
									 [xmlWeatherStringArray objectAtIndex:13],
									 [xmlWeatherStringArray objectAtIndex:14],
									 [xmlWeatherStringArray objectAtIndex:15],
									 [xmlWeatherStringArray objectAtIndex:16]]];
#else
		NSUInteger index = 12;
		NSMutableString *realtimeInfo = [[NSMutableString alloc] init];
		// 找到含有℃/行
		while ([[xmlWeatherStringArray objectAtIndex:index] rangeOfString:@"℃/"].length == 0) {
			index++;
		}

		for (NSUInteger i = 12; i <= index-2; i++) {
			[realtimeInfo appendString:[xmlWeatherStringArray objectAtIndex:i]];
		}
		[dayWeather setRealtimeInfo:(NSString*)realtimeInfo];
		[realtimeInfo release];
#endif
		[dayWeatherArray addObject:dayWeather];
		[dayWeather release];
		
		// 获取明天的天气 17-23
		NSUInteger offset = index -2 -16;
		dayWeather = [[DayWeather alloc] init];
		[dayWeather setWeekStr:[weekNameArray objectAtIndex:(weekNum+1)%7]];
		[dayWeather setTemperatureRangeInfo:[NSString stringWithFormat:@"%@%@", 
		[xmlWeatherStringArray objectAtIndex:17+offset], [xmlWeatherStringArray objectAtIndex:18+offset]]];
		dateAndBasicInfo = [NSString stringWithFormat:@"%@%@",
					   [xmlWeatherStringArray objectAtIndex:19+offset], [xmlWeatherStringArray objectAtIndex:20+offset]];
		dateAndBasicInfoArray = [dateAndBasicInfo componentsSeparatedByString:@" "];
		if ([dateAndBasicInfoArray count] >= 2) {
			[dayWeather setDateStr:[dateAndBasicInfoArray objectAtIndex:0]];
			[dayWeather setBasicInfo:[dateAndBasicInfoArray objectAtIndex:1]];
		}
		[dayWeather setWindInfo:[xmlWeatherStringArray objectAtIndex:21+offset]];
	
		[dayWeather setPicureStartName:[xmlWeatherStringArray objectAtIndex:22+offset]];
		[dayWeather setPicureEndName:[xmlWeatherStringArray objectAtIndex:23+offset]];
		
		[dayWeatherArray addObject:dayWeather];
		[dayWeather release];

		
		// 获取后天的天气 24-30
		dayWeather = [[DayWeather alloc] init];
		[dayWeather setWeekStr:[weekNameArray objectAtIndex:(weekNum+2)%7]];
		[dayWeather setTemperatureRangeInfo:[NSString stringWithFormat:@"%@%@", 
		[xmlWeatherStringArray objectAtIndex:24+offset], [xmlWeatherStringArray objectAtIndex:25+offset]]];
		
		dateAndBasicInfo = [NSString stringWithFormat:@"%@%@",
		[xmlWeatherStringArray objectAtIndex:26+offset], [xmlWeatherStringArray objectAtIndex:27+offset]];
		dateAndBasicInfoArray = [dateAndBasicInfo componentsSeparatedByString:@" "];
		if ([dateAndBasicInfoArray count] >= 2) {
			[dayWeather setDateStr:[dateAndBasicInfoArray objectAtIndex:0]];
			[dayWeather setBasicInfo:[dateAndBasicInfoArray objectAtIndex:1]];
		}
		[dayWeather setWindInfo:[xmlWeatherStringArray objectAtIndex:28+offset]];

		[dayWeather setPicureStartName:[xmlWeatherStringArray objectAtIndex:29+offset]];
		[dayWeather setPicureEndName:[xmlWeatherStringArray objectAtIndex:30+offset]];
		
		[dayWeatherArray addObject:dayWeather];
		[dayWeather release];
	}
	
	if ([dayWeatherArray count] >= 3) {
		parseSuccssful = YES;
	}
	
	// 输出解析信息
	[self outputDayWeatherInfo];
}

#pragma mark other
- (void)outputParseInfo{
//	for (int i = 0; i < [xmlWeatherStringArray count]; ++i) {
//		NSLog(@"<%d>%@", i, [xmlWeatherStringArray objectAtIndex:i]);
//	}
}

- (void)outputDayWeatherInfo{
}
/*
 *蔡勒公式
 *W=[C/4]-2C+y+[y/4]+[26(m+1)/10]+d-1  
 *其中,W是所求日期的星期数.如果求得的数大于7,可以减去7的倍数,
 *直到余数小于7为止.c是公元年份的前两位数字,y是以知公元年份的
 *后两位数字;m是月数,d是日数.方括[ ]表示只截取该数的整数部分.
 *还有一个特别要注意的地方:所求的月份如果是1月或2月,则应视为
 *前一年的13月或14月.所以公式中m 的取值范围不是1-12,而是3-14.  
 */
- (NSUInteger)calculateWeekNum:(NSString*)dateStr{
	NSArray *separateStrArray = [[[NSArray alloc] initWithArray:[dateStr componentsSeparatedByString:@"-"]] autorelease];
	NSString *year = [separateStrArray objectAtIndex:0];
	NSString *month = [separateStrArray objectAtIndex:1];
	NSString *idate = [separateStrArray objectAtIndex:2];
	
	//防止字符串里面有空格，先全部转换成整数，再求余或者mod
	NSInteger Year = [year integerValue];
	NSInteger Month = [month integerValue];
	NSInteger Day = [idate integerValue];
	
	NSInteger weekNum;
	//对一月、二月特殊处理，当作前一年的13、14月
	if (Month == 1 || Month == 2) {
		Month += 12;
		Year--;
	}
	NSInteger CYear = Year/100;
	NSInteger Byear = Year%100;
	
	weekNum = (CYear/4) - 2*CYear + Byear + (Byear/4) + (13 * (Month + 1)/5) + Day - 1;
	
	if (weekNum <= 0) 
	{
		weekNum = weekNum + 70;
	}
	weekNum = weekNum % 7;
	
	return weekNum;
}
@end
