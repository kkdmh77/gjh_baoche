//
//  ATBLibs+NSString.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(ATBLibsAddtions)

/*
/// 获取本地当前时间(已转化GMT格林时间差)
+ (NSDate *)nowLocalDate;
 */

/// 按照指定格式将NSDate转字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;

/// 计算过去的某个时间点离现在时间的长短文字描述(如:刚刚、多少分钟前、多少小时前等)
+ (NSString *)timeIntervalStringSinceNowWithCompareTime:(NSTimeInterval)toCompareTime;

/// 计算现在时间距离某个时间点之间的天、时、分、秒数据
+ (void)getTimeIntervalSinceNowWithCompareTime:(NSTimeInterval)toCompareTime daysCount:(NSInteger *)days andHoursCount:(NSInteger *)hours minutesCount:(NSInteger *)minutes secondsCount:(NSInteger *)seconds;

@end


