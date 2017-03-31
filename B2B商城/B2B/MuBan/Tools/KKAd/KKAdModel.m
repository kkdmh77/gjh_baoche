//
//  KKAdModel.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/27.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKAdModel.h"

@implementation KKAdModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"adId": @"id",
             @"imgUrlStr": @"imgUri",
             @"contentStr": @"targetUrl",
             @"targetType": @"targetType"};
}

@end
