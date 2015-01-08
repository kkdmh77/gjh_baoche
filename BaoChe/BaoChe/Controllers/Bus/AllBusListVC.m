//
//  AllBusListVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/13.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AllBusListVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "AllBusListCell.h"
#import "AllBusList_HeaderView.h"
#import "CalendarHomeViewController.h"
#import "OrderWriteVC.h"

static NSString * const cellIdentifier_allBusList = @"cellIdentifier_allBusList";

@interface AllBusListVC ()

@end

@implementation AllBusListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getNetworkData];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:[NSString stringWithFormat:@"%@-%@",_startStationStr, _EndStationStr]];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetBusRequestType_GetAllBusList == request.tag)
        {
            
        }
    }];
}

- (void)getNetworkData
{
    /*
     * @param str StartLocation   开始的站点
     * @param str EndLocation   结束点
     * @param str StartDate   传入时间字符串 2015-01-01
     
     * @param int limit  每页显示的条数
     * @param int per_page 偏移量
     */
    
    if ([_startStationStr isAbsoluteValid] &&
        [_EndStationStr isAbsoluteValid] &&
        [_startDateStr isAbsoluteValid])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetBusRequestType_GetAllBusList]
             parameterDic:@{@"StartLocation": _startStationStr,
                            @"EndLocation": _EndStationStr,
                            @"StartDate": _startDateStr,
                            @"limit": @100,
                            @"page": @1}
        requestMethodType:RequestMethodType_POST
               requestTag:NetBusRequestType_GetAllBusList];
    }
}

- (void)initialization
{
    // header
    __weak AllBusList_HeaderView *headerView = [AllBusList_HeaderView loadFromNib];
    headerView.width = self.viewBoundsWidth;
    headerView.origin = CGPointZero;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    WEAKSELF
    [headerView setOperationType:^(AllBusList_HeaderView *view, AllBusListHeaderViewOperationType type) {
        if (AllBusListHeaderViewOperationType_PreDay == type)
        {
            
        }
        else if (AllBusListHeaderViewOperationType_CurShowDay == type)
        {
            CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc] init];
            calendar.calendartitle = @"选择日期";
            [calendar setTrainToDay:60 ToDateforString:[headerView curShowDateBtnTitle]];
            [calendar setCalendarblock:^(CalendarDayModel *model) {
                
                NSString *selectedDateStr = [NSString stringWithFormat:@"%@ %@",[model toString], [model getWeek]];
                [headerView setCurShowDateBtnTitle:selectedDateStr];
                [weakSelf backViewController];
            }];
            
            [self pushViewController:calendar];
        }
        else
        {
            
        }
    }];
    [self.view addSubview:headerView];
    
    // tab
    [self setupTableViewWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), self.viewBoundsWidth, self.viewBoundsHeight - CGRectGetMaxY(headerView.frame))
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([AllBusListCell class])
                  reuseIdentifier:cellIdentifier_allBusList];
    _tableView.backgroundColor = [UIColor whiteColor];
}

- (void)curIndexTabCellShowData:(NSInteger)index
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AllBusListCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllBusListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_allBusList];
    
    /*
     [cell loadCellShowDataWithItemEntity:nil];
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderWriteVC *orderWrite = [[OrderWriteVC alloc] init];
    orderWrite.hidesBottomBarWhenPushed = YES;
    [self pushViewController:orderWrite];
}

@end
