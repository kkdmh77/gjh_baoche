//
//  PassengersCell.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@class PassengersCell;

typedef NS_ENUM(NSInteger, OperationButType)
{
    /// 联系人->无操作
    OperationButType_NoOperation = 0,
    /// 联系人->删除
    OperationButType_Delete,
    /// 订单详情->订单详情订票人->退票
    OperationButType_DetailOrder_ToRefundTicket,
    /// 订单详情->订单详情订票人->退票中...
    OperationButType_DetailOrder_DoingRefundTicket,
    /// 订单详情->订单详情订票人->已退票
    OperationButType_DetailOrder_AlreadyRefundTicket,
    /// 订单详情->订单详情订票人->已出票
    OperationButType_DetailOrder_GetTicket,
};

typedef void (^PassengersCellOperationHandle) (PassengersCell *cell, OperationButType type, id sender);

@interface PassengersCell : UITableViewCell

@property (nonatomic, assign) OperationButType btnType; // default is OperationButType_Delete
@property (nonatomic, copy) PassengersCellOperationHandle operationHandle;

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(PassengersEntity *)entity;

@end
