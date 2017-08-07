//
//  UIButton+LanguageStyle.m
//  kkpoem
//
//  Created by 龚 俊慧 on 2016/10/10.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UIButton+LanguageStyle.h"

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pickers;

@end

@implementation UIButton (LanguageStyle)

- (void)dk_setTitlePicker:(DKLanguageTextPicker)picker forState:(UIControlState)state {
    [self setTitle:picker() forState:state];
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary *dictionary = [self.pickers valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    [dictionary setValue:[picker copy] forKey:NSStringFromSelector(@selector(setTitle:forState:))];
    [self.pickers setValue:dictionary forKey:key];
}

- (void)style_updateLanguageType {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, DKPicker> *dictionary = (NSDictionary *)obj;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKPicker  _Nonnull picker, BOOL * _Nonnull stop) {
                UIControlState state = [key integerValue];
                [UIView animateWithDuration:DKNightVersionAnimationDuration
                                 animations:^{
                                     if ([selector isEqualToString:NSStringFromSelector(@selector(setTitle:forState:))]) {
                                         NSString *resultText = picker();
                                         [self setTitle:resultText forState:state];
                                     }
                                 }];
            }];
        } else {
            SEL sel = NSSelectorFromString(key);
            DKPicker picker = (DKPicker)obj;
            UIColor *result = picker();
            [UIView animateWithDuration:DKNightVersionAnimationDuration
                             animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                 [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
                             }];
            
        }
    }];
}

@end
