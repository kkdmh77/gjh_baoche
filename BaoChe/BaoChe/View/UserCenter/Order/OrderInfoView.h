//
//  OrderInfoView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/2.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface OrderInfoView : UIView

+ (CGFloat)getViewHeight;
- (void)loadViewShowDataWithItemEntity:(OrderListEntity *)entity;

@end
