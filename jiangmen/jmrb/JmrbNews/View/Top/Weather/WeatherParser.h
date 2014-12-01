//
//  WeatherParse.h
//  WeatherParser
//
//  Created by jimneylee on 11-4-20.
//  Copyright 2011 open source. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayWeather.h"

@interface WeatherParser : NSObject<NSXMLParserDelegate>
{
	NSXMLParser *xmlParser;
	
	NSMutableArray *xmlWeatherStringArray;
	NSMutableArray *dayWeatherArray;
	NSArray *weekNameArray;
	
	BOOL parseSuccssful;
}
@property(nonatomic, readonly) BOOL parseSuccssful;
@property(nonatomic, readonly) NSMutableArray *dayWeatherArray;
- (void)startParse;
@end
/*
 *<?xml version="1.0" encoding="utf-8"?>
 <ArrayOfString xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://WebXml.com.cn/">
 0 <string>江苏</string>
 1 <string>常州</string>
 2 <string>58343</string>
 3 <string>58343.jpg</string>
 4 <string>2011-4-20 18:30:36</string>
 5 <string>12℃/22℃</string>
 6 <string>4月21日 雷阵雨转阵雨</string>
 7 <string>南风3-4级转东北风3-4级</string>
 8 <string>4.gif</string>
 9 <string>3.gif</string>
 10 <string>今日天气实况：气温：21℃；风向/风力：南风 4级；湿度：28%；空气质量：良；紫外线强度：弱</string>
 11 <string>穿衣指数：建议着夹衣加薄羊毛衫等春秋服装。体弱者宜着夹衣加羊毛衫。但昼夜温差较大，注意增减衣服。
 感冒指数：天冷空气湿度大且昼夜温差也很大，易发生感冒，请注意适当增减衣服。
 运动指数：有降水，风力较强，气压较低，较适宜在户内低强度运动，若坚持户外运动，注意避雨防风。
 洗车指数：不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。
 晾晒指数：有降水，不适宜晾晒。如果非晾晒不可，请在室内准备出充足的空间。
 旅游指数：有雷阵雨，请尽量不要外出，若外出，请注意防雷。风稍大但温度适宜，还是可以外出游玩的。
 路况指数：有小雨，路面潮湿，车辆易打滑，请小心驾驶。
 舒适度指数：白天不太热也不太冷，风力不大，相信您在这样的天气条件下，应会感到比较清爽和舒适。</string>
 12 <string>11℃/21℃</string>
 13 <string>4月22日 多云</string>
 14 <string>北风3-4级转西风3-4级</string>
 15 <string>1.gif</string>
 16 <string>1.gif</string>
 17 <string>12℃/23℃</string>
 18 <string>4月23日 多云</string>
 19 <string>西风3-4级</string>
 20 <string>1.gif</string>
 21 <string>1.gif</string>
 22 <string>常州处于美丽富饶的长江金三角地区，与上海、南京两大都市等距相望，与苏州、无锡联袂成片，构成了苏锡常都市圈。常州有着十分优越的区位条件和便捷的水陆空交通条件，市区北临长江，南濒太湖，沪宁铁路、沪宁高速公路、312国道、京杭大运河穿境而过。全市水网纵横交织，连江通海。长江常州港作为国家一类开放口岸，年货物吞吐量超过百万吨。常州是一座有着2500多年文字记载历史的文化古城（历史上有“龙城”别称），同时又是一座充满现代气息、经济较发达的新兴工业城市。常州现辖金坛、溧阳两个县级市以及武进、新北、天宁、钟楼、戚墅堰五个行政区，全市总面积4375平方公里，全市户籍总人口354.7万人。</string>
 </ArrayOfString>
 */
