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


