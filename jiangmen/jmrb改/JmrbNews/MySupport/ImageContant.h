//
//  ImageContant.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define DEFAULT_DATE_TEMPLATE_STRING @"HH:mm:ss dd/MM/yy"

@interface NSString (YungExtend)
- (NSString *)URLEncodedString1;
- (NSString *)URLDecodedString1;
@end

@implementation NSString (YungExtend)

- (NSString *)URLEncodedString1
{
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t:/~ "), kCFStringEncodingUTF8) autorelease];
}

- (NSString*)URLDecodedString1 {
    NSString *result = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

@end

@interface UIImage(YungExtend)

+ (UIImage *)imageByName:(NSString *)name withExtend:(NSString *)extension;

@end

@implementation UIImage(YungExtend)

+ (UIImage *)imageByName:(NSString *)name withExtend:(NSString *)extension {
	NSString * scaledName = name;
	
	if ([[UIDevice currentDevice].name hasSuffix:@"Simulator"] || ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)) {
		scaledName = [scaledName stringByAppendingString:@"@2x"];
	}
	
	NSString * fullPath = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], scaledName, extension];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
		fullPath = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, extension];
	}
	
	return [UIImage imageWithContentsOfFile:fullPath];
}

@end

CG_INLINE NSDate * getDateFromString(NSString *dateStringTemplate, NSString *dateStr) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    [dateFormatter release];
    return date;
}

CG_INLINE NSString *getStringFromDate(NSString *dateStringTemplate, NSDate *date) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    return dateStr;
}

CG_INLINE NSString *getWeekDaySymbol(NSDate *date){
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *weekDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger week = [weekDayComponents weekday];
    NSString *symbol = nil;
    switch (week) {
        case 1:{
            symbol = @"星期天";
            break;
        }
        case 2:{
            symbol = @"星期一";
            break;
        }
        case 3:{
            symbol = @"星期二";
            break;
        }
        case 4:{
            symbol = @"星期三";
            break;
        }
        case 5:{
            symbol = @"星期四";
            break;
        }
        case 6:{
            symbol = @"星期五";
            break;
        }
        case 7:{
            symbol = @"星期六";
            break;
        }
    }
    return symbol;
}


