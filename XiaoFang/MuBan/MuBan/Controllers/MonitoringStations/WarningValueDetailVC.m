//
//  PressureValueDetailVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WarningValueDetailVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface WarningValueDetailVC ()
{
    WarningValueDetailEntity *_warningValueDetailEntity;
}

@property (weak, nonatomic) IBOutlet UILabel *solveResultLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *solveDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *solveTimeLabel;

@end

@implementation WarningValueDetailVC

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
    [self setNavigationItemTitle:[NSString stringWithFormat:@"报警数据详情"]];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetWarningValueDetail == request.tag)
        {
            strongSelf->_warningValueDetailEntity = [weakSelf parseNetwordDataWithInfoObj:successInfoObj];
            
            [weakSelf loadWarningValueDetailData];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                        @"trancode": @"BC0006",
                        @"sid": _entity.number,
                        @"fid": _entity.fId,
                        @"page": @(1),
                        @"pageSize": @(100)}
    requestMethodType:RequestMethodType_POST
           requestTag:NetWaterPressureRequestType_GetWarningValueDetail];
}

- (WarningValueDetailEntity *)parseNetwordDataWithInfoObj:(NSDictionary *)obj
{
    return [WarningValueDetailEntity initWithDict:[obj safeObjectForKey:@"infor"]];
}

- (void)configureViewsProperties
{
    _solveResultLabel.textColor = Common_LiteBlueColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)loadWarningValueDetailData
{
    // 赋值
    _solveResultLabel.text = _warningValueDetailEntity.solveResult;
    
    _numberLabel.text = [NSString stringWithFormat:@"监测点：%@", _entity.number];
    _warningTypeLabel.text = [NSString stringWithFormat:@"报警类型：%@",  _entity.warningType];
    _warningDateLabel.text = [NSString stringWithFormat:@"报警日期：%@",  _entity.warningDate];
    _warningTimeLabel.text = [NSString stringWithFormat:@"报警时间：%@",  _entity.warningTime];
    _warningReasonLabel.text = [NSString stringWithFormat:@"故障原因：%@", _warningValueDetailEntity.warningReason];
    _solveDateLabel.text = [NSString stringWithFormat:@"处理日期：%@", _warningValueDetailEntity.solveDate];
    _solveTimeLabel.text = [NSString stringWithFormat:@"处理时间：%@", _warningValueDetailEntity.solveTime];
   
}

@end
