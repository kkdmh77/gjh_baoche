//
//  AddressManagerVC.h
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"

static NSString * const PassengerManagerCellSelectedNotificationKey = @"PassengerManagerCellSelectedNotificationKey";

typedef NS_ENUM(NSInteger, UseType)
{
    /// 编辑地址
    UseType_Edit = 0,
    
    /// 选择地址
    UseType_Selector,
};

@interface PassengerManagerVC : BaseNetworkViewController

@property (nonatomic, assign) UseType   useType;                    // default is UseType_Edit
@property (nonatomic, assign) NSInteger defaultSelectedAddressId;   // default is NSNotFound

@end
