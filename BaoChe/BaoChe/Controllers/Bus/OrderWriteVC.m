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
#import "AddPassengersVC.h"
#include <objc/runtime.h>
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UserInfoModel.h"

static NSString * const cellIdentifier_orderPassenger = @"cellIdentifier_orderPassenger";

@interface OrderWriteVC ()
{
    UserCenter_TabSectionHeaderView *_passengersCellSectionHeader;
    OrderContactInfoView            *_orderContactInfoView;
    SettlementView                  *_settlementView;
}

@end

@implementation OrderWriteVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.passengersItemsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    [self setSettlementViewText];

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
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetOrderRequesertType_CreateOrder == request.tag)
        {
            
        }
    }];
}

- (void)getNetworkData
{
    
}

- (void)initialization
{
    // settlement view
    _settlementView = [SettlementView loadFromNib];
    _settlementView.width = self.viewBoundsWidth;
    _settlementView.origin = CGPointMake(0, self.view.boundsHeight - _settlementView.boundsHeight);
    _settlementView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
     [self setSettlementViewText];
    
    WEAKSELF
    [_settlementView setOperationHandle:^(SettlementView *view, SettlementViewOperationType type, id sender) {
        /*
         车次id  int ScheduleId 必填
         用户id  int  UserId'   必填
         数量	int	Tickets   必填
         价格    decimal   TotalAmount'   必填
         用户手机号 str Phone    必填
         用户地址  Str Address' （可选）
         订单联系人姓名： str 'OrderContact',  （可选）
         订单备注:     str    'OrderRemark'    （可选）
         乘客列表  Str  PeopleList  json字符串  必填
         Eg : ‘[{“NameList” : “姓名”  : “IdentityList”  :  “身份证号码” },
         {“NameList”: ”姓名2”,  ” IdentityList”  :  “4443434343” } ]
         */
        STRONGSELF
        NSNumber *userId = [UserInfoModel getUserDefaultUserId];
        
        if (userId)
        {
            NSInteger buyTicketCount = strongSelf->_passengersItemsArray.count;
            if (buyTicketCount > 0)
            {
                // 乘车人的JSON字符串
                NSString *passengersJsonStr = nil;
                NSMutableArray *tempArray = [NSMutableArray array];
                for (PassengersEntity *entity in strongSelf->_passengersItemsArray)
                {
                    NSDictionary *dic = @{@"NameList": entity.nameStr,
                                          @"IdentityList": entity.idCartStr};
                    [tempArray addObject:dic];
                }
                passengersJsonStr = [tempArray jsonStringByError:NULL];
                
                [weakSelf sendRequest:[[weakSelf class] getRequestURLStr:NetOrderRequesertType_CreateOrder]
                         parameterDic:@{@"ScheduleId": @(weakSelf.busEntity.keyId),
                                        @"UserId": userId,
                                        @"Tickets": @(buyTicketCount),
                                        @"TotalAmount": @([weakSelf totalPrice]),
                                        @"Phone": [UserInfoModel getUserDefaultLoginName],
                                        @"PeopleList": passengersJsonStr}
                    requestMethodType:RequestMethodType_POST
                           requestTag:NetOrderRequesertType_CreateOrder];
            }
            else
            {
                [weakSelf showHUDInfoByString:@"还没有添加乘车人哦!"];
            }
        }
        else
        {
            [weakSelf showHUDInfoByString:NotLogin];
        }
        
    }];
    [self.view addSubview:_settlementView];
    
    // tab
    [self setupTableViewWithFrame:CGRectDecreaseSize(self.view.bounds, 0, _settlementView.boundsHeight)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellIdentifier_orderPassenger];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSString *)curTitleWithIndex:(NSIndexPath *)indexPath
{
    return nil;
}

- (double)totalPrice
{
    return _busEntity.price * _passengersItemsArray.count;
}

- (void)setPassengersCellSectionHeaderTitleText
{
    [_passengersCellSectionHeader setTitleString:[NSString stringWithFormat:@"乘客(%d位)", _passengersItemsArray.count]];
}

// 结算视图显示
- (void)setSettlementViewText
{
    [_settlementView setSettlementPrice:[self totalPrice] count:_passengersItemsArray.count];
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
            
            _passengersCellSectionHeader.tag = section;
            [_passengersCellSectionHeader addTarget:self
                                             action:@selector(headerClicked:)
                                   forControlEvents:UIControlEventTouchUpInside];
            [_passengersCellSectionHeader.addBtn addTarget:self
                                                    action:@selector(clickAddPassengersBtn:)
                                          forControlEvents:UIControlEventTouchUpInside];
            
            [self headerClicked:_passengersCellSectionHeader];
        }
        
        [self setPassengersCellSectionHeaderTitleText];
        
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
        WEAKSELF
        [cell setOperationHandle:^(PassengersCell *cell, OperationButType type, id sender) {
            
            // 删除乘车人
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            [weakSelf.passengersItemsArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
            [weakSelf setPassengersCellSectionHeaderTitleText];
            [weakSelf setSettlementViewText];
        }];
        
        PassengersEntity *entity = _passengersItemsArray[indexPath.row];
        [cell loadCellShowDataWithItemEntity:entity];
        
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
            _orderContactInfoView = [OrderContactInfoView loadFromNib];
            _orderContactInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:_orderContactInfoView];
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

- (void)clickAddPassengersBtn:(UIButton *)sender
{
    AddPassengersVC *addPassengers = [AddPassengersVC loadFromNib];
    objc_setAssociatedObject(addPassengers, class_getName([self class]), self, OBJC_ASSOCIATION_ASSIGN);
    
    [self pushViewController:addPassengers];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
    if (_passengersCellSectionHeader.selected)
    {
        return _passengersItemsArray.count;
    }
    return 0;
}

@end
