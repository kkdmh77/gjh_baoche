//
//  UIControl+Analytics.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/5/3.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UIControl+Analytics.h"
#import "KMSwizzle.h"
#import "AnalyticsIDManager.h"
#import "KKDAnalytics.h"

@implementation UIControl (Analytics)

#pragma mark - Method Swizzling

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod([self class],
                        @selector(sendAction:to:forEvent:),
                        @selector(swiz_sendAction:to:forEvent:));
    });
}

- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // 插入埋点代码
    [self performUserStastisticsAction:action to:target forEvent:event];
    
    return [self swiz_sendAction:action to:target forEvent:event];
}

- (void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    NSDictionary *idsDic = [AnalyticsIDManager idsDic];
    NSString *idStr = [idsDic safeObjectForKey:NSStringFromSelector(action)];
    
    if ([idStr isAbsoluteValid])
    {
        [[KKDAnalytics sharedInstance] event:idStr];
    }
}

@end
