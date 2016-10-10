//
//  UIButton+LanguageStyle.h
//  kkpoem
//
//  Created by 龚 俊慧 on 2016/10/10.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Night.h"
#import "DKLanguageText.h"

@interface UIButton (LanguageStyle)

- (void)dk_setTitlePicker:(DKLanguageTextPicker)picker forState:(UIControlState)state;

@end
