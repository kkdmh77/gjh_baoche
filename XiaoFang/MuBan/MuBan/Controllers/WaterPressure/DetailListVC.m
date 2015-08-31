//
//  DetailListVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "DetailListVC.h"
#import "DetailInfoListCell.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"

static NSString * const detailInfoListCellIdentifier = @"detailInfoListCellIdentifier";

@interface DetailListVC ()
{
    WaterPressureDetailEntity *_waterPressureDetailEntity;
}

@property (weak, nonatomic) IBOutlet UILabel *monitoringStationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monitoringTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UIButton *valueBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation DetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"水压详情列表"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetWaterPressureDetail == request.tag)
        {
            strongSelf->_waterPressureDetailEntity = [weakSelf parseNetwordDataWithInfoObj:successInfoObj];
            
            [weakSelf loadWaterPressureDetailData];
            [weakSelf.tab reloadData];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                        @"trancode": @"BC0002",
                        @"sid": _sid,
                        @"page": @(1),
                        @"pageSize": @(100)}
    requestMethodType:RequestMethodType_POST
           requestTag:NetWaterPressureRequestType_GetWaterPressureDetail];
}

- (WaterPressureDetailEntity *)parseNetwordDataWithInfoObj:(NSDictionary *)obj
{
    return [WaterPressureDetailEntity initWithDict:obj];
}

- (void)configureViewsProperties
{
    // 设置属性
    CGFloat width = (IPHONE_WIDTH - 80) / 2;
    UIColor *BGColor = HEXCOLOR(0XF0F0F0);
    
    [_collectTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    [_noteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    
    [_valueBtn addLineWithPosition:ViewDrawLinePostionType_Right
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    [_collectTimeBtn addLineWithPosition:ViewDrawLinePostionType_Right
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
    
    _valueBtn.backgroundColor = BGColor;
    _collectTimeBtn.backgroundColor = BGColor;
    _noteBtn.backgroundColor = BGColor;
    
    // tab
    [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([DetailInfoListCell class]) bundle:nil] forCellReuseIdentifier:detailInfoListCellIdentifier];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)loadWaterPressureDetailData
{
    // 赋值
    _monitoringStationsLabel.text = [NSString stringWithFormat:@"监测点：%@", _waterPressureDetailEntity.monitoringStations];
    _monitoringTypeLabel.text = [NSString stringWithFormat:@"监测点类型：%@", _waterPressureDetailEntity.monitoringType];
    _leaderNameLabel.text = [NSString stringWithFormat:@"负责人：%@", _waterPressureDetailEntity.leaderName];
    _leaderPhoneLabel.text = [NSString stringWithFormat:@"负责人电话：%@", _waterPressureDetailEntity.leaderPhone];
    _companyLabel.text = [NSString stringWithFormat:@"消防负责单位：%@", _waterPressureDetailEntity.company];
    _companyPhoneLabel.text = [NSString stringWithFormat:@"消防负责单位电话：%@", _waterPressureDetailEntity.companyPhone];
    _positionLabel.text = [NSString stringWithFormat:@"地址：%@", _waterPressureDetailEntity.position];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _waterPressureDetailEntity.collectListEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DetailInfoListCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoListCellIdentifier];
    
    WaterPressureDetail_CollectListEntity *entity = _waterPressureDetailEntity.collectListEntityArray[indexPath.row];
    
    [cell loadDataWithShowEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
