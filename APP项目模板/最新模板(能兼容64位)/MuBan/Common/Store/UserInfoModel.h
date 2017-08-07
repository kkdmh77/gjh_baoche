//
//  UserInfoModel.h
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "UserInfoEntity.h"

@interface UserInfoModel : Jastor

AS_SINGLETON(UserInfoModel);

/// 保存用户信息到磁盘
- (void)saveGlobalUserInfoModel;

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@property (nonatomic, strong) NSMutableDictionary *parameterDic;

@end
