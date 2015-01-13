//
//  OrderWriteVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/22.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "OrderWriteVC.h"
#import "BusInfoView.h"
#import "PassengersCell.h"
#import "UserCenter_TabHeaderView.h"
#import "SettlementView.h"

static NSString * const cellIdentifier_orderPassenger = @"cellIdentifier_orderPassenger";

@interface OrderWriteVC ()
{
    UserCenter_TabSectionHeaderView    *_passengersCellSectionHeader;
}

@end

@implementation OrderWriteVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"订单填写"];
}

- (void)setNetworkRequestStatusBlocks
{
   
}

- (void)getNetworkData
{
    
}

- (void)initialization
{
    // settlement view
    SettlementView *settlementView = [SettlementView loadFromNib];
    settlementView.width = self.viewBoundsWidth;
    settlementView.origin = CGPointMake(0, self.view.boundsHeight - settlementView.boundsHeight);
    settlementView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [settlementView setSettlementPrice:100 count:4];
    WEAKSELF
    [settlementView setOperationHandle:^(SettlementView *view, SettlementViewOperationType type, id sender) {
        /*
         车次id  int ScheduleId
         用户id  int  UserId'
         数量	int	Tickets
         价格    decimal   TotalAmount'
         用户手机号 str Phone
         用户地址  Str Address'
         乘客列表  Str  PeopleList  json字符串
         Eg : ‘[{“NameList” : “姓名”  : “IdentityList”  :  “身份证号码” },
         {“NameList”: ”姓名2”,  ” IdentityList”  :  “4443434343” } ]
         */
        
    }];
    [self.view addSubview:settlementView];
    
    // tab
    [self setupTableViewWithFrame:CGRectDecreaseSize(self.view.bounds, 0, settlementView.boundsHeight)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellIdentifier_orderPassenger];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSString *)curTitleWithIndex:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section)
    {
        return [self numberOfRowsInSection:section];;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return [BusInfoView getViewHeight];
    }
    else if (1 == indexPath.section)
    {
        return [PassengersCell getCellHeight];
    }
    else if (2 == indexPath.section)
    {
        return 50;
    }
    else if (3 == indexPath.section)
    {
        return [OrderContactInfoView getViewHeight];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        return 50;
    }
    return CellSeparatorSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section || 3 == section)
    {
        return CellSeparatorSpace;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        if (!_passengersCellSectionHeader)
        {
            _passengersCellSectionHeader = [UserCenter_TabSectionHeaderView loadFromNib];
            [_passengersCellSectionHeader setTitleString:@"乘客(2位)"];
            _passengersCellSectionHeader.tag = section;
            [_passengersCellSectionHeader addTarget:self
                           action:@selector(headerClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
        }
        return _passengersCellSectionHeader;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        static NSString *cellIdentifier = @"cellIdentifier_orderBusInfo";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            BusInfoView *busInfoView = [BusInfoView loadFromNib];
            busInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [busInfoView loadViewShowDataWithItemEntity:_busEntity];
            
            [cell addSubview:busInfoView];
        }
        
        return cell;
    }
    else if (1 == indexPath.section)
    {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_orderPassenger];
        
        return cell;
    }
    else if (2 == indexPath.section)
    {
        static NSString *cellIdentifier = @"cellIdentifier_orderInsurance";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
            
            UILabel *descLabel = InsertLabel(cell.contentView,
                                             CGRectMake(10, 0, 60, cellSize.height),
                                             NSTextAlignmentRight,
                                             @"套餐类型",
                                             SP15Font,
                                             Common_BlackColor,
                                             NO);
            
            CGFloat insuranceOrginX = CGRectGetMaxX(descLabel.frame) + 20;
            InsertLabel(cell.contentView,
                        CGRectMake(insuranceOrginX, 0, cellSize.width - insuranceOrginX - 10, cellSize.height),
                        NSTextAlignmentLeft,
                        @"￥2保险(已买)",
                        SP15Font,
                        Common_ThemeColor,
                        NO);
        }
        return cell;
    }
    else if (3 == indexPath.section)
    {
        static NSString *cellIdentifier = @"cellIdentifier_orderContactInfo";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            OrderContactInfoView *orderContactInfoView = [OrderContactInfoView loadFromNib];
            orderContactInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:orderContactInfoView];
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////

-(void)headerClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
    if (_passengersCellSectionHeader.selected)
    {
        return 2;
    }
    return 0;
}

@end
