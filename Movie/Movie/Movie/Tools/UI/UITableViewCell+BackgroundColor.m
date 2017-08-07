//
//  UITableViewCell+BackgroundColor.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/8/10.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UITableViewCell+BackgroundColor.h"

@implementation UITableViewCell (BackgroundColor)

- (void)configureCellBackgroundColors
{
    [self configureCellBackgroundColor:DKColorWithColors(CellBgColor, CellBgColor_Night)
               selectedBackgroundColor:DKColorWithColors(CellSelectedBgColor, CellSelectedBgColor_Night)];
}

- (void)configureCellBackgroundColor:(DKColorPicker)bgColorPicker selectedBackgroundColor:(DKColorPicker)selectedBgColorPicker
{
    self.contentView.dk_backgroundColorPicker = bgColorPicker;
    self.dk_backgroundColorPicker = bgColorPicker;
    
    UIView *selectedBackgroundView = [UIView new];
    selectedBackgroundView.dk_backgroundColorPicker = selectedBgColorPicker;
    self.selectedBackgroundView = selectedBackgroundView;
}

@end
