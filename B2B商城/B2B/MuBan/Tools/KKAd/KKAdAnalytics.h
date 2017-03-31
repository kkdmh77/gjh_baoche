//
//  KKAdAnalytics.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 广告统计
 */
@interface KKAdAnalytics : NSObject

/**
 * @method 上报广告数据(如果失败，连续尝试3次，再失败则放弃上报)
 * @param  adObjToAnalytics: 需要被统计的广告对象，目前是统计了广告的显示时长
 * @param  stateCode: KKAdCode
 * @param  adStartShowTimeInterval: 广告开始展示的时间，Since1970的秒数
 * @创建人  龚俊慧
 * @creat  2017-03-07
 */
+ (void)uploadAdEvent:(NSObject *)adObjToAnalytics
            stateCode:(NSInteger)stateCode
adStartShowTimeInterval:(NSTimeInterval)adStartShowTimeInterval;

@end
