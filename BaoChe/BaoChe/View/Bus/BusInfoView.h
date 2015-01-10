//
//  OrderWriteTabHeaderView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/22.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

/// 订单班车信息
@interface BusInfoView : UIView

+ (CGFloat)getViewHeight;
- (void)loadViewShowDataWithItemEntity:(AllBusListItemEntity *)entity;

@end

////////////////////////////////////////////////////////////////////////////////

/// 订单联系人信息
@interface OrderContactInfoView : UIView

+ (CGFloat)getViewHeight;

@end