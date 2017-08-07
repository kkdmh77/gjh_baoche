//
//  UserInfoEntity.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/28.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoEntity : NSObject

@property (nonatomic, copy  ) NSString       *userId;
@property (nonatomic, copy  ) NSString       *accessToken;
@property (nonatomic, copy  ) NSString       *headerImageUlrStr;    //!< 图像
@property (nonatomic, copy  ) NSString       *nickname;             //!< 昵称
@property (nonatomic, copy  ) NSString       *mobilePhoneNum;       //!< 手机号码
@property (nonatomic, copy  ) NSString       *city;                 //!< 城市
@property (nonatomic, assign) NSTimeInterval birthdayInterval;      //!< 生日（秒）

@end
