//
//  ShuiYaVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "MonitoringStationsVC.h"
#import "DataListVC.h"

@interface MonitoringStationsVC ()
{
    NSArray                     *_tabShowDataCellTitleArray;
    NSArray                     *_tabShowDataCellImageArray;
}

@end

@implementation MonitoringStationsVC

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
                                    action:NULL];
    
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

- (void)setTabShowData
{
    NSArray *section_OneTitleArray = [NSArray arrayWithObjects:@"扫码二维码,下载律寻APP", nil];
    NSArray *section_OneImageArray = [NSArray arrayWithObjects:@"saoyisao", nil];
    
    NSArray *section_TwoTitleArray = [NSArray arrayWithObjects:@"喜欢律寻?打分鼓励下吧", nil];
    NSArray *section_TwoImageArray = [NSArray arrayWithObjects:@"xihuan", nil];
    
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:@"消防栓压力最新监测数据", @"消防栓压力最新报警数据", nil];
    _tabShowDataCellImageArray = [NSArray arrayWithObjects:section_OneImageArray, section_TwoImageArray, nil];
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
    
    DataListVC *dataList = [DataListVC loadFromNib];
    dataList.hidesBottomBarWhenPushed = YES;
    [self pushViewController:dataList];
}

@end

