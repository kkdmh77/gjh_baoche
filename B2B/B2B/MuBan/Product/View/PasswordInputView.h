//
//  PasswordInputView.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/23.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordInputView;

typedef NS_ENUM(NSInteger, PasswordInputViewActionType) {
    /// 关闭
    PasswordInputViewActionTypeClose = 0,
    /// 确定
    PasswordInputViewActionTypeConfirm,
    /// 忘记密码
    PasswordInputViewActionTypeForgotPassword
};

typedef void (^PasswordInputViewActionHandle) (PasswordInputView *view,
                                               PasswordInputViewActionType type,
                                               id sender);

@interface PasswordInputView : UIView

@property (nonatomic, copy) PasswordInputViewActionHandle actionHandle;
@property (nonatomic, copy, readonly) NSString *inputPassword;

@end

////////////////////////////////////////////////////////////////////////////////

@interface PasswordInputViewManager : NSObject

AS_SINGLETON(PasswordInputViewManager);

- (void)showWithTitle:(NSString *)title
                 desc:(NSString *)desc
         actionHandle:(PasswordInputViewActionHandle)handle;

- (void)hide;

@end
