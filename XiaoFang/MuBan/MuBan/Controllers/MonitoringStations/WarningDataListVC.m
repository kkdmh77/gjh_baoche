//
//  DataListVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WarningDataListVC.h"
#import "CommonEntity.h"
#import "WarningDataListCell.h"
#import "WarningValueDetailVC.h"
#import "GraphVC.h"
#import "AppDelegate.h"
#import "BaseNetworkViewController+NetRequestManager.h"

static NSString * const warningDataListCellIdentifier = @"warningDataListCellIdentifier";

@interface WarningDataListVC ()
{
    // NSArray *_tabDataArray;
    
    NSArray *_netEntityArray;
}

@property (weak, nonatomic) IBOutlet UIButton *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *valueLabel;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation WarningDataListVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNetworkData];
    // [self configureLocalData];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"消防栓压力最新报警数据"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetWarningDataList == request.tag)
        {
            strongSelf->_netEntityArray = [weakSelf parseNetwordDataWithInfoObj:successInfoObj];
            
            [weakSelf.tab reloadData];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                        @"trancode": @"BC0005",
                        @"page": @(1),
                        @"pageSize": @(100)}
    requestMethodType:RequestMethodType_POST
           requestTag:NetWaterPressureRequestType_GetWarningDataList];
}

- (NSArray *)parseNetwordDataWithInfoObj:(NSDictionary *)obj
{
    NSArray *netDataArray = [obj safeObjectForKey:@"list"];
    NSMutableArray *entityArray = [NSMutableArray arrayWithCapacity:netDataArray.count];
    
    for (NSDictionary *dic in netDataArray)
    {
        WarningDataListEntity *entity = [WarningDataListEntity initWithDict:dic];
        [entityArray addObject:entity];
    }
    
    return entityArray;
}

- (void)configureViewsProperties
{
    CGFloat width = (IPHONE_WIDTH - 45 - 95) / 2;
    UIColor *BGColor = HEXCOLOR(0XF0F0F0);
    
   [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(width);
   }];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    
    [_numberLabel addLineWithPosition:ViewDrawLinePostionType_Right
                            lineColor:CellSeparatorColor
                            lineWidth:LineWidth];
    [_nameLabel addLineWithPosition:ViewDrawLinePostionType_Right
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    [_positionLabel addLineWithPosition:ViewDrawLinePostionType_Right
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    
    _numberLabel.backgroundColor = BGColor;
    _nameLabel.backgroundColor = BGColor;
    _positionLabel.backgroundColor = BGColor;
    _valueLabel.backgroundColor = BGColor;
    
    // tab
    [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([WarningDataListCell class]) bundle:nil] forCellReuseIdentifier:warningDataListCellIdentifier];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)configureLocalData
{
    /*
    DataEntity *entityOne = [[DataEntity alloc] initWithNumber:@"001" nameStr:@"20码头楼上" position:@"海曙区青林湾21号" value:0.69 leader:@"王校军" company:@"三冀公司" mobilePhone:@"18623437653" companyPosition:nil];
    DataEntity *entityTwo = [[DataEntity alloc] initWithNumber:@"002" nameStr:@"楼顶消防通道" position:@"上海市虹桥机场" value:0.32 leader:@"孙磊" company:@"网易科技" mobilePhone:@"18523437653" companyPosition:nil];
    DataEntity *entityThird = [[DataEntity alloc] initWithNumber:@"003" nameStr:@"定位器手动测量" position:@"广东省广州市" value:0.41 leader:@"陈萌" company:@"阿里巴巴" mobilePhone:@"13523437653" companyPosition:nil];
    DataEntity *entityFour = [[DataEntity alloc] initWithNumber:@"004" nameStr:@"20码头" position:@"北京人民大会堂" value:0.78 leader:@"胡娟" company:@"腾讯科技" mobilePhone:@"18623437653" companyPosition:nil];
    DataEntity *entityFive = [[DataEntity alloc] initWithNumber:@"005" nameStr:@"室内消防栓" position:@"海曙区" value:0.93 leader:@"周平" company:@"苹果公司" mobilePhone:@"18623437653" companyPosition:nil];
    
    _tabDataArray = [NSArray arrayWithObjects:entityOne, entityTwo, entityThird, entityFour, entityFive, nil];
     */
    
    // _tabDataArray = SharedAppDelegate.tabDataArray;
}

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WarningDataListCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarningDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:warningDataListCellIdentifier];
    
    WarningDataListEntity *entity = _netEntityArray[indexPath.row];
    [cell loadDataWithShowEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WarningValueDetailVC *warningValueDetail = [WarningValueDetailVC loadFromNib];
    warningValueDetail.entity = _netEntityArray[indexPath.row];

    [self pushViewController:warningValueDetail];
}

@end
