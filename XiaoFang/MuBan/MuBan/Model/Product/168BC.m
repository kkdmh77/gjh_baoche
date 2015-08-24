//
//  168BC.m
//  o2o
//
//  Created by swift on 14-10-15.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "168BC.h"

@implementation _168BC

+ (void)parseDataFromSourceDic:(NSDictionary *)dic prePromotionDataContainer:(NSMutableArray *__strong *)preContainer andCurContainer:(NSMutableArray *__strong *)curContainer nextContainer:(NSMutableArray *__strong *)nextContainer
{
    if (!*preContainer)
    {
        *preContainer = [NSMutableArray array];
    }
    if (!*curContainer)
    {
        *curContainer = [NSMutableArray array];
    }
    if (!*nextContainer)
    {
        *nextContainer = [NSMutableArray array];
    }
    
    NSDictionary *promotionDic = [dic objectForKey:@"promotionTopicMap"];
    
   
}

// 数据排序,把主打的产品(每一期只有一个主推产品)放到数组的第一位
+ (void)sortArrayDataWithPrePromotionArray:(NSMutableArray *)preArray andCurPromotionArray:(NSMutableArray *)curArray nextPromotionArray:(NSMutableArray *)nextArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tag == %d",3];
    
    
}


@end
