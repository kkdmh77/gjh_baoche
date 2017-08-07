//
//  UITextView+FontStyle.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UITextView+FontStyle.h"
#import "DKNightVersionManager.h"
#import <objc/runtime.h>

@interface UITextView ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKPicker> *pickers;

@end

@implementation UITextView (FontStyle)

- (DKFontPicker)dk_fontPicker
{
    return objc_getAssociatedObject(self, @selector(dk_fontPicker));
}

- (void)setDk_fontPicker:(DKFontPicker)dk_fontPicker
{
    objc_setAssociatedObject(self, @selector(dk_fontPicker), dk_fontPicker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.font = dk_fontPicker();
    [self.pickers setValue:[dk_fontPicker copy] forKey:@"setFont:"];
}

@end
