//
//  SettingVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "SettingVC.h"
#import "AboutVC.h"
#import "RegisterVC.h"
#import "PRPAlertView.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import "CityChooseListVC.h"

@interface SettingVC ()
{
    NSArray                     *_tabShowDataCellTitleArray;
    NSArray                     *_tabShowDataCellImageArray;
}

@end

@implementation SettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"nav_menu"]
                            highlightedImg:nil
                                    action:@selector(gotoCityChoose)];
    
    [self setTabShowData];
    [self initialization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:self.title];
}

// 进入城市选择页面
- (void)gotoCityChoose
{
    CityChooseListVC *cityChoose = [[CityChooseListVC alloc] init];
    cityChoose.isLoadTabBarController = YES;
    UINavigationController *cityChooseNav = [[UINavigationController alloc] initWithRootViewController:cityChoose];
    [self presentViewController:cityChooseNav animated:YES completion:nil];
}

- (void)setTabShowData
{
//    NSArray *section_OneTitleArray = [NSArray arrayWithObjects:@"扫码二维码,下载律寻APP", nil];
//    NSArray *section_OneImageArray = [NSArray arrayWithObjects:@"saoyisao", nil];
//    
//    NSArray *section_TwoTitleArray = [NSArray arrayWithObjects:@"喜欢律寻?打分鼓励下吧", nil];
//    NSArray *section_TwoImageArray = [NSArray arrayWithObjects:@"xihuan", nil];
    
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:@"程序注册", @"关于我们", @"退出登录", @"软件更新", nil];
//    _tabShowDataCellImageArray = [NSArray arrayWithObjects:section_OneImageArray, section_TwoImageArray, nil];
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
}

- (NSString *)getOneCellTitleWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray = _tabShowDataCellTitleArray[indexPath.section];
    NSString *titleStr = titleArray[indexPath.row];
    
    return titleStr;
}

- (NSString *)getOneCellImageNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageNameArray = _tabShowDataCellImageArray[indexPath.section];
    NSString *imageNameStr = imageNameArray[indexPath.row];
    
    return imageNameStr;
}

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tabShowDataCellTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
        
        cell.textLabel.font = SP16Font;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    NSString *titleStr = _tabShowDataCellTitleArray[indexPath.row];
    
    cell.textLabel.text = titleStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        RegisterVC *registerVC = [[RegisterVC alloc] init];
        registerVC.hidesBottomBarWhenPushed = YES;
        
        [self pushViewController:registerVC];
    }
    else if (indexPath.row == 1)
    {
        AboutVC *about = [[AboutVC alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        
        [self pushViewController:about];
    }
    else if (indexPath.row == 2)
    {
        [PRPAlertView showWithTitle:AlertTitle message:@"确定要退出登录吗？" cancelTitle:Cancel cancelBlock:^{
            
        } otherTitle:Confirm otherBlock:^{
            SharedAppDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginVC loadFromNib]];
        }];
    }
}

@end

