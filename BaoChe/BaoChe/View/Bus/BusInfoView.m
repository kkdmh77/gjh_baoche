//
//  OrderWriteTabHeaderView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/22.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BusInfoView.h"

@interface BusInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *busTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;

@property (weak, nonatomic) IBOutlet UIView *orderInfoBGView;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTime_DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTime_dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BusInfoView

static CGFloat defaultViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    UIColor *themeColor = Common_ThemeColor;
    
    self.backgroundColor = [UIColor clearColor];
    _busTypeLabel.backgroundColor = [UIColor clearColor];
    _busNameLabel.backgroundColor = [UIColor clearColor];
    _orderInfoBGView.backgroundColor = [UIColor whiteColor];
    [_orderInfoBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
    
    _busTypeLabel.textColor = themeColor;
    _busNameLabel.textColor = blackColor;
    
    _startStationLabel.textColor = grayColor;
    _endStationLabel.textColor = grayColor;
    
    _startTimeLabel.textColor = blackColor;
    _endTimeLabel.textColor = blackColor;
    
    _startTime_DateLabel.textColor = grayColor;
    _endTime_dateLabel.textColor = grayColor;
    _requireTimeLabel.textColor = grayColor;
    
    _stationsLabel.textColor = themeColor;
    _priceLabel.textColor = HEXCOLOR(0XEA430F);
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
        BusInfoView *view = [self loadFromNib];
        defaultViewHeight = view.boundsHeight;
    }
    return defaultViewHeight;
}

@end

#pragma mark - OrderContactInfoView -----------------------------

@interface OrderContactInfoView ()

@property (weak, nonatomic) IBOutlet UIView *contactBGView;
@property (weak, nonatomic) IBOutlet UILabel *contactDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;

@property (weak, nonatomic) IBOutlet UIView *mobilePhoneNumBGView;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneNumDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNumTF;

@property (weak, nonatomic) IBOutlet UIView *remarkBGView;
@property (weak, nonatomic) IBOutlet UILabel *remarkDescLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;

@end

@implementation OrderContactInfoView

static CGFloat defaultContactViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    _contactBGView.backgroundColor = [UIColor whiteColor];
    [_contactBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
    _mobilePhoneNumBGView.backgroundColor = [UIColor whiteColor];
    [_mobilePhoneNumBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    _remarkBGView.backgroundColor = [UIColor whiteColor];
    [_remarkBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    
    _contactDescLabel.textColor = blackColor;
    _contactTF.textColor = grayColor;
    
    _mobilePhoneNumDescLabel.textColor = blackColor;
    _mobilePhoneNumTF.textColor = grayColor;
    
    _remarkDescLabel.textColor = blackColor;
    _remarkTV.textColor = grayColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getViewHeight
{
    if (0 == defaultContactViewHeight)
    {
        OrderContactInfoView *view = [self loadFromNib];
        defaultContactViewHeight = view.boundsHeight;
    }
    return defaultContactViewHeight;
}

@end

