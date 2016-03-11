//
//  DKFont.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "DKFont.h"

@implementation DKFont

DKFontPicker DKFontWithSize(CGFloat size) {
    return ^() {
        return kCustomFont_Size(size);
    };
}

@end
