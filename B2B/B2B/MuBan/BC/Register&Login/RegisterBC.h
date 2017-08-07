//
//  RegisterBC.h
//  o2o
//
//  Created by swift on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestManager.h"

typedef void (^successHandle) (id successInfoObj);
typedef void (^failedHandle)  (NSError *error);

@interface RegisterBC : NSObject <NetRequestDelegate>

AS_SINGLETON(RegisterBC);

/// 是否为有效的密码
+ (BOOL)passwordIsAbsoluteValid:(NSString *)password;

/// 获取验证码
- (void)getVerificationCodeWithMobilePhoneNumber:(NSString *)phoneNumber
                                isModifyPassword:(BOOL)isModifyPassword
                                   successHandle:(successHandle)success
                                    failedHandle:(failedHandle)failed;

/// 验证码校验
- (void)verificationCodeCheckWithMobilePhoneNumber:(NSString *)phoneNumber
                                  verificationCode:(NSString *)verificationCode
                                     successHandle:(successHandle)success
                                      failedHandle:(failedHandle)failed;

/// 手机注册
- (void)registerWithMobilePhoneUserName:(NSString *)userName
                               password:(NSString *)password
                        passwordConfirm:(NSString *)passwordConfirm
                       verificationCode:(NSString *)verificationCode
                          successHandle:(successHandle)success
                           failedHandle:(failedHandle)failed;

/// 邮箱注册
- (void)registerWithEmailUserName:(NSString *)userName
                         password:(NSString *)password
                  passwordConfirm:(NSString *)passwordConfirm
                    successHandle:(successHandle)success
                     failedHandle:(failedHandle)failed;

/// 普通用户名注册
- (void)registerWithNormalUserName:(NSString *)userName
                          password:(NSString *)password
                   passwordConfirm:(NSString *)passwordConfirm
                     successHandle:(successHandle)success
                      failedHandle:(failedHandle)failed;

/// 手机验证码修改密码
- (void)modifyPasswordWithMobilePhoneNum:(NSString *)phoneNum
                             newPassword:(NSString *)password
                         passwordConfirm:(NSString *)passwordConfirm
                        verificationCode:(NSString *)verificationCode
                           successHandle:(successHandle)success
                            failedHandle:(failedHandle)failed;

@end
