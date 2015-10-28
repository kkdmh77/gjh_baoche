//
//  PressureValueDetailVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WarningValueDetailVC.h"

@interface WarningValueDetailVC ()

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

- (void)configureViewsProperties
{
    _solveResultLabel.textColor = Common_LiteBlueColor;
    
    // 赋值
    if (_entity)
    {
       
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

@end
