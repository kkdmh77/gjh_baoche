//
//  UserInfoCache.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/22.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "UserInfoCache.h"

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
            
            if ([property.name isEqualToString:@"NSObject"]) {
                value = [NSArray modelArrayWithClass:[NSObject class] json:value];
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
