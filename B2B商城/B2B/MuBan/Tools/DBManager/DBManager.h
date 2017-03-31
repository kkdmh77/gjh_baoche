//
//  DBManager.h
//  KKDictionary
//
//  Created by KungJack on 11/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#import "FileManager.h"
#import "AutoSearchWordModel.h"
#import "WordDetailModel.h"
#import "TextbookBookModel.h"
#import "TextbookUnitModel.h"
#import "TextbookPageModel.h"
#import "TextbookBlockModel.h"
#import "TextbookGrammarModel.h"
#import "TextbookVocabularyModel.h"

NSString *mixUpString();

#define kKKDKey mixUpString()

@interface DBManager : NSObject

AS_SINGLETON(DBManager);

/// 切换到对应的数据库
- (BOOL)changeToDefaultDatabase;
- (BOOL)changeToCurTextbookDatabase; // 切换到当前课本数据库
- (BOOL)changeToDatabaseWithFileType:(DBFileType)fileType;

- (BOOL)changeToDatabaseWithName:(NSString *)databaseName;
- (BOOL)changeToDatabaseWithPath:(NSString *)databasePath;

- (FMDatabaseQueue *)getCurDatabaseQueue;

- (NSInteger)getDBVersion;
- (BOOL)creatTableWithSql:(NSString *)sql;
- (void)configureProperties; // 配置属性

/****************************dictionary包的方法********************************/

/**
 * @method 根据字符自动搜索相关的单词
 * @param  characters: 字符
 * @return AutoSearchWordModel数组
 * @创建人  龚俊慧
 * @creat  2016-02-24
 */
- (NSArray<AutoSearchWordModel *> *)autoSearchWordsByCharacters:(NSString *)characters;

/**
 * @method 根据字符自动搜索相关的单词
 * @param  characters: 字符, pageCount: 页码, pageSize: 一页的数量
 * @return AutoSearchWordModel数组
 * @创建人  龚俊慧
 * @creat  2016-02-24
 */
- (NSArray<AutoSearchWordModel *> *)autoSearchWordsByCharacters:(NSString *)characters
                                                      pageCount:(NSInteger)pageCount
                                                       pageSize:(NSInteger)pageSize;

/****************************bookyingyu包的方法********************************/

+ (NSDictionary *)gradeTypeMap;
+ (GradeType)gradeTypeByGradeName:(NSString *)gradeName;
+ (NSString *)gradeNameByGradeType:(GradeType)gradeType;

/**
 * @method 根据年级类型查询所有的课本
 * @param  gradeType: 年级类型
 * @return TextbookBookModel数组
 * @创建人  龚俊慧
 * @creat  2016-02-29
 */
- (NSArray<TextbookBookModel *> *)selectBookModelsWithGradeType:(GradeType)gradeType;

/**
 * @method 根据条形码查询课本
 * @param  barcode: 课本的条形码
 * @return TextbookBookModel
 * @创建人  龚俊慧
 * @creat  2016-03-21
 */
- (TextbookBookModel *)selectBookModelWithBarcode:(NSString *)barcode;

/**
 * @method 根据BookID查询所有的单元
 * @param  bookId: 课本ID
 * @return TextbookUnitModel数组
 * @创建人  龚俊慧
 * @creat  2016-03-01
 */
- (NSArray<TextbookUnitModel *> *)selectUnitModelsWithBookId:(NSInteger)bookId;

/**
 * @method 根据BookID和UnitID查询所有的页面
 * @param  bookId: 课本ID, UnitID: 单元ID
 * @return TextbookPageModel数组
 * @创建人  龚俊慧
 * @creat  2016-03-01
 */
- (NSArray<TextbookPageModel *> *)selectPageModelsWithBookId:(NSInteger)bookId
                                                      unitId:(NSInteger)unitId;


/**
 * @method 根据BookID和UnitID以及SectionID查询所有的区块列表（不带音频、句子内容）
 * @param  BookID: 课本ID, UnitID: 单元ID, sectionId: 章节ID
 * @return TextbookBlockModel数组
 * @创建人  龚俊慧
 * @creat  2016-03-02
 */
- (NSArray<TextbookBlockModel *> *)selectBlockModelsWithBookId:(NSInteger)bookId
                                                        unitId:(NSInteger)unitId
                                                     sectionId:(NSInteger)sectionId;


/**
 * @method 根据BlockID查询区块详情内容（带音频、句子内容）
 * @param  BlockID: 区块ID
 * @return TextbookBlockModel
 * @创建人  龚俊慧
 * @creat  2016-03-02
 */
- (TextbookBlockModel *)blockDetailWithBlockId:(NSInteger)blockId;

/**
 * @method 根据BookID查询所有的语法（HTML5格式）
 * @param  bookId: 课本ID
 * @return TextbookGrammarModel数组
 * @创建人  龚俊慧
 * @creat  2016-03-16
 */
- (NSArray<TextbookGrammarModel *> *)selectGrammarModelsWithBookId:(NSInteger)bookId;

/**
 * @method 根据BookID查询所有的词汇
 * @param  bookId: 课本ID
 * @return TextbookVocabularyModel数组
 * @创建人  龚俊慧
 * @creat  2016-03-17
 */
- (NSArray<TextbookVocabularyModel *> *)selectVocabularyModelsWithBookId:(NSInteger)bookId;

@end
