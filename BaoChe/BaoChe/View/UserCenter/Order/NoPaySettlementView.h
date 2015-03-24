//
//  SettlementView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/4.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoPaySettlementView;

typedef NS_ENUM(NSInteger, NoPaySettlementViewOperationType)
{
    /// 去支付
    NoPaySettlementViewOperationType_Settlement = 0,
    /// 取消订单
    NoPaySettlementViewOperationType_CancelOrder,
};

typedef NS_ENUM(NSInteger, ViewType)
{
    /// 未支付
    ViewType_OrderNoPay = 0,
    /// 已取消
    ViewType_OrderAlreadyCancel,
};

typedef void (^NoPaySettlementViewOperationHandle) (NoPaySettlementView *view,
                                                    NoPaySettlementViewOperationType type,
                                                    id sender);

@interface NoPaySettlementView : UIView

@property (nonatomic, assign) ViewType type; // 默认为ViewType_OrderNoPay
@property (nonatomic, copy) NoPaySettlementViewOperationHandle operationHandle;

@end
