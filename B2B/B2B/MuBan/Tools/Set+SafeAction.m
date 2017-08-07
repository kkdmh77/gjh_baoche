//
//  NSMutableArray+SafeAction.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 16/9/12.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "Set+SafeAction.h"
#import "KMSwizzle.h"
#import "PRPAlertView.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <objc/runtime.h>

static NSString * const errMessage_nilObject = @"同志，集合不能加入空对象！";
static NSString * const errMessage_beyondBounds = @"同志，数组越界了！";

#define SafeAction_Alert(__message) \
{ \
    if ([__message isValidString]) { \
        void *callstack[128]; \
        int frames = backtrace(callstack, 128); \
        char **strs = backtrace_symbols(callstack, frames); \
        int i; \
        NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames]; \
        for (i = 0; i < 4; i++) { \
            [backtrace addObject:[NSString stringWithUTF8String:strs[i]]]; \
        } \
        free(strs); \
        \
        [PRPAlertView showWithTitle:@"崩溃" \
                            message:[NSString stringWithFormat:@"%@\n%@", __message, backtrace] \
                        buttonTitle:@"请解决这个崩溃"]; \
    } \
}

@implementation NSMutableArray (SafeAction)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod(NSClassFromString(@"__NSArrayM"),
                        @selector(addObject:),
                        @selector(swiz_addObject:));
        
        KMSwizzleMethod(NSClassFromString(@"__NSArrayM"),
                        @selector(insertObject:atIndex:),
                        @selector(swiz_insertObject:atIndex:));
        
        KMSwizzleMethod(NSClassFromString(@"__NSArrayM"),
                        @selector(replaceObjectAtIndex:withObject:),
                        @selector(swiz_replaceObjectAtIndex:withObject:));
        
        KMSwizzleMethod(NSClassFromString(@"__NSArrayM"),
                        @selector(objectAtIndex:),
                        @selector(swiz_M_objectAtIndex:));
    });
}

- (void)swiz_addObject:(id)anObject
{
    @autoreleasepool {
        if (anObject == nil) {
#ifdef DEBUG
            // NSAssert(0, errMessage_nilObject);
            SafeAction_Alert(errMessage_nilObject);
            return;
#else
            return;
#endif
        }
        
        return [self swiz_addObject:anObject];
    }
}

- (void)swiz_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (anObject == nil || index > self.count) {
            NSString *message = [NSString stringWithFormat:@"%@ 或者 %@", errMessage_nilObject, errMessage_beyondBounds];
#ifdef DEBUG
            // NSAssert(0, message);
            SafeAction_Alert(message);
            return;
#else
            return;
#endif
        }
        
        return [self swiz_insertObject:anObject atIndex:index];
    }
}

- (void)swiz_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    @autoreleasepool {
        if (anObject == nil || index >= self.count) {
            NSString *message = [NSString stringWithFormat:@"%@ 或者 %@", errMessage_nilObject, errMessage_beyondBounds];
#ifdef DEBUG
            // NSAssert(0, message);
            SafeAction_Alert(message);
            return;
#else
            return;
#endif
        }
        
        return [self swiz_replaceObjectAtIndex:index withObject:anObject];
    }
}

- (id)swiz_M_objectAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (index >= self.count) {
#ifdef DEBUG
            // NSAssert(0, errMessage_beyondBounds);
            SafeAction_Alert(errMessage_beyondBounds);
            return nil;
#else
            return nil;
#endif
        }
        
        return [self swiz_M_objectAtIndex:index];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation NSArray (SafeAction)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod(NSClassFromString(@"__NSArrayI"),
                        @selector(objectAtIndex:),
                        @selector(swiz_objectAtIndex:));
        
        KMSwizzleMethod(NSClassFromString(@"__NSArray0"),
                        @selector(objectAtIndex:),
                        @selector(swiz_0_objectAtIndex:));
        
    });
}

- (id)swiz_objectAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (index >= self.count) {
#ifdef DEBUG
            // NSAssert(0, errMessage_beyondBounds);
            SafeAction_Alert(errMessage_beyondBounds);
            return nil;
#else
            return nil;
#endif
        }
        
        return [self swiz_objectAtIndex:index];
    }
}

- (id)swiz_0_objectAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (index >= self.count) {
#ifdef DEBUG
            // NSAssert(0, errMessage_beyondBounds);
            SafeAction_Alert(errMessage_beyondBounds);
            return nil;
#else
            return nil;
#endif
        }
        
        return [self swiz_0_objectAtIndex:index];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation NSMutableDictionary (SafeAction)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod(NSClassFromString(@"__NSDictionaryM"),
                        @selector(setObject:forKey:),
                        @selector(swiz_setObject:forKey:));
    });
}

- (void)swiz_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    @autoreleasepool {
        if (anObject == nil || aKey == nil) {
#ifdef DEBUG
            // NSAssert(0, errMessage_nilObject);
            SafeAction_Alert(errMessage_nilObject);
            return;
#else
            return;
#endif
        }
        
        return [self swiz_setObject:anObject forKey:aKey];
    }
}

@end


