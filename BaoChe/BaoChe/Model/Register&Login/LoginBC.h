//
//  LoginBC.h
//  o2o
//
//  Created by leo on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestManager.h"

typedef void (^successHandle) (id successInfoObj);
typedef void (^failedHandle)  (NSError *error);


@interface LoginBC : NSObject<NetRequestDelegate>

/// 账号密码登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                autoLogin:(BOOL)autoLogin
                  showHUD:(BOOL)show
            successHandle:(successHandle)success
             failedHandle:(failedHandle)failed;

/// 退出登录
- (void)logoutWithSuccessHandle:(successHandle)success
                   failedHandle:(failedHandle)failed;

@end
