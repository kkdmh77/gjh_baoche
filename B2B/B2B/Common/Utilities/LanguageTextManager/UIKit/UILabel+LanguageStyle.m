//
//  UILabel+FontStyle.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UILabel+LanguageStyle.h"
#import "DKNightVersionManager.h"
#import <objc/runtime.h>

@interface UILabel ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKPicker> *pickers;

@end

@implementation UILabel (LanguageStyle)

- (DKLanguageTextPicker)dk_languageTextPicker
{
    return objc_getAssociatedObject(self, @selector(dk_languageTextPicker));
}

- (void)setDk_languageTextPicker:(DKLanguageTextPicker)dk_languageTextPicker
{
    objc_setAssociatedObject(self, @selector(dk_languageTextPicker), dk_languageTextPicker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.text = dk_languageTextPicker();
    [self.pickers setValue:[dk_languageTextPicker copy] forKey:@"setText:"];
}

@end
