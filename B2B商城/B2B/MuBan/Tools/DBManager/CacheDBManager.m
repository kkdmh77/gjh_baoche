//
//  CacheDBManager.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/4/14.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "CacheDBManager.h"

@interface CacheDBManager ()

@property (nonatomic, copy  ) NSString            *curDatabaseFilePath; // 当前的数据库路径
@property (nonatomic, strong) NSMutableDictionary *databaseQueuesDic;

@end

@implementation CacheDBManager

DEF_SINGLETON(CacheDBManager);

- (void)configureProperties
{
    [self changeToDatabaseWithName:kCacheDBFileName];

    [self creatSearchHistoryModelTabel];
}

- (BOOL)creatSearchHistoryModelTabel
{
    return [self creatTableWithSql:@"CREATE TABLE IF NOT EXISTS search_history (_id INTEGER PRIMARY KEY, wordId INTEGER, word TEXT, detail TEXT, americanVoice TEXT, englishVoice TEXT, creatTime INTEGER NOT NULL DEFAULT (strftime('%s','now')))"];
}

- (NSArray<AutoSearchWordModel *> *)selectAllSearchHistoryModels
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT wordId AS _id, word, detail, americanVoice, englishVoice FROM search_history ORDER BY creatTime DESC"];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                AutoSearchWordModel *model = [[AutoSearchWordModel alloc] initWithDictionary:set.resultDictionary];
                
                [resultArray addObject:model];
            }
        }];
        return resultArray;
    }
    return nil;
}

- (BOOL)insertSearchHistoryModel:(AutoSearchWordModel *)model
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        BOOL hasExist = [self hasSearchHistoryModelWithKeyword:model.word];
        __block BOOL flag = NO;

        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            // 已经存在了就更新时间
            if (hasExist) {
                flag = [db executeUpdate:@"UPDATE search_history SET creatTime = (strftime('%s','now')) WHERE word = ?", model.word];
            } else {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO search_history (wordId, word, detail, americanVoice, englishVoice) VALUES (%ld, '%@', '%@', '%@', '%@')", model._id, model.word, model.detail, model.americanVoice, model.englishVoice];
                flag = [db executeUpdate:sql];
            }
            
            // 回滚
            if (!flag) {
                *rollback = YES;
            }
        }];
        return flag;
    }
    return NO;
}

- (BOOL)deleteSearchHistoryModelWithKeyword:(NSString *)keyword
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        __block BOOL flag = NO;
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            flag = [db executeUpdate:@"DELETE FROM search_history WHERE word = ?", keyword];
            
            // 回滚
            if (!flag) {
                *rollback = YES;
            }
        }];
        return flag;
    }
    return NO;
}

- (BOOL)hasSearchHistoryModelWithKeyword:(NSString *)keyword
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        __block BOOL flag = NO;
        
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *set = [db executeQuery:@"SELECT _id FROM search_history WHERE word = ?", keyword];
            if ([set next]) {
                flag = YES;
            }
        }];
        return flag;
    }
    return NO;
}

- (BOOL)cleanAllSearchHistoryModel
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        __block BOOL flag = NO;
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            flag = [db executeUpdate:@"DELETE FROM search_history"];
            
            // 回滚
            if (!flag) {
                *rollback = YES;
            }
        }];
        return flag;
    }
    return NO;
}

@end
