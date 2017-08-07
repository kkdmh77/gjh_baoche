//
//  UserInfoModel.m
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "UserInfoModel.h"

#define kUserInfoModelPlistFileName @"userInfo.plist"

@implementation UserInfoModel

+ (UserInfoModel *)sharedInstance
{
    static dispatch_once_t once;
    static UserInfoModel * singleton = nil;
    WEAKSELF
    dispatch_once( &once, ^{
        NSString *path = GetDocumentPathFileName(kUserInfoModelPlistFileName);
        if (IsFileExists(path)) {
            singleton = [weakSelf getUserInfoModelFromPath:path];
        } else {
            singleton = [[UserInfoModel alloc] init];
        }
    } );
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self configureDefaultValues];
    }
    return self;
}

// 设置每个属性的默认值
- (void)configureDefaultValues
{
    self.parameterDic = [NSMutableDictionary dictionary];
}

- (void)saveGlobalUserInfoModel
{
    NSString *path = GetDocumentPathFileName(kUserInfoModelPlistFileName);
    if (IsFileExists(path)) {
        DeleteFiles(path);
    }
    NSDictionary *dictionary = [self toDictionary];
    [dictionary writeToFile:path atomically:YES];
}

+ (UserInfoModel *)getUserInfoModelFromPath:(NSString *)path
{
    if (IsFileExists(path))
    {
        NSMutableDictionary *userInfoPlistDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
        UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:userInfoPlistDic];
        return model;
    }
    return [[UserInfoModel alloc] init];
}

+ (void)setObject:(id)value forKey:(NSString *)key
{
    if ([self sharedInstance].parameterDic)
    {
        [[self sharedInstance].parameterDic setObject:value forKey:key];
    }
}

+ (id)objectForKey:(NSString *)key
{
    if ([self sharedInstance].parameterDic)
    {
        return [[self sharedInstance].parameterDic safeObjectForKey:key];
    }
    return nil;
}

@end
