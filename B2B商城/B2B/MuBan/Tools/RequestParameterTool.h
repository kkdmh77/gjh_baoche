//
//  RequestParameterTool.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/14.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoCache;

NS_ASSUME_NONNULL_BEGIN

static NSString * kAppIdKey = @"kAppIdKey";
static NSString * kMD5KeyKey = @"kMD5KeyKey";

static NSString * const kUlrStr = @"http://120.76.188.84:89/api/clientService.do";

#define kAppId ((NSString *)[[UserInfoCache cache] objectForKey:kAppIdKey])
#define kMD5 ((NSString *)[[UserInfoCache cache] objectForKey:kMD5KeyKey])

@interface RequestParameterTool : NSObject

+ (NSDictionary *)parameterWithMethodName:(NSString *)methodName;

@end

////////////////////////////////////////////////////////////////////////////////

@interface BaseTabBarItemModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *selectedIcon;
@property (nonatomic, copy) NSString *url;

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserInfoCache : NSObject

AS_SINGLETON(UserInfoCache);

+ (YYCache *)cache;

@property (nullable ,nonatomic, strong) NSArray<BaseTabBarItemModel *> *tabBarItemModelArray;

@end

NS_ASSUME_NONNULL_END
