//
//  DKFont.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UIFont *(^DKFontPicker)(void);

DKFontPicker DKFontWithSize(CGFloat size);

@interface DKFont : NSObject

@end
