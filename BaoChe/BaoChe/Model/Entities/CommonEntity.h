//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"

@interface AllBusListItemEntity : NetItem

@property (nonatomic, assign) NSInteger keyId;
@property (nonatomic, copy) NSString *busNameStr;
@property (nonatomic, copy) NSString *busTypeStr;
@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;
@property (nonatomic, copy) NSString *endDateRequireDescStr; // 次日、当日等
@property (nonatomic, copy) NSString *startTime_DateStr;
@property (nonatomic, copy) NSString *endTime_DateStr;
@property (nonatomic, copy) NSString *startStation;
@property (nonatomic, copy) NSString *endStation;
@property (nonatomic, copy) NSString *timeRequired;
@property (nonatomic, copy) NSString *passStation;
@property (nonatomic, assign) double price;

@end

////////////////////////////////////////////////////////////////
/// 出发点院校

@interface StartStationCollegeEntity : NetItem

@property (nonatomic, assign) NSInteger keyId;
@property (nonatomic, copy) NSString *collegeNameStr;
@property (nonatomic, copy) NSString *locationStr;

@end

////////////////////////////////////////////////////////////////
/// 目的地

@interface EndStationEntity : NetItem

@property (nonatomic, assign) NSInteger keyId;
@property (nonatomic, copy) NSString *stationNameStr;

@end