//
//  DKFont.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "DKLanguageText.h"

@implementation DKLanguageText

DKLanguageTextPicker DKLanguageTextWithText(NSString *text) {
    return ^() {
        return [LanguagesManager getCurLanguagesTypeStrWithStr:text];
    };
}

@end
