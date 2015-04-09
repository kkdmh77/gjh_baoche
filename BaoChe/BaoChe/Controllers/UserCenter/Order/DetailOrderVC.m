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
#import "InterfaceHUDManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import <objc/runtime.h>
#import "OrderListVC.h"
#import "NoPaySettlementView.h"
#import "PaymentManager.h"
#import "UIFactory.h"

static NSString * const cellIdentifier_detailOrderPassenger = @"cellIdentifier_detailOrderPassenger";

@interface DetailOrderVC ()
{
    UserCenter_TabSectionHeaderView    *_passengersCellSectionHeader;
    NoPaySettlementView                *_noPaySettlementView;
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

// 退票成功后的提示
- (NSString *)refundTicketSuceessAlertStr
{
    NSString *str = @"1.若未出票退票，金额原路返回；\n2.若已出票（若已取票，需退回票据），出车48h前扣取10%手续费，24h〜48h前扣取30％手续费，退款将原路返回；\n3.出车0〜24h，或错过班车，将不提供退票服务，敬请见谅！";
    
    return str;
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"订单详情"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        // 退票成功
        if (NetOrderRequesertType_ToRefundTicket == request.tag)
        {
            PassengersCell *cell = [request.userInfo safeObjectForKey:@"cell"];
            if (cell)
            {
                cell.btnType = OperationButType_DetailOrder_DoingRefundTicket;
                
                // 提示退票成功
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:@"申请退票说明"
                                                                 message:[weakSelf refundTicketSuceessAlertStr]
                                                           alertShowType:AlertShowType_warning
                                                             cancelTitle:nil
                                                             cancelBlock:nil
                                                              otherTitle:@"知道了"
                                                              otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                    
                }];
            }
        }
        // 取消订单成功
        else if (NetOrderRequesertType_CancelOrder == request.tag)
        {
            strongSelf->_noPaySettlementView.type = ViewType_OrderAlreadyCancel;
            
            [weakSelf showHUDInfoByString:@"订单取消成功！"];
        }
    }];
}

- (void)backViewController
{
    OrderListVC *orderList = objc_getAssociatedObject(self, class_getName([OrderListVC class]));
    [orderList clearAndReloadTabData];
    [orderList getNetworkData];
    
    [super backViewController];
}

- (void)getNetworkData
{
    
}

- (void)initialization
{
    if ([_defaultOrderEntity.orderStatus isEqualToString:@"OS_CONFIRMED"] || [_defaultOrderEntity.orderStatus isEqualToString:@"OS_CANCELED"])
    {
        // settlement view
        _noPaySettlementView = [NoPaySettlementView loadFromNib];
        _noPaySettlementView.width = self.viewBoundsWidth;
        _noPaySettlementView.origin = CGPointMake(0, self.view.boundsHeight - _noPaySettlementView.boundsHeight);
        _noPaySettlementView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        // 未付款
        if ([_defaultOrderEntity.orderStatus isEqualToString:@"OS_CONFIRMED"])
        {
            _noPaySettlementView.type = ViewType_OrderNoPay;
        }
        // 已取消
        else if ([_defaultOrderEntity.orderStatus isEqualToString:@"OS_CANCELED"])
        {
            _noPaySettlementView.type = ViewType_OrderAlreadyCancel;
        }
        
        WEAKSELF
        [_noPaySettlementView setOperationHandle:^(NoPaySettlementView *view, NoPaySettlementViewOperationType type, id sender) {
            
            // 去支付
            if (type == NoPaySettlementViewOperationType_Settlement)
            {
                NSString *orderNo = [NSString stringWithFormat:@"BUY_%@", weakSelf.defaultOrderEntity.orderNo];
                
                [weakSelf toPayWithOrderNo:orderNo];
            }
            // 取消订单
            else if (type == NoPaySettlementViewOperationType_CancelOrder)
            {
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:AlertTitle
                                                                 message:@"亲，要取消订单吗？"
                                                           alertShowType:AlertShowType_warning
                                                             cancelTitle:Cancel
                                                             cancelBlock:nil
                                                              otherTitle:Confirm
                                                              otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                                                                  
                      [weakSelf sendRequest:[[weakSelf class] getRequestURLStr:NetOrderRequesertType_CancelOrder]
                               parameterDic:@{@"orderNo": weakSelf.defaultOrderEntity.orderNo}
                             requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
                          requestMethodType:RequestMethodType_GET
                                 requestTag:NetOrderRequesertType_CancelOrder];
                }];
            }
        }];
        
        [self.view addSubview:_noPaySettlementView];
    }
    
    [self setupTableViewWithFrame:CGRectDecreaseSize(self.view.bounds, 0, _noPaySettlementView.boundsHeight)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellIdentifier_detailOrderPassenger];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// 支付
- (void)toPayWithOrderNo:(NSString *)orderNo
{
    WEAKSELF
    [PaymentManager toPayWithOrderNo:orderNo
                            totalFee:_defaultOrderEntity.orderTotalFee
                         productName:_defaultOrderEntity.busInfoEntity.busNameStr
                         productDesc:_defaultOrderEntity.busInfoEntity.busNameStr
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
        
        [weakSelf backViewController];
    }];
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
        /*
        return [self numberOfRowsInSection:section];
         */
        return _defaultOrderEntity.passengersArray.count;
    }
    else if (3 == section)
    {
        return 2;
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
            [_passengersCellSectionHeader setTitleString:[NSString stringWithFormat:@"乘客(%ld位)",_defaultOrderEntity.passengersArray.count]];
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
            
            [orderInfoView loadViewShowDataWithItemEntity:_defaultOrderEntity];
            
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
            
            [busInfoView loadViewShowDataWithItemEntity:_defaultOrderEntity.busInfoEntity];
            
            [cell addSubview:busInfoView];
        }
        
        return cell;
    }
    else if (2 == indexPath.section)
    {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_detailOrderPassenger];
        
        PassengersEntity *entity = _defaultOrderEntity.passengersArray[indexPath.row];
        [cell loadCellShowDataWithItemEntity:entity];
        
        // 待使用
        if ([entity.orderStatus isEqualToString:@"OS_VERIFIED"])
        {
            // 可申请退款
            if ([entity.afterSaleStatus isEqualToString:@"AS_ENABLE"])
            {
                cell.btnType = OperationButType_DetailOrder_ToRefundTicket;
            }
            // 退款申请已经提交，等待处理
            else if ([entity.afterSaleStatus isEqualToString:@"AS_REFUND_APPLY"])
            {
                cell.btnType = OperationButType_DetailOrder_DoingRefundTicket;
            }
            // 卖家已退款，请注意查收
            else if ([entity.afterSaleStatus isEqualToString:@"AS_REFUNDED"])
            {
                cell.btnType = OperationButType_DetailOrder_AlreadyRefundTicket;
            }
        }
        // 已出票
        else if ([entity.orderStatus isEqualToString:@"OS_FINISH"])
        {
            cell.btnType = OperationButType_DetailOrder_GetTicket;
        }
        // 已错过
        else if ([entity.orderStatus isEqualToString:@"OS_INVALID"])
        {
            cell.btnType = OperationButType_DetailOrder_AlreadyMiss;
        }
        // 未付款、订单已取消等其他情况
        else
        {
            cell.btnType = OperationButType_NoOperation;
        }
        
        // 回调
        WEAKSELF
        [cell setOperationHandle:^(PassengersCell *cell, OperationButType type, id sender) {
            
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            PassengersEntity *entity = weakSelf.defaultOrderEntity.passengersArray[indexPath.row];
            
            // 退票操作
            if (type == OperationButType_DetailOrder_ToRefundTicket)
            {
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:AlertTitle message:@"亲，真的要申请退票吗？" alertShowType:AlertShowType_warning cancelTitle:Cancel cancelBlock:nil otherTitle:Confirm otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                    /*
                     String remark  --退货单备注
                     String orderNo --订单号
                     int orderItemId --订单项ID
                     String reason   ---退单原因
                     */
                    [weakSelf sendRequest:[[self class] getRequestURLStr:NetOrderRequesertType_ToRefundTicket]
                             parameterDic:@{@"orderNo": weakSelf.defaultOrderEntity.orderNo,
                                            @"orderItemId": @(entity.keyId)}
                           requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
                        requestMethodType:RequestMethodType_POST
                               requestTag:NetOrderRequesertType_ToRefundTicket
                                 delegate:self
                                 userInfo:@{@"cell": cell}];
                }];
            }
        }];
        
        return cell;
    }
    else if (3 == indexPath.section)
    {
        // 保险
        if (0 == indexPath.row)
        {
            static NSString *cellIdentifier = @"cellIdentifier_orderInsurance";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
                
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
        // 车队电话
        else if (1 == indexPath.row)
        {
            static NSString *cellIdentifier = @"cellIdentifier_teamMobilePhone";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
                
                UILabel *descLabel = InsertLabel(cell.contentView,
                                                 CGRectMake(10, 0, 60, cellSize.height),
                                                 NSTextAlignmentRight,
                                                 @"车队电话",
                                                 SP15Font,
                                                 Common_BlackColor,
                                                 NO);
                
                CGFloat teamMobilePhoneOrginX = CGRectGetMaxX(descLabel.frame) + 20;
                InsertLabel(cell.contentView,
                            CGRectMake(teamMobilePhoneOrginX, 0, cellSize.width - teamMobilePhoneOrginX - 10, cellSize.height),
                            NSTextAlignmentLeft,
                            _defaultOrderEntity.teamMobilePhone,
                            SP15Font,
                            Common_ThemeColor,
                            NO);
            }
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击了车队电话
    if (3 == indexPath.section && 1 == indexPath.row)
    {
        [UIFactory call:_defaultOrderEntity.teamMobilePhone];
    }
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
