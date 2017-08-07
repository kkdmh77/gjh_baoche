//
//  CacheDBManager.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/4/14.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "DBManager.h"
#import "AutoSearchWordModel.h"

static NSString * const kCacheDBFileName = @"cache.db";

@interface CacheDBManager : DBManager

AS_SINGLETON(CacheDBManager);

/**搜索历史
 *******************************************************/
- (BOOL)creatSearchHistoryModelTabel;
- (NSArray<AutoSearchWordModel *> *)selectAllSearchHistoryModels;
- (BOOL)insertSearchHistoryModel:(AutoSearchWordModel *)model;
- (BOOL)deleteSearchHistoryModelWithKeyword:(NSString *)keyword;
- (BOOL)hasSearchHistoryModelWithKeyword:(NSString *)keyword;
- (BOOL)cleanAllSearchHistoryModel;

@end
