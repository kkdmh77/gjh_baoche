//
//  VideoListVC.m
//  JmrbNews
//
//  Created by swift on 14/12/4.
//
//

#import "VideoNewsListVC.h"
#import "MJRefresh.h"
#import "CommonEntity.h"
#import "VideoNewsCell.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "DetailNewsVC.h"

@interface VideoNewsListVC ()
{
    NSMutableArray *_netVideoNewsEntityArray;
    
    NSInteger      _curPageIndex;
}

@end

static NSString * const cellIdentifer_videoNews = @"cellIdentifer_videoNews";

@implementation VideoNewsListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _curPageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
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
    [self setNavigationItemTitle:@"视频新闻"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetVideosRequestType_GetVideosList == request.tag)
        {
            [strongSelf->_tableView headerEndRefreshing];
            [strongSelf->_tableView footerEndRefreshing];
            
            if (1 == strongSelf->_curPageIndex)
            {
                strongSelf->_netVideoNewsEntityArray = [strongSelf parseNetDataWithDic:successInfoObj];
            }
            else
            {
                [strongSelf->_netVideoNewsEntityArray addObjectsFromArray:[strongSelf parseNetDataWithDic:successInfoObj]];
            }
            [strongSelf reloadTableData];
        }
        
    } failedBlock:^(NetRequest *request, NSError *error) {
        STRONGSELF
        [strongSelf->_tableView headerEndRefreshing];
        [strongSelf->_tableView footerEndRefreshing];
        
        [weakSelf setDefaultNetFailedBlockImplementationWithNetRequest:request error:error otherExecuteBlock:nil];
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
         cacheSeconds:CacheNetDataTimeType_OneDay];
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    NSArray *videosItemList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
    NSMutableArray *tempVideosEntityArray = [NSMutableArray arrayWithCapacity:videosItemList.count];
    
    if ([videosItemList isAbsoluteValid])
    {
        for (NSDictionary *videoItemDic in videosItemList)
        {
            VideoNewsEntity *entity = [VideoNewsEntity initWithDict:videoItemDic];
            [tempVideosEntityArray addObject:entity];
        }
    }
    return tempVideosEntityArray;
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds style:UITableViewStylePlain registerNibName:NSStringFromClass([VideoNewsCell class]) reuseIdentifier:cellIdentifer_videoNews];
    
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
    return _netVideoNewsEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoNewsCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer_videoNews];
    
    VideoNewsEntity *entity = _netVideoNewsEntityArray[indexPath.row];
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoNewsEntity *entity = _netVideoNewsEntityArray[indexPath.row];
    
    DetailNewsVC *detailNews = [[DetailNewsVC alloc] init];
    detailNews.newsId = entity.videoNewsId;
    detailNews.newsImageUrlStr = entity.videoImageUrlStr;
    detailNews.newsTitleStr = entity.videoNameStr;
    detailNews.newsShareurlStr = entity.newsShareurlStr;
    detailNews.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailNews];
}

@end
