//
//  CollectionVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 15/1/10.
//
//

#import "CollectionVC.h"
#import "CollectionCell.h"
#import "DetailNewsVC.h"
#import "NewsCollectionEntity.h"
#import "CoreData+MagicalRecord.h"

NSString * const cellIdentifier_Collection = @"cellIdentifier_Collection";

@interface CollectionVC ()
{
    NSArray *_collectionEntityArray;
}

@end

@implementation CollectionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCollectionNewsData];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"我的收藏"];
}

- (void)getCollectionNewsData
{
    _collectionEntityArray = [NewsCollectionEntity MR_findAll];
}

// 设置界面
- (void)initialization
{
    // tab
    _tableView = InsertTableView(nil, self.view.bounds, self, self, UITableViewStylePlain);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier_Collection];
    
    [self.view addSubview:_tableView];
}

- (void)reloadTableData
{
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectionEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CollectionCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_Collection];
    
    NewsCollectionEntity *entity = _collectionEntityArray[indexPath.row];
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsCollectionEntity *entity = _collectionEntityArray[indexPath.row];
    
    DetailNewsVC *detailNews = [[DetailNewsVC alloc] init];
    detailNews.newsId = entity.newsId.integerValue;
    detailNews.newsImageUrlStr = entity.newsImageUrlStr;
    detailNews.newsTitleStr = entity.newsTitleStr;
    detailNews.newsShareurlStr = kNewsShareUrlStr;
    detailNews.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailNews];
}

@end
