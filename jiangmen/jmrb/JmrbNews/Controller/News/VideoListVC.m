//
//  VideoListVC.m
//  JmrbNews
//
//  Created by swift on 14/12/4.
//
//

#import "VideoListVC.h"
#import "MJRefresh.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface VideoListVC ()
{
    NSMutableArray *_netVideosEntityArray;
    
    NSInteger      _curPageIndex;
}

@end

@implementation VideoListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"视频新闻"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetVideosRequestType_GetVideosList == request.tag)
        {
            
        }
        
    }];
}

- (void)getNetworkData
{
    [self getNetVideosListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
}

- (void)getNetVideosListDataWithNetCachePolicy:(NetCachePolicy)cachePolicy
{
    /*
     1.pageNum: 当前页数
     2.pageSize: 每页行数
     */
    
    NSDictionary *dic = @{@"pageNum": @(_curPageIndex),
                          @"pageSize": @(15)};
    
    [self sendRequest:[[self class] getRequestURLStr:NetVideosRequestType_GetVideosList]
         parameterDic:dic
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetVideosRequestType_GetVideosList
             delegate:self
             userInfo:nil
       netCachePolicy:cachePolicy
         cacheSeconds:CacheNetDataTimeType_OneMinute];
}

- (void)parseNetDataWithDic:(NSDictionary *)dic
{
    
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds style:UITableViewStylePlain registerNibName:nil reuseIdentifier:nil];
    
    // 上、下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(tabHeaderRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(tabFooterRefreshing)];
    
    [self.view addSubview:_tableView];
}

- (void)tabHeaderRefreshing
{
    _curPageIndex = 1;
    
    [self getNetVideosListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
}

- (void)tabFooterRefreshing
{
    ++_curPageIndex;
    
    [self getNetVideosListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
