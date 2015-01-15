//
//  SettlementView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/4.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettlementView;

typedef NS_ENUM(NSInteger, SettlementViewOperationType)
{
    /// 结算
    SettlementViewOperationType_Settlement = 0,
};

typedef void (^SettlementViewOperationHandle) (SettlementView *view, SettlementViewOperationType type, id sender);

@interface SettlementView : UIView

@property (nonatomic, copy) SettlementViewOperationHandle operationHandle;
@property (nonatomic, readonly) double totalPrice;

/**
 @ 方法描述 : 设置结算描述
 @ 输入参数 : price: 价格, count: 购买票的张数
 @ 返回值   : void
 @ 创建人   : 龚俊慧
 @ 创建时间 : 2015-01-04
 */
- (void)setSettlementPrice:(double)price count:(NSInteger)count;

@end
