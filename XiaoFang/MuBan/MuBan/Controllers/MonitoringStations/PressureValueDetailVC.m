//
//  PressureValueDetailVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "PressureValueDetailVC.h"

@interface PressureValueDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *pressureValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *MonitoringStationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation PressureValueDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:[NSString stringWithFormat:@"编号0%ld", _entity.number]];
}

- (void)configureViewsProperties
{
    _pressureValueLabel.textColor = Common_LiteBlueColor;
    
    // 赋值
    if (_entity)
    {
        _pressureValueLabel.text = [NSString stringWithFormat:@"%.2fMPa", _entity.value];
        _MonitoringStationsLabel.text = [NSString stringWithFormat:@"监测点：0%ld", _entity.number];
        _leaderNameLabel.text = [NSString stringWithFormat:@"负责人：%@", _entity.leaderNameStr];
        _companyLabel.text = [NSString stringWithFormat:@"单位：%@", _entity.companyStr];
        _mobilePhoneLabel.text = [NSString stringWithFormat:@"电话：%@", _entity.mobilePhoneStr];
        _positionLabel.text = [NSString stringWithFormat:@"地址：%@", _entity.positionStr];
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

@end
