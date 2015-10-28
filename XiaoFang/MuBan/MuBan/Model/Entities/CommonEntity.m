//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"

@implementation DataEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithNumber:(NSString *)number nameStr:(NSString *)name position:(NSString *)position value:(CGFloat)value leader:(NSString *)leader company:(NSString *)company mobilePhone:(NSString *)phone companyPosition:(NSString *)companyPosition
{
    self = [super init];
    if (self)
    {
        self.number = number;
        self.nameStr = name;
        self.positionStr = position;
        self.value = value;
        self.leaderNameStr = leader;
        self.companyStr = company;
        self.mobilePhoneStr = phone;
        self.companyPositionStr = companyPosition;
        self.coordinate = CLLocationCoordinate2DMake(0, 0);
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation WaterPressureEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "sid": "01",
         "sname": "滕头物联网科技自用",
         "presure": "0.2400",
         "telphone": "13957887266",
         "address": "奉化市江口民营科技园聚金路8号"
         */
        self.number = [dict safeObjectForKey:@"sid"];
        self.name = [dict safeObjectForKey:@"sname"];
        self.value = [dict safeObjectForKey:@"presure"];
        self.phone = [dict safeObjectForKey:@"telphone"];
        self.position = [dict safeObjectForKey:@"address"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation WaterPressureDetailEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "sid": "01",
         "type": "室内试验功能板",
         "responsibility": "赵永军",
         "resPhone": "13957887266",
         "resOrg": "奉化消防大队",
         "resOrgPhone": "0574-88689806",
         "address": "奉化市江口民营科技园聚金路8号",
         "number": "75"
         */
        NSDictionary *detailDic = [dict safeObjectForKey:@"infor"];
        NSArray *collectDataArray = [dict safeObjectForKey:@"list"];

        self.monitoringStations = [detailDic safeObjectForKey:@"sid"];
        self.monitoringType = [detailDic safeObjectForKey:@"type"];
        self.leaderName = [detailDic safeObjectForKey:@"responsibility"];
        self.leaderPhone = [detailDic safeObjectForKey:@"resPhone"];
        self.company = [detailDic safeObjectForKey:@"resOrg"];
        self.companyPhone = [detailDic safeObjectForKey:@"resOrgPhone"];
        self.position = [detailDic safeObjectForKey:@"address"];
        
        NSMutableArray *collectEntityArray = [NSMutableArray array];
        for (NSDictionary *dataDic in collectDataArray)
        {
            WaterPressureDetail_CollectListEntity *entity = [WaterPressureDetail_CollectListEntity initWithDict:dataDic];
            [collectEntityArray addObject:entity];
        }
        self.collectListEntityArray = collectEntityArray;
    }
    return self;
}

@end

// -----------------------------------------------------------

@implementation WaterPressureDetail_CollectListEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "presure": "0.2400",
         "time": "2015-08-04 08:21:53",
         "remark": ""
         */
        self.value = [dict safeObjectForKey:@"presure"];
        self.collectTime = [dict safeObjectForKey:@"time"];
        self.note = [dict safeObjectForKey:@"remark"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation MapPositionEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "sid": "01",
         "sname": "滕头物联网科技自用",
         "longitude": "121.41",
         "latitude": "29.66"
         */
        self.position = [dict safeObjectForKey:@"sname"];
        self.coordinate = CLLocationCoordinate2DMake([[dict safeObjectForKey:@"latitude"] doubleValue], [[dict safeObjectForKey:@"longitude"] doubleValue]);
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation MonitoringDataListEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "sid": "01",
         "sname": "滕头物联网科技自用",
         "address": "奉化市江口民营科技园聚金路8号",
         "presure": "1.3900"
         */
        self.number = [dict safeObjectForKey:@"sid"];
        self.name = [dict safeObjectForKey:@"sname"];
        self.position = [dict safeObjectForKey:@"address"];
        self.value = [dict safeObjectForKey:@"presure"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation WarningDataListEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        /*
         "id": "1",
         "fid": "1",
         "type": "报警",
         "sid": "1",
         "date": "2015-08-04",
         "time": "12:53:40"
         */
        self.number = [dict safeObjectForKey:@"sid"];
        self.warningType = [dict safeObjectForKey:@"type"];
        self.warningDate = [dict safeObjectForKey:@"date"];
        self.warningTime = [dict safeObjectForKey:@"time"];
    }
    return self;
}

@end

