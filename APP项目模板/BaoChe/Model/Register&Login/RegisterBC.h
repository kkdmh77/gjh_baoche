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

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed;

@end
