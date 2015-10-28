//
//  PressureValueDetailVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "MonitoringValueDetailVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"

@interface MonitoringValueDetailVC ()
{
    MonitoringValueDetailEntity *_monitoringValueDetailEntity;
}

@property (weak, nonatomic) IBOutlet UILabel *pressureValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *MonitoringStationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation MonitoringValueDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNetworkData];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:[NSString stringWithFormat:@"编号%@", _entity.number]];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetMonitoringValueDetail == request.tag)
        {
            strongSelf->_monitoringValueDetailEntity = [weakSelf parseNetwordDataWithInfoObj:successInfoObj];
            
            [weakSelf loadMonitoringValueDetailData];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                        @"trancode": @"BC0010",
                        @"sid": _entity.number}
    requestMethodType:RequestMethodType_POST
           requestTag:NetWaterPressureRequestType_GetMonitoringValueDetail];
}

- (MonitoringValueDetailEntity *)parseNetwordDataWithInfoObj:(NSDictionary *)obj
{
    return [MonitoringValueDetailEntity initWithDict:[obj safeObjectForKey:@"infor"]];
}

- (void)configureViewsProperties
{
    _pressureValueLabel.textColor = Common_LiteBlueColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)loadMonitoringValueDetailData
{
    // 赋值
    _pressureValueLabel.text = [NSString stringWithFormat:@"%.2fMPa", _entity.value.doubleValue];
    
    _MonitoringStationsLabel.text = [NSString stringWithFormat:@"监测点：%@", _monitoringValueDetailEntity.monitoringStations];
    _leaderNameLabel.text = [NSString stringWithFormat:@"负责人：%@", _monitoringValueDetailEntity.leaderName];
    _companyLabel.text = [NSString stringWithFormat:@"单位：%@", _monitoringValueDetailEntity.company];
    _mobilePhoneLabel.text = [NSString stringWithFormat:@"电话：%@", _monitoringValueDetailEntity.companyPhone];
    _positionLabel.text = [NSString stringWithFormat:@"地址：%@", _monitoringValueDetailEntity.position];
}

@end
