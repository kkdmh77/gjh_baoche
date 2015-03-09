//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"

@implementation AllBusListItemEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.keyId = [[dict safeObjectForKey:@"BusId"] integerValue];
        self.busNameStr = [dict safeObjectForKey:@"BusName"];
        self.busTypeStr = [dict safeObjectForKey:@"BusType"];
        self.startStation = [dict safeObjectForKey:@"StartLocation"];
        self.endStation = [dict safeObjectForKey:@"EndLocation"];
        self.passStation = [dict safeObjectForKey:@"PassByInfo"];
        self.price = [[dict safeObjectForKey:@"Price"] doubleValue];
        
        NSTimeInterval startTime = [[dict safeObjectForKey:@"Start"] doubleValue];
        NSTimeInterval endTime = [[dict safeObjectForKey:@"End"] doubleValue];
        
        NSInteger days, hours, minutes;
        
        [NSDate getTimeIntervalWithBeginCompareTime:startTime
                                     endCompareTime:endTime
                                          daysCount:&days
                                      andHoursCount:&hours
                                       minutesCount:&minutes
                                       secondsCount:NULL];
        
        self.startTimeStr = [NSDate stringFromTimeIntervalSeconds:startTime withFormatter:DataFormatter_TimeNoSecond];
        self.endTimeStr = [NSDate stringFromTimeIntervalSeconds:endTime withFormatter:DataFormatter_TimeNoSecond];
        
        self.startTime_DateStr = [NSDate stringFromTimeIntervalSeconds:startTime withFormatter:DataFormatter_DateNoYear];
        self.endTime_DateStr = [NSDate stringFromTimeIntervalSeconds:endTime withFormatter:DataFormatter_DateNoYear];
        
        self.timeRequired = [NSString stringWithFormat:@"%d时%d分钟", hours + 24 * days, minutes];
        if (0 == days)
        {
            self.endDateRequireDescStr = [NSString stringWithFormat:@"当日"];
        }
        else if (1 == days)
        {
            self.endDateRequireDescStr = [NSString stringWithFormat:@"次日"];
        }
        else if (2 == days)
        {
            self.endDateRequireDescStr = [NSString stringWithFormat:@"后日"];
        }
    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////////

@implementation StartStationCollegeEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.keyId = [[dict safeObjectForKey:@"id"] integerValue];
        // self.collegeNameStr = [dict objectForKey:@"CollegeName"];
        self.locationStr = [dict objectForKey:@"name"];
    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////////

@implementation EndStationEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.keyId = [[dict safeObjectForKey:@"id"] integerValue];
        self.stationNameStr = [dict objectForKey:@"name"];
    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////////

@implementation PassengersEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end
