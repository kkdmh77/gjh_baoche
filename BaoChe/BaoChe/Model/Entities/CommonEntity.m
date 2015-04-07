//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"
#import "UrlManager.h"

@implementation AllBusListItemEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.keyId = [[dict safeObjectForKey:@"id"] integerValue];
        self.busNameStr = [NSString stringWithFormat:@"%@次",[dict safeObjectForKey:@"classes"]];
        self.busTypeStr = [dict safeObjectForKey:@"name"];
        self.startStation = [dict safeObjectForKey:@"origin"];
        self.endStation = [dict safeObjectForKey:@"destination"];
        self.passStation = [dict safeObjectForKey:@"pass"];
        self.price = [[dict safeObjectForKey:@"price"] doubleValue] / 100;
        
        NSTimeInterval startTime = [[dict safeObjectForKey:@"leaveTime"] doubleValue] / 1000;
        NSTimeInterval endTime = [[dict safeObjectForKey:@"arriveTime"] doubleValue] / 1000;
        
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
        self.keyId = [[dict safeObjectForKey:@"id"] integerValue];
        self.nameStr = [dict safeObjectForKey:@"passengName"];
        self.mobilePhoneStr = [dict safeObjectForKey:@"phone"];
    }
    return self;
}
@end

//////////////////////////////////////////////////////////////////////

@implementation UserEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.userHeaderImageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:[dict safeObjectForKey:@"userHeadUrl"]];
        self.emailStr = [dict safeObjectForKey:@"email"];
        self.userNicknameStr = [dict safeObjectForKey:@"nickname"];
        self.mobilePhoneNumStr = [dict safeObjectForKey:@"phone"];
        self.userNameStr = [dict safeObjectForKey:@"userName"];
    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////////

@implementation OrderListEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        NSDictionary *orderInfoDic = [dict safeObjectForKey:@"orderInfo"];
        NSDictionary *busInfoDic = [dict safeObjectForKey:@"cartInfo"];
        
        self.keyId = [[orderInfoDic safeObjectForKey:@"id"] integerValue];
        self.busInfoEntity = [AllBusListItemEntity initWithDict:busInfoDic];
        self.teamMobilePhone = [[busInfoDic safeObjectForKey:@"team"] safeObjectForKey:@"telephone"];
        self.orderNo = [orderInfoDic safeObjectForKey:@"orderNo"];
        self.orderStatus = [orderInfoDic safeObjectForKey:@"orderStatus"];
        self.orderTotalFee = [[orderInfoDic safeObjectForKey:@"orderTotalFee"] doubleValue] / 100;
        self.orderTime = [[orderInfoDic safeObjectForKey:@"orderTime"] doubleValue] / 1000;
        self.mobilePhoneNumStr = [orderInfoDic safeObjectForKey:@"phone"];
        
        // 乘客信息数组
        NSArray *orderItemList = [orderInfoDic safeObjectForKey:@"orderItemList"];
        if ([orderItemList isAbsoluteValid])
        {
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:orderItemList.count];
            for (NSDictionary *oneOrderItem in orderItemList)
            {
                PassengersEntity *entity = [PassengersEntity new];
                entity.keyId = [[oneOrderItem safeObjectForKey:@"id"] integerValue];
                entity.nameStr = [oneOrderItem safeObjectForKey:@"userName"];
                entity.mobilePhoneStr = [oneOrderItem safeObjectForKey:@"phone"];
                entity.afterSaleStatus = [oneOrderItem safeObjectForKey:@"afterSaleStatus"];
                
                [tempArray addObject:entity];
            }
            self.passengersArray = tempArray;
        }
    }
    return self;
}

@end
