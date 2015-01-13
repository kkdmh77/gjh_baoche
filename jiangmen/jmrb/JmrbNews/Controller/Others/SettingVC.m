//
//  SettingVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/16.
//
//

#import "SettingVC.h"
#import "UserInfoModel.h"
#import "CollectionVC.h"
#import "AboutVC.h"
#import "PRPAlertView.h"
#import "DownloadCache.h"
#import "CoreData+MagicalRecord.h"
#import "InterfaceHUDManager.h"

@interface SettingVC ()
{
    NSArray *_tabTitleArray;
    NSArray *_tabImageArray;
}

@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                            barButtonTitle:Cancel
                                    action:@selector(backViewController)];
    
    [self getLocalTabShowData];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)getLocalTabShowData
{
    NSArray *oneSectionTitleArray = @[@"收藏", @"清除缓存",@"关于"];
    NSArray *oneSectionImageArray = @[@"shoucang", @"shanchu",@"guanyu"];
    
    NSArray *twoSectionTitleArray = @[@"退出"];
    NSArray *twoSectionImageArray = @[@"tuichu"];
    
    if ([UserInfoModel getUserDefaultMobilePhoneNum])
    {
        _tabTitleArray = @[oneSectionTitleArray, twoSectionTitleArray];
        _tabImageArray = @[oneSectionImageArray, twoSectionImageArray];
    }
    else
    {
        _tabTitleArray = @[oneSectionTitleArray];
        _tabImageArray = @[oneSectionImageArray];
    }
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"设置"];
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStyleGrouped
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSString *)curTitleWithIndex:(NSIndexPath *)indexPath
{
    NSArray *sectionTitleArray = _tabTitleArray[indexPath.section];
    return sectionTitleArray[indexPath.row];
}

- (NSString *)curImageNameWithIndex:(NSIndexPath *)indexPath
{
    NSArray *sectionImageNameArray = _tabImageArray[indexPath.section];
    return sectionImageNameArray[indexPath.row];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tabTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionTitleArray = _tabTitleArray[section];
    
    return sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = CellBackgroundColor;
        cell.textLabel.font = SP14Font;
        cell.textLabel.textColor = Common_BlackColor;
    }
    
    cell.imageView.image = [UIImage imageNamed:[self curImageNameWithIndex:indexPath]];
    cell.textLabel.text = [self curTitleWithIndex:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CollectionVC *collection = [[CollectionVC alloc] init];
            [self pushViewController:collection];
        }
        else if (1 == indexPath.row)
        {
            [PRPAlertView showWithTitle:@"您是否要清除缓存?" message:nil cancelTitle:Cancel cancelBlock:nil otherTitle:Confirm otherBlock:^{
                
                [DownloadCache MR_truncateAll];
                
                [PRPAlertView showWithTitle:@"已成功清除缓存" message:nil cancelTitle:nil cancelBlock:nil otherTitle:Confirm otherBlock:nil];
            }];
        }
        else if (2 == indexPath.row)
        {
            AboutVC *about = [[AboutVC alloc] init];
            [self pushViewController:about];
        }
    }
    else if (1 == indexPath.section)
    {
        [UserInfoModel setUserDefaultLoginName:nil];
        [UserInfoModel setUserDefaultPassword:nil];
        
        [UserInfoModel setUserDefaultUserId:nil];
        [UserInfoModel setUserDefaultMobilePhoneNum:nil];
        
        [self backViewController];
    }
}

@end
