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
//@property (nonatomic, copy) NSString *collegeNameStr;
@property (nonatomic, copy) NSString *locationStr;

@end

////////////////////////////////////////////////////////////////
/// 目的地

@interface EndStationEntity : NetItem

@property (nonatomic, assign) NSInteger keyId;
@property (nonatomic, copy) NSString *stationNameStr;

@end

////////////////////////////////////////////////////////////////
/// 联系人

@interface PassengersEntity : NetItem

@property (nonatomic, assign) NSInteger keyId;
@property (nonatomic, copy) NSString *nameStr;           // 联系人名称
@property (nonatomic, copy) NSString *mobilePhoneStr;    // 手机号码
@property (nonatomic, copy) NSString *afterSaleStatus;   // 付款后的使用状态

@end

////////////////////////////////////////////////////////////////
/// 用户信息
@interface UserEntity : NetItem

@property (nonatomic, copy)     NSString  *userHeaderImageUrlStr;       // 用户头像
@property (nonatomic, copy)     NSString  *userNameStr;                 // 用户名
@property (nonatomic, copy)     NSString  *userNicknameStr;             // 昵称
@property (nonatomic, copy)     NSString  *emailStr;                    // 邮箱
@property (nonatomic, copy)     NSString  *QQStr;                       // QQ
@property (nonatomic, copy)     NSString  *mobilePhoneNumStr;           // 手机号码
@property (nonatomic, assign)   NSInteger notPayOrderCount;             // 未支付订单数

@end

////////////////////////////////////////////////////////////////
/// 订单信息
@interface OrderListEntity : NetItem

@property (nonatomic, assign)   NSInteger keyId;

@property (nonatomic, strong)   AllBusListItemEntity  *busInfoEntity;       // 班车信息
@property (nonatomic, strong)   NSArray  *passengersArray;                  // 乘客信息数组

@property (nonatomic, copy)     NSString  *orderNo;                         // 订单号
@property (nonatomic, copy)     NSString  *orderStatus;                     // 订单状态
@property (nonatomic, assign)   double    orderTotalFee;                    // 订单总价
@property (nonatomic, assign)   NSTimeInterval orderTime;                   // 下单时间
@property (nonatomic, copy)     NSString  *mobilePhoneNumStr;               // 手机号码

@end

