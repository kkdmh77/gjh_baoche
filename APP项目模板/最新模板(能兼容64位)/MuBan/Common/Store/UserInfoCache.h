//
//  UserInfoCache.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/22.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoCache : NSObject

AS_SINGLETON(UserInfoCache);

+ (YYCache *)cache;

@property (nonatomic, strong) NSArray<NSObject *> *tabBarItemModelArray;

@end
