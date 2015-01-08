//
//  BuyTicketVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/27.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BuyTicketVC.h"
#import "NIAttributedLabel.h"
#import "AllBusListVC.h"
#import "CalendarHomeViewController.h"
#import "StartStationChooseVC.h"
#import "EndStationChooseVC.h"
#include <objc/runtime.h>

static NSString * const StartStationInputPlaceholderStr = @"请选择出发地";
static NSString * const EndStationInputPlaceholderStr   = @"请选择目的地";
static NSString * const DateInputPlaceholderStr         = @"请选择日期";

@interface BuyTicketVC ()
{
    NSString *_startDateStr; // 出发日期
    NSString *_startWeekStr; // 周几
}

@property (weak, nonatomic) IBOutlet UIImageView *advertisingImageView;
@property (weak, nonatomic) IBOutlet UILabel *startStationDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStationInputBtn;
@property (weak, nonatomic) IBOutlet UIButton *endStationInputBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateChooseBGBtn;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *dateShowLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation BuyTicketVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:nil
                            highlightedImg:nil
                                    action:NULL];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"买票"];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    _startStationDescLabel.textColor = grayColor;
    _endStationDescLabel.textColor = grayColor;
    
    [_startStationInputBtn setTitle:StartStationInputPlaceholderStr forState:UIControlStateNormal];
    [_startStationInputBtn setTitleColor:blackColor forState:UIControlStateNormal];
    _startStationInputBtn.backgroundColor = [UIColor whiteColor];
    [_startStationInputBtn setRadius:5];
    
    [_endStationInputBtn setTitle:EndStationInputPlaceholderStr forState:UIControlStateNormal];
    [_endStationInputBtn setTitleColor:blackColor forState:UIControlStateNormal];
    _endStationInputBtn.backgroundColor = [UIColor whiteColor];
    [_endStationInputBtn setRadius:5];
    
    _dateChooseBGBtn.backgroundColor = [UIColor whiteColor];
    [_dateChooseBGBtn setRadius:5];
    
    _dateShowLabel.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    _dateShowLabel.text = DateInputPlaceholderStr;
    
    _searchBtn.backgroundColor = Common_ThemeColor;
    [_searchBtn setRadius:5];
}

- (void)initialization
{
    [self configureViewsProperties];
}

- (void)setDateShowLabelTextWithDate:(NSDate *)date weekStr:(NSString *)weekStr
{
    _startDateStr = [NSDate stringFromDate:date withFormatter:DataFormatter_Date];
    _startWeekStr = weekStr;
    
    NSString *resultDateStr = [NSString stringWithFormat:@"%@  %@  %@", @"出发日期", _startDateStr, weekStr];
    
    _dateShowLabel.text = resultDateStr;
    [_dateShowLabel setTextColor:Common_ThemeColor
                           range:[resultDateStr rangeOfString:_startDateStr]];
}

- (void)setStartStationStr:(NSString *)startStaion
{
    [_startStationInputBtn setTitle:startStaion forState:UIControlStateNormal];
}

- (void)setEndStationStr:(NSString *)endStation
{
    [_endStationInputBtn setTitle:endStation forState:UIControlStateNormal];
}

// 出发地
- (IBAction)clickStartStationInputBtn:(UIButton *)sender
{
    StartStationChooseVC *startStationChoose = [[StartStationChooseVC alloc] init];
    
    objc_setAssociatedObject(startStationChoose, class_getName([BuyTicketVC class]), self, OBJC_ASSOCIATION_ASSIGN);
    startStationChoose.hidesBottomBarWhenPushed = YES;
    [self pushViewController:startStationChoose];
}

// 目的地
- (IBAction)clickEndStationInputBtn:(UIButton *)sender
{
    NSString *startStationStr = [_startStationInputBtn titleForState:UIControlStateNormal];
    
    if (![startStationStr isEqualToString:StartStationInputPlaceholderStr])
    {
        EndStationChooseVC *endStationChoose = [[EndStationChooseVC alloc] init];
        endStationChoose.startStation = startStationStr;
        
        objc_setAssociatedObject(endStationChoose, class_getName([BuyTicketVC class]), self, OBJC_ASSOCIATION_ASSIGN);
        endStationChoose.hidesBottomBarWhenPushed = YES;
        [self pushViewController:endStationChoose];
    }
    else
    {
        [self showHUDInfoByString:@"请先选择出发地点"];
    }
}

// 出发地<->目的地切换
- (IBAction)clickExchangeStationsBtn:(UIButton *)sender
{
    NSString *startStationInputStr = [_startStationInputBtn titleForState:UIControlStateNormal];
    NSString *endStationInputStr = [_endStationInputBtn titleForState:UIControlStateNormal];
    
    if (![startStationInputStr isEqualToString:StartStationInputPlaceholderStr] && ![endStationInputStr isEqualToString:EndStationInputPlaceholderStr])
    {
        [self setStartStationStr:endStationInputStr];
        [self setEndStationStr:startStationInputStr];
    }
    
}

// 出发日期
- (IBAction)clickDateChooseBtn:(UIButton *)sender
{
    WEAKSELF
    CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc] init];
    calendar.hidesBottomBarWhenPushed = YES;
    calendar.calendartitle = @"请选择日期";
    [calendar setTrainToDay:60 ToDateforString:_startDateStr];
    [calendar setCalendarblock:^(CalendarDayModel *model) {
        
        [weakSelf setDateShowLabelTextWithDate:model.date weekStr:[model getWeek]];
       
        [weakSelf backViewController];
    }];
    
    [self pushViewController:calendar];
}

// 搜索
- (IBAction)clickSearchBtn:(UIButton *)sender
{
    NSString *startStationStr = [_startStationInputBtn titleForState:UIControlStateNormal];
    NSString *endStationStr = [_endStationInputBtn titleForState:UIControlStateNormal];
    
    if (![startStationStr isEqualToString:StartStationInputPlaceholderStr])
    {
        if (![endStationStr isEqualToString:EndStationInputPlaceholderStr])
        {
            if (_startDateStr)
            {
                AllBusListVC *busList = [[AllBusListVC alloc] init];
                busList.startStationStr = startStationStr;
                busList.EndStationStr = endStationStr;
                busList.startDateStr = _startDateStr;
                busList.startWeekStr = _startWeekStr;
                
                busList.hidesBottomBarWhenPushed = YES;
                [self pushViewController:busList];
            }
            else
            {
                [self showHUDInfoByString:@"请选择出发日期"];
            }
        }
        else
        {
            [self showHUDInfoByString:@"请选择目的地点"];
        }
    }
    else
    {
        [self showHUDInfoByString:@"请选择出发地点"];
    }
}

@end
