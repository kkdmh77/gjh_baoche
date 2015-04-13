//
//  OrderListVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/1.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "OrderListVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "OrderListCell.h"
#import "GJHSlideSwitchView.h"
#import "DetailOrderVC.h"
#import <objc/runtime.h>

static NSString * const cellIdentifer_orderList = @"cellIdentifer_orderList";

@interface OrderListVC () <GJHSlideSwitchViewDelegate>
{
    NSMutableArray *_netOrderEntityArray;
    
    NSInteger      _queryOrderType;
}

@end

@implementation OrderListVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        _queryOrderType = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getNetworkData];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"我的订单"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetOrderRequesertType_GetAllOrderList == request.tag)
        {
            [strongSelf parseNetworkDataWithSourceDic:successInfoObj];
            [strongSelf reloadTabData];
        }
    }];
}

- (void)getNetworkData
{
    /*
     OrderStatus 说明
     OS_CONFIRMED  --未付款
     OS_CANCELED   --已取消
     OS_VERIFIED   --待使用
     OS_FINISH   --已使用
     OS_INVALID  --已错过
     OS_CLOSED  --交易关闭
     OS_PAY_OVERDUE --已过期
     
     PayStatus
     PS_UNPAID  --未付款
     PS_PAYING  --支付中
     PS_PAYED    --已付款
     
     订单项 中的退款状态  也就是orderItem里面的AfterSaleStatus状态
     AS_ENABLE  --退货/退款
     AS_REFUND_APPLY  --退款申请已经提交，等待处理
     AS_REFUNDING    --已转交财务处理退款事宜，请耐心等候
     AS_REFUND_REJECTED   --退款审核不通过
     AS_REFUNDED   --卖家已退款，请注意查收
     AS_BACK_APPLY   --退货申请已经提交，等待受理
     AS_BACK_APPROVED   --退货申请已批准，请完善申请资料
     AS_BACK_REJECTED  --退货申请被驳回，请重新申请或联系客服
     AS_BACK_VERIFIED   --审核通过，正在转交财务处理退款事宜
     AS_CANCEL  --买家已取消退货退款
     AS_DISABLE --禁用
     */
    
    
    // 订单查询类型 0:全部 1:等待支付 2:等待使用 3:已经使用 4:退款
    [self sendRequest:[[self class] getRequestURLStr:NetOrderRequesertType_GetAllOrderList]
         parameterDic:@{@"type": @(_queryOrderType),
                        @"pageNo": @(1),
                        @"pageSize": @(1000)}
       requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
    requestMethodType:RequestMethodType_GET
           requestTag:NetOrderRequesertType_GetAllOrderList];
}

- (void)initialization
{
    // slider switch
    GJHSlideSwitchView *sliderSwitch = [[GJHSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, kDefaultSlideSwitchViewHeight) titlesArray:@[ @"全部", @"待使用", @"未支付", @"已使用"]];
    sliderSwitch.slideSwitchViewDelegate = self;
    sliderSwitch.tabItemNormalColor = Common_BlackColor;
    sliderSwitch.tabItemSelectedColor = Common_ThemeColor;
    sliderSwitch.shadowImage = [UIImage imageWithColor:Common_ThemeColor size:CGSizeMake(1, 1)];
    sliderSwitch.isTabItemEqualWidthInFullScreenWidth = YES;
    sliderSwitch.backgroundColor = [UIColor whiteColor];
    [sliderSwitch buildUI];
    [self.view addSubview:sliderSwitch];
    
    // tab
    [self setupTableViewWithFrame:CGRectMake(0, kDefaultSlideSwitchViewHeight, self.viewBoundsWidth, self.viewBoundsHeight - kDefaultSlideSwitchViewHeight)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([OrderListCell class])
                  reuseIdentifier:cellIdentifer_orderList];
}

- (void)parseNetworkDataWithSourceDic:(NSDictionary *)dic
{
    NSArray *dataList = [dic safeObjectForKey:@"orders"];
    _netOrderEntityArray = [NSMutableArray arrayWithCapacity:dataList.count];
    
    for (NSDictionary *dataDic in dataList)
    {
        OrderListEntity *entity = [OrderListEntity initWithDict:dataDic];
        
        [_netOrderEntityArray addObject:entity];
    }
}
        
- (void)reloadTabData
{
    [_tableView reloadData];
}

- (void)clearAndReloadTabData
{
    [_netOrderEntityArray removeAllObjects];
    [self reloadTabData];
}

- (OrderListEntity *)curIndexTabCellShowData:(NSInteger)index
{
    return index < _netOrderEntityArray.count ? _netOrderEntityArray[index] : nil;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _netOrderEntityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderListCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellSeparatorSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer_orderList];
    
    OrderListEntity *entity = [self curIndexTabCellShowData:indexPath.section];
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailOrderVC *detailOrder = [[DetailOrderVC alloc] init];
    detailOrder.defaultOrderEntity = [self curIndexTabCellShowData:indexPath.section];
    detailOrder.hidesBottomBarWhenPushed = YES;
    
    objc_setAssociatedObject(detailOrder, object_getClassName(self), self, OBJC_ASSOCIATION_ASSIGN);
    
    [self pushViewController:detailOrder];
}

#pragma mark - GJHSlideSwitchViewDelegate methods

- (void)slideSwitchView:(GJHSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    switch (number)
    {
        case 0:
        {
            _queryOrderType = 0;
        }
            break;
        case 1:
        {
            _queryOrderType = 2;
        }
            break;
        case 2:
        {
            _queryOrderType = 1;
        }
            break;
        case 3:
        {
            _queryOrderType = 3;
        }
            break;
            
        default:
            break;
    }
    
    [self clearAndReloadTabData];
    [self getNetworkData];
}

@end
