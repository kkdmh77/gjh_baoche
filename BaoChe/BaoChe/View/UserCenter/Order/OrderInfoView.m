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

// 重载方法,解决XIB嵌套使用不能加载的问题
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])  bundle:nil];
        UIView *containerView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.frame = self.bounds;
        
        [self addSubview:containerView];
    }
    return self;
}

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

-(void)loadViewShowDataWithItemEntity:(OrderListEntity *)entity
{
    _orderNumberLabel.text = entity.orderNo;
    _mobilePhoneNumLabel.text = entity.mobilePhoneNumStr;
    _paymentOrderLabel.text = [NSDate stringFromTimeIntervalSeconds:entity.orderTime withFormatter:DataFormatter_DateAndTime];
    _buyCountLabel.text = [NSString stringWithFormat:@"%i", entity.passengersArray.count];
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf",entity.orderTotalFee];
}

@end
