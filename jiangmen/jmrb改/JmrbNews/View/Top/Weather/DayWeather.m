//
//  DayWeather.m
//  WeatherParser
//
//  Created by jimneylee on 11-5-4.
//  Copyright 2011 open source. All rights reserved.
//

#import "DayWeather.h"


@implementation DayWeather
@synthesize dateStr;
@synthesize weekStr;
@synthesize temperatureRangeInfo;
@synthesize windInfo;
@synthesize basicInfo;
@synthesize realtimeInfo;
@synthesize picureStartName;
@synthesize picureEndName;

- (void)dealloc{
	[dateStr release];
	[weekStr release];
	[temperatureRangeInfo release];
	[windInfo release];
	[basicInfo release];
	[realtimeInfo release];
	[picureStartName release];
	[picureEndName release];

	[super dealloc];
}
@end
