//
//  NSString+UncommonTools.h
//  KKDictionary
//
//  Created by 龚 俊慧 on 15/12/17.
//  Copyright © 2015年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UncommonTools)

/// 获取字符串真正的字符个数,而不是系统方法length的码元数
@property (readonly) NSUInteger charactersLength;

/// 获取单个字的unicode码（单个字符调用，如果为多个字符则返回NSNotFound）
- (NSInteger)characterUnicode;

/// unicode码->字
+ (NSString *)unicodeToCharacter:(NSInteger)unicode;

/// 是否为中文字符(单个字符调用，如果为多个字符则返回NO)
- (BOOL)iSChineseCharacter;

/// 是否为中文字符串（全部字符为中文汉字）
- (BOOL)iSChineseString;

/// 是否包含任意中文汉字
- (BOOL)hasContainAnyChineseCharacter;

/****************************判断字符在哪个包********************************/

+ (BOOL)isChineseStandard:(int)utf32;

+ (BOOL)isChineseExtendA:(int)utf32;

+ (BOOL)isChineseExtendB:(int)utf32;

+ (BOOL)isChineseExtendB1:(int)utf32;

+ (BOOL)isChineseExtendB2:(int)utf32;

+ (BOOL)isChineseExtendC:(int)utf32;

+ (BOOL)isChineseExtendD:(int)utf32;

+ (BOOL)isChineseExtendE:(int)utf32;

/****************************英文相关********************************/

/// 是否为英文字符(单个字符调用，如果为多个字符则返回NO)
- (BOOL)iSAEnglishCharacter;

/// 是否为英文字符串（全部字符为英文字符）
- (BOOL)iSEnglishString;

/// 是否包含任意英文文字符
- (BOOL)hasContainAnyEnglishCharacter;

@end
