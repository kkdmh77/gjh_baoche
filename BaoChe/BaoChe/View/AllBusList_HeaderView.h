//
//  AllBusList_HeaderView.h
//  BaoChe
//
//  Created by swift on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllBusList_HeaderView;

typedef  NS_ENUM(NSInteger, AllBusListHeaderViewOperationType)
{
    /// 上一天
    AllBusListHeaderViewOperationType_PreDay = 0,
    /// 当前显示的日期
    AllBusListHeaderViewOperationType_CurShowDay,
    /// 下一天
    AllBusListHeaderViewOperationType_NextDay,
};

typedef void(^AllBusListHeaderViewOperationHandle) (AllBusList_HeaderView *view, AllBusListHeaderViewOperationType type);

@interface AllBusList_HeaderView : UIView

@property (nonatomic, copy) AllBusListHeaderViewOperationHandle operationType;

- (void)setCurShowDateBtnTitle:(NSString *)title;
- (NSString *)curShowDateBtnTitle;

@end
