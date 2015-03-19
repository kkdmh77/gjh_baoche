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

static NSString * const cellIdentifer_orderList = @"cellIdentifer_orderList";

@interface OrderListVC () <GJHSlideSwitchViewDelegate>
{
    NSMutableArray *_netOrderEntityArray;
}

@end

@implementation OrderListVC

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
    [self sendRequest:[[self class] getRequestURLStr:NetOrderRequesertType_GetAllOrderList]
         parameterDic:@{@"pageNo": @(1), @"pageSize": @(1000)}
       requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
    requestMethodType:RequestMethodType_GET
           requestTag:NetOrderRequesertType_GetAllOrderList];
}

- (void)initialization
{
    // slider switch
    GJHSlideSwitchView *sliderSwitch = [[GJHSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, kDefaultSlideSwitchViewHeight) titlesArray:@[@"待使用", @"未支付", @"已使用", @"已退款"]];
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
    [self pushViewController:detailOrder];
}

#pragma mark - GJHSlideSwitchViewDelegate methods

- (void)slideSwitchView:(GJHSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
}

@end
