//
//  CityChooseListVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/28.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "CityChooseListVC.h"
#import "CityDetailVC.h"

@interface CityChooseListVC ()
{
    NSArray                     *_tabShowDataCellTitleArray;
}

@end

@implementation CityChooseListVC

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
                                 normalImg:nil
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
    [self setNavigationItemTitle:@"选择城市"];
}

- (void)setTabShowData
{
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:@"宁波消防", @"湖州消防", nil];
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
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
    
    CityDetailVC *cityDetail = [CityDetailVC loadFromNib];
    cityDetail.cityType = indexPath.row + 1;
    
    [self pushViewController:cityDetail];
}


@end
