//
//  DKFont.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/11.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *(^DKLanguageTextPicker)(void);

DKLanguageTextPicker DKLanguageTextWithText(NSString *text);

@interface DKLanguageText : NSObject

@end
