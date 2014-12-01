
//
//  DayWeather.h
//  WeatherParser
//
//  Created by jimneylee on 11-5-4.
//  Copyright 2011 open source. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *2011-05-04 10:08:40.038 WeatherParser[1018:207] <0>江苏
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
@interface DayWeather : NSObject {
	NSString *dateStr;			// 日期
	NSString *weekStr;			// 星期
	NSString *temperatureRangeInfo;	// 温度范围
	NSString *windInfo;				// 风向
	NSString *basicInfo;			// 基本信息
	NSString *realtimeInfo;			// 实时信息
	NSString *picureStartName;		// 天气图片开始名称
	NSString *picureEndName;		// 天气图片结束名称
}
@property(nonatomic, copy) NSString *dateStr;
@property(nonatomic, copy) NSString *weekStr;
@property(nonatomic, copy) NSString *temperatureRangeInfo;
@property(nonatomic, copy) NSString *windInfo;
@property(nonatomic, copy) NSString *basicInfo;
@property(nonatomic, copy) NSString *realtimeInfo;
@property(nonatomic, copy) NSString *picureStartName;
@property(nonatomic, copy) NSString *picureEndName;
@end
