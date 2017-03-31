//
//  UITableViewCell+BackgroundColor.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/8/10.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (BackgroundColor)

- (void)configureCellBackgroundColors;

- (void)configureCellBackgroundColor:(DKColorPicker)bgColorPicker
             selectedBackgroundColor:(DKColorPicker)selectedBgColorPicker;

@end
