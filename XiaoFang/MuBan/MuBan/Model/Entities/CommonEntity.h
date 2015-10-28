//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"
#import <CoreLocation/CoreLocation.h>

@interface DataEntity : NetItem

- (id)initWithNumber:(NSString *)number nameStr:(NSString *)name position:(NSString *)position value:(CGFloat)value leader:(NSString *)leader company:(NSString *)company mobilePhone:(NSString *)phone companyPosition:(NSString *)companyPosition;

@property (nonatomic, copy) NSString *number;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *positionStr;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) NSString *leaderNameStr;
@property (nonatomic, strong) NSString *companyStr;
@property (nonatomic, strong) NSString *mobilePhoneStr;
@property (nonatomic, strong) NSString *companyPositionStr;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

///////////////////////////////////////////////////////////////

@interface WaterPressureEntity : NetItem

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *position;

@end

///////////////////////////////////////////////////////////////

@interface WaterPressureDetailEntity : NetItem

@property (copy, nonatomic) NSString *monitoringStations;
@property (copy, nonatomic) NSString *monitoringType;
@property (copy, nonatomic) NSString *leaderName;
@property (copy, nonatomic) NSString *leaderPhone;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *companyPhone;
@property (copy, nonatomic) NSString *position;

@property (nonatomic, strong) NSArray *collectListEntityArray;

@end

// -----------------------------------------------------------

@interface WaterPressureDetail_CollectListEntity : NetItem

@property (copy, nonatomic)  NSString *value;
@property (copy, nonatomic)  NSString *collectTime;
@property (copy, nonatomic)  NSString *note;

@end

///////////////////////////////////////////////////////////////

@interface MapPositionEntity : NetItem

@property (copy, nonatomic) NSString *position;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

///////////////////////////////////////////////////////////////

@interface MonitoringDataListEntity : NetItem

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *value;

@end

//-----------------------------------------------------------

@interface MonitoringValueDetailEntity : NetItem

@property (copy, nonatomic) NSString *monitoringStations;
@property (copy, nonatomic) NSString *monitoringType;
@property (copy, nonatomic) NSString *leaderName;
@property (copy, nonatomic) NSString *leaderPhone;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *companyPhone;
@property (copy, nonatomic) NSString *position;

@end

///////////////////////////////////////////////////////////////

@interface WarningDataListEntity : NetItem

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *fId;
@property (copy, nonatomic) NSString *warningType;
@property (copy, nonatomic) NSString *warningDate;
@property (copy, nonatomic) NSString *warningTime;

@end

//-----------------------------------------------------------

@interface WarningValueDetailEntity : NetItem

// @property (copy, nonatomic) UILabel *number;
// @property (copy, nonatomic) UILabel *warningType;
// @property (copy, nonatomic) UILabel *warningDate;
// @property (copy, nonatomic) UILabel *warningTime;
@property (copy, nonatomic) NSString *warningReason;
@property (copy, nonatomic) NSString *solveDate;
@property (copy, nonatomic) NSString *solveTime;
@property (copy, nonatomic) NSString *solveResult;

@end


