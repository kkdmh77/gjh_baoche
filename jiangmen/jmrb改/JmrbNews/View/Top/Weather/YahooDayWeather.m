//
//  YahooDayWeather.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YahooDayWeather.h"


@implementation YahooDayWeather 
@synthesize imageName, dayText, dayNum, month, yearNum, highTemperature, lowTemperature, textTemperature;

- (void)dealloc {
    [self setImageName:nil];
    [self setDayNum:nil];
    [self setDayText:nil];
    [self setMonth:nil];
    [self setYearNum:nil];
    [self setHighTemperature:nil];
    [self setLowTemperature:nil];
    [self setTextTemperature:nil];
    [super dealloc];
}

@end
