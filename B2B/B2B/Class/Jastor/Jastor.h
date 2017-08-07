//
//  Jastor.h
//  Jastor
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//

@interface Jastor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *objectId;
+ (id)objectFromDictionary:(NSDictionary*)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;

- (NSDictionary *)map;

/**
 @ 方法描述: 配置默认值(子类实现)
 @ 输入参数: 无
 @ 返回值:   void
 @ 创建人:   龚俊慧
 @ Creat:   2016-01-19
 */
- (void)configureDefaultValues;

@end
