//
//  DBManager.m
//  KKDictionary
//
//  Created by KungJack on 11/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "DBManager.h"

/*
NSString *mixUpString() {
    
    int array[] = {49,26,24,2,49,51,102,52,51,57,55,50,54,100,50,100,52,53,50,50,49,32,45,132,5843,74};
    Byte byte[16];
    for (NSInteger i=4; i < 20; i++) {
        byte[i-4] = array[i];
    }
    return [[NSString alloc] initWithBytes:byte length:16 encoding:NSUTF8StringEncoding];
}

// @"13f439726d2d4522"
// byte[] bytes = new byte[4];
// bytes[0] = 0;
// bytes[1] = 0;
// bytes[2] = 0;
// bytes[3] = 0;
// String md5 = getMD5(bytes);
// 取md5字段中的奇数位再重新组合成新的字符串。
// 这样可以随用随取，0是很容易取到的（比如弄个看似有Bug的代码，就是为了生成一个0值）
#define MixUpKey 0xBB

void xorString(unsigned char *str, unsigned char key)
{
    unsigned char *p = str;
    while( ((*p) ^=  key) != '\0')  p++;
}
*/

@interface DBManager ()

// @property (nonatomic, strong) FMDatabase *dbManager;

@property (nonatomic, copy  ) NSString            *curDatabaseFilePath; // 当前的数据库路径
@property (nonatomic, strong) NSMutableDictionary *databaseQueuesDic;

@end

@implementation DBManager

DEF_SINGLETON(DBManager);

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.databaseQueuesDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)changeToDatabaseWithName:(NSString *)databaseName
{
    self.curDatabaseFilePath = nil;
    NSString *path = [NSString stringWithFormat:@"%@/%@",[FileManager getDBPath], databaseName];

    if (IsFileExists(path)) {
        self.curDatabaseFilePath = path;
        
        return YES;
    } else {
        if ([databaseName isEqualToString:@"cache.db"]) {
            self.curDatabaseFilePath = path;
            
            return YES;
        } else {
            path = GetApplicationPathFileName([databaseName stringByDeletingPathExtension], [databaseName pathExtension]);
            if (IsFileExists(path)) {
                self.curDatabaseFilePath = path;
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)changeToDatabaseWithPath:(NSString *)databasePath
{
    self.curDatabaseFilePath = nil;
    
    if (IsFileExists(databasePath)) {
        self.curDatabaseFilePath = databasePath;
        
        return YES;
    }
    return NO;
}

- (BOOL)changeToDefaultDatabase
{
    return [self changeToDatabaseWithName:@"bookyingyu.db"];
}

- (BOOL)changeToDatabaseWithFileType:(DBFileType)fileType
{
    NSString *fileName = [FileManager getFileNameByFileType:fileType];
        
    return [self changeToDatabaseWithName:fileName];
}

- (FMDatabaseQueue *)getCurDatabaseQueue
{
    if ([_curDatabaseFilePath isAbsoluteValid]) {
        FMDatabaseQueue *queue = [_databaseQueuesDic safeObjectForKey:_curDatabaseFilePath];
        
        if (queue) {
            return queue;
        } else {
            queue = [FMDatabaseQueue databaseQueueWithPath:_curDatabaseFilePath];
            
            [_databaseQueuesDic setObject:queue forKey:_curDatabaseFilePath];
            return queue;
        }
    }
    return nil;
}

/*
- (id)initWithDBPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.dbManager = [FMDatabase databaseWithPath:path];
    }
    return self;
}

- (id)initWithDBName:(NSString *)name
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",[FileManager getDBPath], name];
        
        if (IsFileExists(path)) {
            self.dbManager = [FMDatabase databaseWithPath:path];
        } else {
            if ([name isEqualToString:@"cache.db"]) {
                self.dbManager = [FMDatabase databaseWithPath:path];
            }
        }
    }
    return self;
}

- (id)initWithDefaultDBFile
{
    NSString *bundleDBPath = GetApplicationPathFileName(@"dictionary", @"db");
    
    return [self initWithDBPath:bundleDBPath];
}
*/

- (NSInteger)getDBVersion
{
    __block NSInteger version = 0;
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            version = db.userVersion;
        }];
    }
    return version;
}

#pragma mark - //////////////////////////////////////////////////////////////////

- (NSArray<AutoSearchWordModel *> *)autoSearchWordsByCharacters:(NSString *)characters
{
    NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, word, a AS americanVoice, e AS englishVoice, ext FROM word WHERE word LIKE '%@%%'", characters];
    
    return [self autoSearchWordsBySql:sql];
}

- (NSArray<AutoSearchWordModel *> *)autoSearchWordsByCharacters:(NSString *)characters pageCount:(NSInteger)pageCount pageSize:(NSInteger)pageSize
{
    NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, word, a AS americanVoice, e AS englishVoice, ext FROM word WHERE word LIKE '%@%%' LIMIT %ld,%ld", characters, (pageCount - 1) * pageSize, pageSize];
    
    return [self autoSearchWordsBySql:sql];
}

- (NSArray<AutoSearchWordModel *> *)autoSearchWordsBySql:(NSString *)sql
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];

    if (queue && [sql isAbsoluteValid]) {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *set = [db executeQuery:sql];
            
            while ([set next]) {
                AutoSearchWordModel *model = [[AutoSearchWordModel alloc] initWithDictionary:set.resultDictionary];
                
                // 解析单词解释
                NSString *extStr = [set.resultDictionary safeObjectForKey:@"ext"];
                if ([extStr isAbsoluteValid]) {
                    NSArray *wordExplainDicArray = [NSJSONSerialization JSONObjectWithData:[extStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                                   options:NSJSONReadingMutableContainers
                                                                                     error:NULL];
                    if ([wordExplainDicArray isAbsoluteValid]) {
                        NSMutableArray *wordExplainModelsArray = [NSMutableArray arrayWithCapacity:wordExplainDicArray.count];
                        
                        for (NSDictionary *wordExplainDic in wordExplainDicArray) {
                            WordExplainModel *explainModel = [[WordExplainModel alloc] init];
                            explainModel.wordType = [wordExplainDic safeObjectForKey:@"p"];
                            
                            // 解析解释列表
                            NSArray *tempArray = [wordExplainDic safeObjectForKey:@"is"];
                            if ([tempArray isAbsoluteValid]) {
                                explainModel.wordExplainArray = [NSMutableArray array];
                                explainModel.explainExampleDic = [NSMutableDictionary dictionary];
                                
                                for (NSDictionary *tempDic in tempArray) {
                                    NSString *explainStr = [tempDic safeObjectForKey:@"i"];  // 解释
                                    NSArray *exampleArray = [tempDic safeObjectForKey:@"s"]; // 解释对应的例句
                                    
                                    if ([explainStr isAbsoluteValid]) {
                                        [explainModel.wordExplainArray addObject:explainStr];
                                    }
                                    if ([explainStr isAbsoluteValid] && [exampleArray isAbsoluteValid]) {
                                        [explainModel.explainExampleDic setObject:exampleArray forKey:explainStr];
                                    }
                                }
                            }
                            
                            [wordExplainModelsArray addObject:explainModel];
                        }
                        
                        model.wordExplainModelsArray = wordExplainModelsArray;
                    }
                }
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

+ (NSDictionary *)gradeTypeMap
{
    return @{@(GradeType_JuniorHigh): @"初中",
             @(GradeType_SeniorHigh): @"高中"};
}

+ (GradeType)gradeTypeByGradeName:(NSString *)gradeName
{
    NSArray *keys = [[self gradeTypeMap] allKeysForObject:gradeName];
    
    if ([keys isAbsoluteValid]) {
        return [keys[0] integerValue];
    }
    return NSNotFound;
}

+ (NSString *)gradeNameByGradeType:(GradeType)gradeType
{
    return [[self gradeTypeMap] safeObjectForKey:@(gradeType)];
}

- (NSArray<TextbookBookModel *> *)selectBookModelsWithGradeType:(GradeType)gradeType
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];

        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *gradeName = [[self class] gradeNameByGradeType:gradeType];
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, press_id AS pressId, name AS bookNameStr, stage AS gradeStr, barcode FROM book WHERE stage = '%@' ORDER BY sequence ASC", gradeName];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookBookModel *model = [[TextbookBookModel alloc] initWithDictionary:set.resultDictionary];
                model.gradeType = [[self class] gradeTypeByGradeName:model.gradeStr];
                
                // 根据出版社ID查出版社名
                sql = [NSString stringWithFormat:@"SELECT name FROM press WHERE _id = %ld", model.pressId];
                FMResultSet *pressSet = [db executeQuery:sql];
                if ([pressSet next]) {
                    model.pressNameStr = [pressSet.resultDictionary safeObjectForKey:@"name"];
                }
                [pressSet close];
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

- (TextbookBookModel *)selectBookModelWithBarcode:(NSString *)barcode
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block TextbookBookModel *resultBook = nil;
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, press_id AS pressId, name AS bookNameStr, stage AS gradeStr, barcode FROM book WHERE barcode = '%@' ORDER BY sequence ASC", barcode];
            
            FMResultSet *set = [db executeQuery:sql];
            if ([set next]) {
                TextbookBookModel *model = [[TextbookBookModel alloc] initWithDictionary:set.resultDictionary];
                model.gradeType = [[self class] gradeTypeByGradeName:model.gradeStr];
                
                // 根据出版社ID查出版社名
                sql = [NSString stringWithFormat:@"SELECT name FROM press WHERE _id = %ld", model.pressId];
                FMResultSet *pressSet = [db executeQuery:sql];
                if ([pressSet next]) {
                    model.pressNameStr = [pressSet.resultDictionary safeObjectForKey:@"name"];
                }
                [pressSet close];
                
                resultBook = model;
            }
            [set close];
        }];
        
        return resultBook;
    }
    return nil;
}

- (NSArray<TextbookUnitModel *> *)selectUnitModelsWithBookId:(NSInteger)bookId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, book_id AS bookId, name AS unitNameStr, page_start AS pageStartNumber, sections FROM unit WHERE book_id = %ld ORDER BY sequence ASC", bookId];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookUnitModel *model = [[TextbookUnitModel alloc] initWithDictionary:set.resultDictionary];
                
                // 解析章节内容
                NSString *sectionsStr = [set.resultDictionary safeObjectForKey:@"sections"];
                if ([sectionsStr isAbsoluteValid]) {
                    NSArray *sectionDicArray = [NSJSONSerialization JSONObjectWithData:[sectionsStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:NULL];
                    if ([sectionDicArray isAbsoluteValid]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        
                        for (NSDictionary *dic in sectionDicArray) {
                            SectionModel *section = [[SectionModel alloc] init];
                            section.theId = [[dic safeObjectForKey:@"sid"] integerValue];
                            section.sectionNameStr = [dic safeObjectForKey:@"sn"];
                            section.pageStartNumber = [dic safeObjectForKey:@"pst"];
                            
                            [tempArray addObject:section];
                        }
                        model.sectionModelsArray = tempArray;
                    }
                }
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

- (NSArray<TextbookPageModel *> *)selectPageModelsWithBookId:(NSInteger)bookId unitId:(NSInteger)unitId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, book_id AS bookId, unit_id AS unitId, img, page_no AS inPageNumber, anchors FROM page WHERE book_id = %ld AND unit_id = %ld ORDER BY sequence ASC", bookId, unitId];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookPageModel *model = [[TextbookPageModel alloc] initWithDictionary:set.resultDictionary];
                
                // 解析图片
                NSData *imageData = [set.resultDictionary safeObjectForKey:@"img"];
                if (imageData) {
                    model.pageImage = [UIImage imageWithData:imageData];
                }
                
                // 解析锚点信息
                NSString *anchorsStr = [set.resultDictionary safeObjectForKey:@"anchors"];
                if ([anchorsStr isAbsoluteValid]) {
                    NSArray *anchorsDicArray = [NSJSONSerialization JSONObjectWithData:[anchorsStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:NULL];
                    if ([anchorsDicArray isAbsoluteValid]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        
                        for (NSDictionary *modelDic in anchorsDicArray) {
                            AnchorModel *anchor = [[AnchorModel alloc] init];
                            anchor.blockId = [[modelDic safeObjectForKey:@"bid"] integerValue];
                            anchor.y1 = [[modelDic safeObjectForKey:@"y1"] floatValue];
                            anchor.y2 = [[modelDic safeObjectForKey:@"y2"] floatValue];
                            
                            [tempArray addObject:anchor];
                        }
                        
                        model.anchorsArray = tempArray;
                    }
                }
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

- (NSArray<TextbookBlockModel *> *)selectBlockModelsWithBookId:(NSInteger)bookId unitId:(NSInteger)unitId sectionId:(NSInteger)sectionId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, name AS blockNameStr, book_id AS bookId, book_name AS bookNameStr, unit_id AS unitId, unit_name AS unitNameStr, page_start AS pageStartNumber, section_id AS sectionId, section_name AS sectionNameStr, type AS contentType FROM block WHERE book_id = %ld AND unit_id = %ld AND section_id = %ld ORDER BY sequence ASC", bookId, unitId, sectionId];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookBlockModel *model = [[TextbookBlockModel alloc] initWithDictionary:set.resultDictionary];
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

- (TextbookBlockModel *)blockDetailWithBlockId:(NSInteger)blockId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block TextbookBlockModel *resultModel = nil;

        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, name AS blockNameStr, book_id AS bookId, book_name AS bookNameStr, unit_id AS unitId, unit_name AS unitNameStr, page_start AS pageStartNumber, section_id AS sectionId, section_name AS sectionNameStr, type AS contentType, audio AS audioData, sentences FROM block WHERE _id = %ld", blockId];
            
            
            FMResultSet *set = [db executeQuery:sql];
            if ([set next]) {
                resultModel = [[TextbookBlockModel alloc] initWithDictionary:set.resultDictionary];
                
                // 解析句子内容
                NSString *sentencesStr = [set.resultDictionary safeObjectForKey:@"sentences"];
                if ([sentencesStr isAbsoluteValid]) {
                    NSArray *sentencesDicArray = [NSJSONSerialization JSONObjectWithData:[sentencesStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:NULL];
                    if ([sentencesDicArray isAbsoluteValid]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        
                        for (NSDictionary *dic in sentencesDicArray) {
                            SentenceModel *sentence = [[SentenceModel alloc] init];
                            sentence.englishOriginalStr = [dic safeObjectForKey:@"e"];
                            sentence.chineseTranslationStr = [dic safeObjectForKey:@"c"];
                            sentence.audioStartSecondPosition = [[dic safeObjectForKey:@"st"] floatValue] / 1000;
                            
                            [tempArray addObject:sentence];
                        }
                        resultModel.sentenceModelsArray = tempArray;
                    }
                }
            }
            [set close];
        }];
        
        return resultModel;
    }
    return nil;
}

- (NSArray<TextbookGrammarModel *> *)selectGrammarModelsWithBookId:(NSInteger)bookId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, book_id AS bookId, title AS titleStr, content AS contentH5Str FROM grammar WHERE book_id = %ld ORDER BY sequence ASC", bookId];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookGrammarModel *model = [[TextbookGrammarModel alloc] initWithDictionary:set.resultDictionary];
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

- (NSArray<TextbookVocabularyModel *> *)selectVocabularyModelsWithBookId:(NSInteger)bookId
{
    FMDatabaseQueue *queue = [self getCurDatabaseQueue];
    if (queue)
    {
        __block NSMutableArray *resultArray = [NSMutableArray array];

        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"SELECT _id AS theId, book_id AS bookId, unit_id AS unitId, word AS wordStr, detail AS explainStr, evo AS phoneticStr, audio_st FROM book_word WHERE book_id = %ld ORDER BY sequence ASC", bookId];
            
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                TextbookVocabularyModel *model = [[TextbookVocabularyModel alloc] initWithDictionary:set.resultDictionary];
                model.audioStartSecondPosition = [[set.resultDictionary safeObjectForKey:@"audio_st"] doubleValue] / 1000;
                
                [resultArray addObject:model];
            }
            [set close];
        }];
        
        return resultArray;
    }
    return nil;
}

@end
