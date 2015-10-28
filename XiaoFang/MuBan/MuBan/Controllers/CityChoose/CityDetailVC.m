//
//  CityDetailVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/28.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "CityDetailVC.h"
#import "AppDelegate.h"

@interface CityDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@end

@implementation CityDetailVC

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = Common_ThemeColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.clipsToBounds = NO;

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    
}

- (void)configureViewsProperties
{
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _cityType == 1 ? @"宁波消防栓水压监测系统" : @"湖州消防栓水压监测系统";
    
    [_enterBtn setRadius:4];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickEnterBtn:(id)sender
{
    if (_cityType == 1)
    {
        if (_isLoadTabBarController)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self presentViewController:SharedAppDelegate.baseTabBarController modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:^{
                
            }];
        }
    }
    else
    {
        SimpleAlert(UIAlertViewStyleDefault, AlertTitle, @"该市未开启智能消防", 1000, nil, nil, Confirm);
    }
}

@end
