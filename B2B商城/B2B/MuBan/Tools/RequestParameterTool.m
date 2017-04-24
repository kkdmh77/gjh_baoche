//
//  RequestParameterTool.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/14.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "RequestParameterTool.h"
#import <NerdyUI.h>

#define kAppVersion @"I".a(@"-").a(APP_VERSION)

@implementation RequestParameterTool

+ (NSDictionary *)parameterWithMethodName:(NSString *)methodName {
    /*
     {
     "id":1330395827,
     "service":"system.init",
     "md5":"4020b5f131e0770179a526362b5b8dc2",
     "client":{"appid":"","ver":"A-1.0.1","cs”:"1001"},
     "data":{"imei":"2343243432432","imsi":"3432432432432","sys":1,"sysver":"5.1.1","ss":"480*320"}
     }
     
     md5(id + service + client + data + key),空项用""
     */
    
    if (![methodName isValidString]) return nil;
    
    long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *md5Key = [kMD5 isValidString] ? kMD5 : @"f321&F321";
    
    NSDictionary *client = @{@"appid": [kAppId isValidString] ? kAppId : @"",
                             @"ver": kAppVersion,
                             @"cs": @1001};
    NSDictionary *data = @{@"sys": @2,
                           @"sysver": [UIDevice currentDevice].systemVersion};
    
    NSString *token = Str(timeInterval).a(methodName).a([client modelToJSONString]).a([data modelToJSONString]).a(md5Key).md5String;
    
    return @{@"id": @(timeInterval),
             @"service": methodName,
             @"md5": token,
             @"client": client,
             @"data": data};
}

@end

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

@implementation BaseTabBarItemModel

@end

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

@implementation UserInfoCache

DEF_SINGLETON(UserInfoCache);

+ (YYCache *)cache {
    static YYCache *cache = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cache = [[YYCache alloc] initWithName:@"app_data_cache"];
    });
    return cache;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        for (YYClassPropertyInfo *property in [self propertyInfos]) {
            [self addObserver:self forKeyPath:property.name
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
            
            // 加载已经保存在磁盘里的值
            id value = [[UserInfoCache cache] objectForKey:property.name];
            
            if ([property.name isEqualToString:@"tabBarItemModelArray"]) {
                value = [NSArray modelArrayWithClass:[BaseTabBarItemModel class] json:value];
            }
            
            [self setValue:value forKey:property.name];
        }
    }
    return self;
}

- (void)dealloc {
    for (YYClassPropertyInfo *property in [self propertyInfos]) {
        [self removeObserver:self forKeyPath:property.name];
    }
}

- (NSArray<YYClassPropertyInfo *> *)propertyInfos {
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:[self class]];
    
    return classInfo.propertyInfos.allValues;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    id oldValue = [[UserInfoCache cache] objectForKey:keyPath];

    id newsJSONObject = [newValue modelToJSONObject];
    BOOL isNewEqualToOld = [newsJSONObject modelIsEqual:oldValue];
    
    // 是不是json格式的数据
    BOOL isJson = ([NSJSONSerialization isValidJSONObject:newValue] || [NSJSONSerialization isValidJSONObject:newsJSONObject]);

    if (isJson) {
        if (!isNewEqualToOld) {
            [[UserInfoCache cache] setObject:newsJSONObject forKey:keyPath];
        }
    } else {
        [[UserInfoCache cache] setObject:newValue forKey:keyPath];
    }
}

@end
