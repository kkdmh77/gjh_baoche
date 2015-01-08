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
        self.timeRequired = [NSString stringWithFormat:@"%d时%d分钟", hours, minutes];
        if (0 == days)
        {
            self.endTimeStr = [NSString stringWithFormat:@"当日%@", [NSDate stringFromTimeIntervalSeconds:endTime withFormatter:DataFormatter_TimeNoSecond]];
        }
        else if (1 == days)
        {
            self.endTimeStr = [NSString stringWithFormat:@"次日%@", [NSDate stringFromTimeIntervalSeconds:endTime withFormatter:DataFormatter_TimeNoSecond]];
        }
        else if (2 == days)
        {
            self.endTimeStr = [NSString stringWithFormat:@"后日%@", [NSDate stringFromTimeIntervalSeconds:endTime withFormatter:DataFormatter_TimeNoSecond]];
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
        self.keyId = [[dict safeObjectForKey:@"CollegeId"] integerValue];
        self.collegeNameStr = [dict objectForKey:@"CollegeName"];
        self.locationStr = [dict objectForKey:@"Location"];
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
        self.keyId = [[dict safeObjectForKey:@"BusId"] integerValue];
        self.stationNameStr = [dict objectForKey:@"EndLocation"];
    }
    return self;
}

@end
