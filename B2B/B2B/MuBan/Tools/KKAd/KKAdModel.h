//
//  KKAdModel.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/27.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@interface KKAdModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger adId;           ///< 广告ID
@property (nonatomic, copy  ) NSString  *imgUrlStr;     ///< 广告图片地址
@property (nonatomic, copy  ) NSString  *contentStr;    ///< 点击广告跳转时需要的信息，例如：网页链接/appId等
@property (nonatomic, assign) NSInteger targetType;     ///< 跳转类型 1: 网页链接 2: 跳转AppStore 3: 内部功能跳转 4: 不能操作只展示
@property (nonatomic, copy  ) NSString  *requestId;     ///< 请求ID，用于统计上报使用

@end
