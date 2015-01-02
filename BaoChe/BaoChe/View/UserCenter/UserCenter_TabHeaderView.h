//
//  UserCenter_TabHeaderView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCenter_TabHeaderView;

typedef NS_ENUM(NSInteger, UserCenterTabHeaderViewOperationType)
{
    /// 点击用户头像
    UserCenterTabHeaderViewOperationType_UserHeaderImageBtn = 0,
    /// 查看所有订单
    UserCenterTabHeaderViewOperationType_CheckAllOrder,
};

typedef void (^UserCenterTabHeaderViewOperationHandle) (UserCenter_TabHeaderView *view, UserCenterTabHeaderViewOperationType type, id sender);

@interface UserCenter_TabHeaderView : UIView

@property (nonatomic, copy) UserCenterTabHeaderViewOperationHandle operationHandle;

+ (CGFloat)getViewHeight;

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserCenter_TabSectionHeaderView : UIButton

@property (nonatomic, assign) BOOL canOperation; // default is YES

- (void)setTitleString:(NSString *)title;

@end

