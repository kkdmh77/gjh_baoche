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
        self.questionStr = [dict objectForKey:@"question"];
        self.answerStr = [dict objectForKey:@"answer"];
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
