//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"

@interface AllBusListItemEntity : NetItem

@property (nonatomic, strong) NSString *questionStr;
@property (nonatomic, strong) NSString *answerStr;

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