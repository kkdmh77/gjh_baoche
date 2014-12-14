//
//  HomePageHeaderView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "HomePageHeaderView.h"

@interface HomePageHeaderView ()
{
    NSArray *_subViewColorsArray;
}

@property (weak, nonatomic) IBOutlet UIView *scrollBGView;

@property (weak, nonatomic) IBOutlet UIButton *itemOneBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemOneDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemTwoBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemTwoDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemThreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemThreeDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemFourBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemFourDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemFiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemFiveDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemSixBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemSixDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemSevenBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemSevenDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *itemEightBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemEightDescLabel;

@end

@implementation HomePageHeaderView

- (void)awakeFromNib
{
    [self initSubViewColors];
    [self setup];
}

#pragma mark - custom methods

- (void)initSubViewColors
{
    _subViewColorsArray = @[HEXCOLOR(0XFF565B),
                            HEXCOLOR(0XFD8E35),
                            HEXCOLOR(0X42BDE8),
                            HEXCOLOR(0XF5C132),
                            HEXCOLOR(0XF8CC58),
                            HEXCOLOR(0X7B7AD7),
                            HEXCOLOR(0XFE8864),
                            HEXCOLOR(0X6CC143)];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.subviews)
    {
        if (subView.tag >= 1000)
        {
            subView.backgroundColor = [UIColor clearColor];
            
            [subView addLineWithPosition:ViewDrawLinePostionType_Right
                               lineColor:HEXCOLOR(0XE7E7E7)
                               lineWidth:LineWidth];
            [subView addLineWithPosition:ViewDrawLinePostionType_Bottom
                               lineColor:HEXCOLOR(0XE7E7E7)
                               lineWidth:LineWidth];
            
            for (UIView *view in subView.subviews)
            {
                UIColor *color = _subViewColorsArray[subView.tag - 1000];
                
                if ([view isKindOfClass:[UIButton class]])
                {
                    [view setRadius:view.boundsWidth / 2];
                    view.backgroundColor = color;
                }
                else if ([view isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)view;
                    
                    label.font = SP12Font;
                    label.textColor = HEXCOLOR(0X666666);
                }
            }
        }
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

@end
