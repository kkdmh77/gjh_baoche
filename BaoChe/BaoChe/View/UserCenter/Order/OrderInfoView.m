//
//  OrderInfoView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/2.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "OrderInfoView.h"

@interface OrderInfoView ()

@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation OrderInfoView

static CGFloat defaultViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    _topBGView.backgroundColor = [UIColor whiteColor];
    [_topBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    
    UIColor *blackColor = Common_BlackColor;
    UIColor *darkGrayColor = Common_DarkGrayColor;
    
    _titleLabel.textColor = blackColor;
    _orderStatusLabel.textColor = Common_ThemeColor;
    
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subview;
            label.textColor = darkGrayColor;
        }
    }
    
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getViewHeight
{
    if (0 == defaultViewHeight)
    {
        OrderInfoView *view = [self loadFromNib];
        defaultViewHeight = view.boundsHeight;
    }
    return defaultViewHeight;
}

@end
