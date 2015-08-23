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

