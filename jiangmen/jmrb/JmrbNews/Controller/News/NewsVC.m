//
//  NewsVC.m
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "NewsVC.h"
#import "NewsCell_Normal.h"
#import "NewsCell_Image.h"

NSString * const cellIdentifier_normal = @"cellIdentifier_normal";
NSString * const cellIdentifier_image = @"cellIdentifier_image";

@interface NewsVC ()
{
    
}

@end

@implementation NewsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:LocalizedStr(NavTitle_ShoppingCarKey)];
}

- (void)setNetworkRequestStatusBlocks
{
    
}

// 设置界面
- (void)initialization
{
    // tab
    _tableView = InsertTableView(nil, self.view.bounds, self, self, UITableViewStylePlain);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell_Normal class]) bundle:nil] forCellReuseIdentifier:cellIdentifier_normal];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell_Image class]) bundle:nil] forCellReuseIdentifier:cellIdentifier_image];
    
    [self.view addSubview:_tableView];
}

- (void)getNetworkData
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row % 2)
    {
        return [NewsCell_Normal getCellHeight];
    }
    return [NewsCell_Image getCellHeight];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section != 0 ? CellSeparatorSpace : 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:0 == indexPath.row % 2 ? cellIdentifier_normal : cellIdentifier_image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
