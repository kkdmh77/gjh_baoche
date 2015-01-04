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

@interface BuyTicketVC ()

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
    
    [_startStationInputBtn setTitleColor:blackColor forState:UIControlStateNormal];
    _startStationInputBtn.backgroundColor = [UIColor whiteColor];
    [_startStationInputBtn setRadius:5];
    
    [_endStationInputBtn setTitleColor:blackColor forState:UIControlStateNormal];
    _endStationInputBtn.backgroundColor = [UIColor whiteColor];
    [_endStationInputBtn setRadius:5];
    
    _dateChooseBGBtn.backgroundColor = [UIColor whiteColor];
    [_dateChooseBGBtn setRadius:5];
    
    _dateShowLabel.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    _dateShowLabel.text = @"请选择日期";
    
    _searchBtn.backgroundColor = Common_ThemeColor;
    [_searchBtn setRadius:5];
}

- (void)initialization
{
    [self configureViewsProperties];
}

- (void)setDateShowLabelTextWithDate:(NSDate *)date weekStr:(NSString *)weekStr
{
    NSString *dateStr = [NSDate stringFromDate:date withFormatter:DataFormatter_DateNoYear];
    NSString *resultDateStr = [NSString stringWithFormat:@"%@  %@  %@", @"出发日期", dateStr, weekStr];
    
    _dateShowLabel.text = resultDateStr;
    [_dateShowLabel setTextColor:Common_ThemeColor range:[resultDateStr rangeOfString:dateStr]];
}

- (IBAction)clickStartStationInputBtn:(UIButton *)sender
{
    StartStationChooseVC *startStationChoose = [[StartStationChooseVC alloc] init];
    startStationChoose.hidesBottomBarWhenPushed = YES;
    [self pushViewController:startStationChoose];
}

- (IBAction)clickEndStationInputBtn:(UIButton *)sender
{
    EndStationChooseVC *endStationChoose = [[EndStationChooseVC alloc] init];
    endStationChoose.hidesBottomBarWhenPushed = YES;
    [self pushViewController:endStationChoose];
}

- (IBAction)clickExchangeStationsBtn:(UIButton *)sender
{
    
}

- (IBAction)clickDateChooseBtn:(UIButton *)sender
{
    WEAKSELF
    CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc] init];
    calendar.hidesBottomBarWhenPushed = YES;
    calendar.calendartitle = @"选择日期";
    [calendar setTrainToDay:60 ToDateforString:weakSelf.dateShowLabel.text];
    [calendar setCalendarblock:^(CalendarDayModel *model) {
        
        [weakSelf setDateShowLabelTextWithDate:model.date weekStr:[model getWeek]];
       
        [weakSelf backViewController];
    }];
    
    [self pushViewController:calendar];
}

- (IBAction)clickSearchBtn:(UIButton *)sender
{
    AllBusListVC *busList = [[AllBusListVC alloc] init];
    busList.hidesBottomBarWhenPushed = YES;
    [self pushViewController:busList];
}

@end
