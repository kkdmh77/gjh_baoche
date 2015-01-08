//
//  DetailOrderVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/2.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "DetailOrderVC.h"
#import "BusInfoView.h"
#import "PassengersCell.h"
#import "OrderInfoView.h"
#import "UserCenter_TabHeaderView.h"

static NSString * const cellIdentifier_detailOrderPassenger = @"cellIdentifier_detailOrderPassenger";

@interface DetailOrderVC ()
{
    UserCenter_TabSectionHeaderView    *_passengersCellSectionHeader;
}

@end

@implementation DetailOrderVC

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
    [self setNavigationItemTitle:@"订单详情"];
}

- (void)setNetworkRequestStatusBlocks
{
    
}

- (void)getNetworkData
{
    
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellIdentifier_detailOrderPassenger];
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
    if (2 == section)
    {
        return [self numberOfRowsInSection:section];;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return [OrderInfoView getViewHeight];
    }
    else if (1 == indexPath.section)
    {
        return [BusInfoView getViewHeight];
    }
    else if (2 == indexPath.section)
    {
        return [PassengersCell getCellHeight];
    }
    else if (3 == indexPath.section)
    {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (2 == section)
    {
        return 50;
    }
    return CellSeparatorSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section || 3 == section)
    {
        return CellSeparatorSpace;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (2 == section)
    {
        if (!_passengersCellSectionHeader)
        {
            _passengersCellSectionHeader = [UserCenter_TabSectionHeaderView loadFromNib];
            _passengersCellSectionHeader.canOperation = NO;
            [_passengersCellSectionHeader setTitleString:@"乘客(2位)"];
            /*
            _passengersCellSectionHeader.tag = section;
            [_passengersCellSectionHeader addTarget:self
                                             action:@selector(headerClicked:)
                                   forControlEvents:UIControlEventTouchUpInside];
             */
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
        static NSString *cellIdentifier = @"cellIdentifier_orderInfo";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            OrderInfoView *orderInfoView = [OrderInfoView loadFromNib];
            orderInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:orderInfoView];
        }
        
        return cell;
    }
    else if (1 == indexPath.section)
    {
        static NSString *cellIdentifier = @"cellIdentifier_busInfo";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            BusInfoView *busInfoView = [BusInfoView loadFromNib];
            busInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:busInfoView];
        }
        
        return cell;
    }
    else if (2 == indexPath.section)
    {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_detailOrderPassenger];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.btnType = OperationButType_DetailOrder_ToRefundTicket;
            }
                break;
            case 1:
            {
                cell.btnType = OperationButType_DetailOrder_AlreadyRefundTicket;
            }
                break;
            case 2:
            {
                cell.btnType = OperationButType_DetailOrder_GetTicket;
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else if (3 == indexPath.section)
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////
/*
-(void)headerClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

- (int)numberOfRowsInSection:(NSInteger)section
{
    /*
    if (_passengersCellSectionHeader.selected)
    {
        return 2;
    }
    return 0;
     */
    return 3;
}

@end