//
//  SettingVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/16.
//
//

#import "SettingVC.h"

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
    NSArray *oneSectionImageArray = @[@"tab_bbs_selected", @"tab_bbs_selected",@"tab_bbs_selected"];
    
    NSArray *twoSectionTitleArray = @[@"退出"];
    NSArray *twoSectionImageArray = @[@"tab_bbs_selected"];
    
    _tabTitleArray = @[oneSectionTitleArray, twoSectionTitleArray];
    _tabImageArray = @[oneSectionImageArray, twoSectionImageArray];
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"设置"];
}

- (void)getNetworkData
{
    [[NetRequestManager sharedInstance] sendRequest:[NSURL URLWithString:@"http://115.159.30.191:80/WOGO/upDownload"] parameterDic:@{@"userId": @"43", @"trancode": @"BC0025", @"goods":@"1"} requestTag:1000 delegate:self userInfo:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
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
}

@end
