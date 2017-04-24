//
//  NavMenuView.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@interface NavMenuItem : NSObject

- (instancetype)initWithText:(NSString *)text imageSource:(NSString *)imageSource;

@property (nonatomic, copy) NSString *imageNameOrUlrStr; ///< 图片
@property (nonatomic, copy) NSString *text; ///< 文字
@property (nonatomic, strong) id userInfo; ///< 用户信息

@end

////////////////////////////////////////////////////////////////////////////////

@interface NavMenuView : UIView

@end

////////////////////////////////////////////////////////////////////////////////

@interface NavMenuViewManager : NSObject

+ (void)presentNavMenuWithMenuItems:(NSArray<NavMenuItem *> *)items
                         targetView:(UIView *)targetView
                             inView:(UIView *)containerView
                     selectedHandle:(void (^) (NSInteger index, NavMenuItem *selectedItem))selectedHandle;

@end
