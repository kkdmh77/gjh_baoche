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
#import "PassengerManagerVC.h"
#import "PaymentManager.h"
#import "InterfaceHUDManager.h"

static NSString * const cellIdentifier_orderPassenger = @"cellIdentifier_orderPassenger";

@interface OrderWriteVC ()
{
    UserCenter_TabSectionHeaderView *_passengersCellSectionHeader;
    OrderContactInfoView            *_orderContactInfoView;
    SettlementView                  *_settlementView;
    
    NSString                        *_orderNo;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PassengerManagerCellSelectedNotificationKey
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectedPassenger:)
                                                 name:PassengerManagerCellSelectedNotificationKey
                                               object:nil];
    
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
            NSString *orderNo = [successInfoObj safeObjectForKey:@"orderNo"];
            
            if ([orderNo isAbsoluteValid])
            {
                orderNo = [NSString stringWithFormat:@"BUY_%@", orderNo];
                strongSelf->_orderNo = orderNo;
                
                // 支付
                [weakSelf toPayWithOrderNo:orderNo];
              }
        }
    }];
}

// 支付
- (void)toPayWithOrderNo:(NSString *)orderNo
{
    WEAKSELF
    [PaymentManager toPayWithOrderNo:orderNo
                            totalFee:_settlementView.totalPrice
                         productName:_busEntity.busNameStr
                         productDesc:_busEntity.busNameStr
                       suceessHandle:^{
                           
        [weakSelf showBuyTicketSuccessAlert];
    }];
}

// 买票成功后提示
- (void)showBuyTicketSuccessAlert
{
    WEAKSELF
    [[InterfaceHUDManager sharedInstance] showAlertWithTitle:AlertTitle
                                                     message:@"恭喜你，购票成功，你可以去我的订单中查看订单详情！"
                                               alertShowType:AlertShowType_warning
                                                 cancelTitle:nil
                                                 cancelBlock:nil
                                                  otherTitle:@"知道了"
                                                  otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                                                      
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
         */
        STRONGSELF
        // 已经生成了订单
        if ([strongSelf->_orderNo isAbsoluteValid])
        {
            [weakSelf toPayWithOrderNo:strongSelf->_orderNo];
        }
        // 没有生成订单,提交订单
        else
        {
            NSInteger buyTicketCount = strongSelf->_passengersItemsArray.count;
            if (buyTicketCount > 0)
            {
                // 乘车人的JSON字符串
                NSString *passengersJsonStr = nil;
                NSMutableArray *tempArray = [NSMutableArray array];
                for (PassengersEntity *entity in strongSelf->_passengersItemsArray)
                {
                    [tempArray addObject:@(entity.keyId)];
                }
                passengersJsonStr = [tempArray componentsJoinedByString:@","];
                
                NSDictionary *dic = @{@"cartInfoId": @(weakSelf.busEntity.keyId),
                                      @"passengerIdsStr": passengersJsonStr,
                                      @"paymentId": @(1)};
                
                [weakSelf sendRequest:[[weakSelf class] getRequestURLStr:NetOrderRequesertType_CreateOrder]
                         parameterDic:dic
                       requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
                    requestMethodType:RequestMethodType_POST
                           requestTag:NetOrderRequesertType_CreateOrder];
            }
            else
            {
                [weakSelf showHUDInfoByString:@"还没有添加乘车人哦!"];
            }
        }
    }];
    [self.view addSubview:_settlementView];
    
    // tab
    [self setupTableViewWithFrame:CGRectDecreaseSize(self.view.bounds, 0, _settlementView.boundsHeight)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellIdentifier_orderPassenger];
    // _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    [_passengersCellSectionHeader setTitleString:[NSString stringWithFormat:@"乘客(%ld位)", _passengersItemsArray.count]];
}

// 结算视图显示
- (void)setSettlementViewText
{
    [_settlementView setSettlementPrice:[self totalPrice] count:_passengersItemsArray.count];
}

// 接受通知
- (void)didSelectedPassenger:(NSNotification *)notification
{
    PassengersEntity *entity = [notification object];
    
    if ([entity isKindOfClass:[PassengersEntity class]])
    {
        [_passengersItemsArray addObject:entity];
        
        [_tableView reloadData];
    }
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
    PassengerManagerVC *passengerManager = [PassengerManagerVC new];
    passengerManager.useType = UseType_Selector;
    
    [self pushViewController:passengerManager];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (_passengersCellSectionHeader.selected)
    {
        return _passengersItemsArray.count;
    }
    return 0;
}

@end
