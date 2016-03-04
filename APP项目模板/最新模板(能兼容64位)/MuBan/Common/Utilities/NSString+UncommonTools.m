//
//  NSString+UncommonTools.m
//  KKDictionary
//
//  Created by 龚 俊慧 on 15/12/17.
//  Copyright © 2015年 YY. All rights reserved.
//

#import "NSString+UncommonTools.h"
#import "SystemConvert.h"

#define kEnglishCharactersStr @"abcdefghijklmnopqrstuvwxyz"

@implementation NSString (UncommonTools)

+ (NSString*) unescapeUnicodeString:(NSString*)string
{
    // unescape quotes and backwards slash
    NSString* unescapedString = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    unescapedString = [unescapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    // tokenize based on unicode escape char
    NSMutableString* tokenizedString = [NSMutableString string];
    NSScanner* scanner = [NSScanner scannerWithString:unescapedString];
    while ([scanner isAtEnd] == NO)
    {
        // read up to the first unicode marker
        // if a string has been scanned, it's a token
        // and should be appended to the tokenized string
        NSString* token = @"";
        [scanner scanUpToString:@"\\u" intoString:&token];
        if (token != nil && token.length > 0)
        {
            [tokenizedString appendString:token];
            continue;
        }
        
        // skip two characters to get past the marker
        // check if the range of unicode characters is
        // beyond the end of the string (could be malformed)
        // and if it is, move the scanner to the end
        // and skip this token
        NSUInteger location = [scanner scanLocation];
        NSInteger extra = scanner.string.length - location - 4 - 2;
        if (extra < 0)
        {
            NSRange range = {location, -extra};
            [tokenizedString appendString:[scanner.string substringWithRange:range]];
            [scanner setScanLocation:location - extra];
            continue;
        }
        
        // move the location pas the unicode marker
        // then read in the next 4 characters
        location += 2;
        NSRange range = {location, 4};
        token = [scanner.string substringWithRange:range];
        unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
        [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
        
        // move the scanner past the 4 characters
        // then keep scanning
        location += 4;
        [scanner setScanLocation:location];
    }
    
    // done
    return tokenizedString;
}

+ (NSString*) escapeUnicodeString:(NSString*)string
{
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString* escapedString = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char* bytes = data.bytes;
    NSMutableString* encodedString = [NSMutableString string];
    
    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length)
    {
        uint16_t code = *((uint16_t*) &bytes[bytesRead]);
        if (code > 0x007E)
        {
            [encodedString appendFormat:@"\\u%04X,", code];
        }
        else
        {
            [encodedString appendFormat:@"%C,", code];
        }
        bytesRead += sizeof(uint16_t);
    }
    
    // done
    if ([encodedString hasSuffix:@","])
    {
        [encodedString replaceCharactersInRange:NSMakeRange(encodedString.length - 1, 1) withString:@""];
    }
    return encodedString;
}

// char[] seq = { '\uD840', '\uDC00' };
int codePointAt(int seq[]) {
    int low = seq[1];
    int high = seq[0];
    if ((56320 <= low && 57343 >= low) && (55296 <= high && 56319 >= high)) {
        // http://www.ietf.org/rfc/rfc2781.txt
        int h = (high & 0x3FF) << 10;
        int l = low & 0x3FF;
        return (h | l) + 0x10000;
    }
    return high;
}

// 获取单个字的unicode码
- (NSInteger)characterUnicode
{
    NSInteger length = [self lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    
    if (1 == length)
    {
        if (2 == [self rangeOfComposedCharacterSequenceAtIndex:0].length)
        {
            NSString *charArrayStr = [[self class] escapeUnicodeString:self];
            NSArray *charArray = [charArrayStr componentsSeparatedByString:@","];
            
            if (2 == charArray.count)
            {
                NSString *lowStr = charArray[0];
                NSString *highStr = charArray[1];
                
                lowStr = [lowStr stringByReplacingOccurrencesOfString:@"\\u" withString:@""];
                highStr = [highStr stringByReplacingOccurrencesOfString:@"\\u" withString:@""];
                
                int lowCode = [[SystemConvert hexToDecimal:lowStr] intValue];
                int highCode = [[SystemConvert hexToDecimal:highStr] intValue];
                
                int seq[2] = {lowCode, highCode};
                return codePointAt(seq);
            }
        }
        else
        {
            return [self characterAtIndex:0];
        }
    }
    
    return NSNotFound;
}

NSArray<NSString *> * toChars(int codePoint) {
    if (!(0x000000 <= codePoint && 0x10FFFF >= codePoint)) {
        return nil;
    }
    if ((0x10000 <= codePoint && 0x10FFFF >= codePoint)) {
        int cpPrime = codePoint - 0x10000;
        int high = 0xD800 | ((cpPrime >> 10) & 0x3FF);
        int low = 0xDC00 | (cpPrime & 0x3FF);
        
        return @[[SystemConvert decimalToHex:high], [SystemConvert decimalToHex:low]];
    }
    
    return @[[SystemConvert decimalToHex:codePoint]];
}

// unicode码->字
+ (NSString *)unicodeToCharacter:(NSInteger)unicode
{
    NSArray *charsArray = toChars((int)unicode);
    if ([charsArray isAbsoluteValid])
    {
        if (2 == charsArray.count)
        {
            NSString *charsString = [NSString stringWithFormat:@"\\u%@\\u%@", charsArray[0], charsArray[1]];
            return [self unescapeUnicodeString:charsString];
        }
        else
        {
            return [self unescapeUnicodeString:[NSString stringWithFormat:@"\\u%@", charsArray[0]]];
        }
    }
    return nil;
}

//////////////////////////////////////////////////////////////////////

- (NSUInteger)charactersLength
{
    return [self lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
}

//////////////////////////////////////////////////////////////////////

- (BOOL)hasContainAnyChineseCharacter
{
    __block BOOL flag = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
         if ([substring iSChineseCharacter])
         {
             flag = YES;
             *stop = YES;
         }
     }];
    return flag;
}

//////////////////////////////////////////////////////////////////////

- (BOOL)iSChineseCharacter
{
    NSInteger length = self.charactersLength;
    if (1 == length)
    {
        NSInteger code = [self characterUnicode];
        BOOL flag = [NSString isChinese:(int)code];
        
        return flag;
    }
    return NO;
}

- (BOOL)iSChineseString
{
    __block BOOL flag = YES;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
         if (![substring iSChineseCharacter])
         {
             flag = NO;
             *stop = YES;
         }
     }];
    return flag;
}

+ (BOOL)isChinese:(int)utf32 {
    if ([self isChineseStandard:utf32] ||
        [self isChineseExtendA:utf32] ||
        [self isChineseExtendB:utf32] ||
        [self isChineseExtendC:utf32] ||
        [self isChineseExtendD:utf32] ||
        [self isChineseExtendE:utf32]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseStandard:(int)utf32 {
    if ((utf32 <= 40869 && utf32 >= 19968) || (utf32 == 12295)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendA:(int)utf32 {
    if (utf32 <= 19893 && utf32 >= 13312) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendB:(int)utf32 {
    if (utf32 <= 173782 && utf32 >= 131072) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendB1:(int)utf32 {
    if (utf32 <= 160970 && utf32 >= 131072) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendB2:(int)utf32 {
    if (utf32 <= 173782 && utf32 >= 160971) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendC:(int)utf32 {
    if (utf32 <= 177972 && utf32 >= 173824) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendD:(int)utf32 {
    if (utf32 <= 178205 && utf32 >= 177984) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChineseExtendE:(int)utf32 {
    if (utf32 <= 183969 && utf32 >= 178208) {
        return YES;
    }
    return NO;
}

/****************************英文相关********************************/

- (BOOL)iSAEnglishCharacter
{
    NSInteger length = self.charactersLength;
    if (1 == length)
    {
        BOOL flag = [kEnglishCharactersStr containsString:[self lowercaseString]];
        
        return flag;
    }
    return NO;
}

- (BOOL)iSEnglishString
{
    __block BOOL flag = YES;
    [[self lowercaseString] enumerateSubstringsInRange:NSMakeRange(0, self.length)
                                               options:NSStringEnumerationByComposedCharacterSequences
                                            usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
         if (![substring iSAEnglishCharacter])
         {
             flag = NO;
             *stop = YES;
         }
     }];
    return flag;
}

- (BOOL)hasContainAnyEnglishCharacter
{
    __block BOOL flag = NO;
    [[self lowercaseString] enumerateSubstringsInRange:NSMakeRange(0, self.length)
                                               options:NSStringEnumerationByComposedCharacterSequences
                                            usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
         if ([substring iSAEnglishCharacter])
         {
             flag = YES;
             *stop = YES;
         }
     }];
    return flag;
}

@end
