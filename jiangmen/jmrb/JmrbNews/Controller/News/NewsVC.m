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
#import "MJRefresh.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "DetailNewsVC.h"
#import "NewsManagerVC.h"
#import "CycleScrollView.h"
#import "GCDThread.h"

NSString * const cellIdentifier_normal = @"cellIdentifier_normal";
NSString * const cellIdentifier_image = @"cellIdentifier_image";

@interface NewsVC ()
{
    NSMutableArray *_netAdsEntityArray;
    NSMutableArray *_netNewsEntityArray;
    
    NSInteger      _curPageIndex;
}

@end

@implementation NewsVC

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
    
    [self initialization];
    /*
    [self getNetworkData];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    self.title = _newsTypeEntity.newsTypeNameStr;
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetNewsRequestType_GetNewsList == request.tag)
        {
            [strongSelf->_tableView headerEndRefreshing];
            [strongSelf->_tableView footerEndRefreshing];
            
            if (1 == strongSelf->_curPageIndex)
            {
                strongSelf->_netNewsEntityArray = [strongSelf parseNetDataWithDic:successInfoObj];
            }
            else
            {
                [strongSelf->_netNewsEntityArray addObjectsFromArray:[strongSelf parseNetDataWithDic:successInfoObj]];
            }
            [strongSelf reloadTableData];
            
            // 请求广告
            if (!strongSelf->_netAdsEntityArray)
            {
                if ([strongSelf.newsTypeEntity.newsTypeNameStr isEqualToString:@"焦点" ])
                {
                    [strongSelf getNetAdListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
                }
                else
                {
                    [strongSelf parseHotNewsData];
                    [strongSelf configureTabHeaderBannerScrollView];
                }
            }
        }
        else if (NetNewsRequestType_GetAdsList)
        {
            [strongSelf parseAdNetDataWithDic:successInfoObj];
            [strongSelf configureTabHeaderBannerScrollView];
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
    [self getNetNewsListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
}

- (void)getNetNewsListDataWithNetCachePolicy:(NetCachePolicy)cachePolicy
{
    /*
    1．	newstype：新闻类别的Id
    2．	pageNum: 当前页数
    3．	pageSize: 每页行数
    4．	nopic 1为这类别含有小图片的新闻0为这一类的所有新闻
    */
    
    NSDictionary *dic = @{@"newstype": @(_newsTypeEntity.newsTypeId),
                          @"pageNum": @(_curPageIndex),
                          @"pageSize": @(15),
                          @"nopic": @(0)};
    
    [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetNewsList]
         parameterDic:dic
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetNewsRequestType_GetNewsList
             delegate:self
             userInfo:nil
       netCachePolicy:cachePolicy
         cacheSeconds:CacheNetDataTimeType_OneMinute];
}

- (void)getNetAdListDataWithNetCachePolicy:(NetCachePolicy)cachePolicy
{

    [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetAdsList]
         parameterDic:@{@"adId": @(1)}
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetNewsRequestType_GetAdsList
             delegate:self
             userInfo:nil
       netCachePolicy:cachePolicy
         cacheSeconds:CacheNetDataTimeType_OneMinute];
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    _networkDataDic = [dic objectForKey:@"response"];
    NSArray *newsItemList = [_networkDataDic objectForKey:@"item"];
    
    NSMutableArray *tempNewsEntityArray = [NSMutableArray arrayWithCapacity:newsItemList.count];

    if ([newsItemList isAbsoluteValid])
    {
        for (NSDictionary *newsItemDic in newsItemList)
        {
            News_NormalEntity *entity = [News_NormalEntity initWithDict:newsItemDic];
            [tempNewsEntityArray addObject:entity];
        }
    }
    return tempNewsEntityArray;
}

- (void)parseHotNewsData
{
    NSDictionary *hotNewsItemDic = [_networkDataDic objectForKey:@"newshot"];
    
    if ([hotNewsItemDic isAbsoluteValid])
    {
        _netAdsEntityArray = [NSMutableArray array];
        
        AdsEntity *entity = [AdsEntity initWithDict:hotNewsItemDic];
        [_netAdsEntityArray addObject:entity];
    }
}

- (void)parseAdNetDataWithDic:(NSDictionary *)dic
{
    NSArray *adItemsList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
    if ([adItemsList isAbsoluteValid])
    {
        _netAdsEntityArray = [NSMutableArray arrayWithCapacity:adItemsList.count];
        
        for (NSDictionary *adItem in adItemsList)
        {
            AdsEntity *entity = [AdsEntity initWithDict:adItem];
            [_netAdsEntityArray addObject:entity];
        }
    }
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
    
    // 上、下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(tabHeaderRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(tabFooterRefreshing)];
    
    [self.view addSubview:_tableView];
}

- (void)configureTabHeaderBannerScrollView
{
    if ([_netAdsEntityArray isAbsoluteValid])
    {
        NSMutableArray *imageSourceArray = [NSMutableArray arrayWithCapacity:_netAdsEntityArray.count];
        for (AdsEntity *item in _netAdsEntityArray)
        {
            [imageSourceArray addObject:item.adImageUrlStr];
        }
        
        CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, _tableView.boundsWidth, 200)
                                                             viewContentMode:ViewShowStyle_None
                                                                    delegate:nil
                                                             imgUrlsStrArray:imageSourceArray
                                                                isAutoScroll:NO
                                                                   isCanZoom:NO];
        _tableView.tableHeaderView = scrollView;
    }
}

- (void)viewDidCurrentView
{
    [self getNetworkData];
}

- (void)tabHeaderRefreshing
{
    _curPageIndex = 1;
    
    [self getNetNewsListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
}

- (void)tabFooterRefreshing
{
    ++_curPageIndex;
    
    [self getNetNewsListDataWithNetCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy];
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
    return _netNewsEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsCell_Normal getCellHeight];
    
//    return [NewsCell_Image getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell_Normal *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_normal];
    
    News_NormalEntity *entity = _netNewsEntityArray[indexPath.row];
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    News_NormalEntity *entity = _netNewsEntityArray[indexPath.row];
    
    UIViewController *vc = self.parentViewController;
    if ([vc isKindOfClass:[NewsManagerVC class]])
    {
        DetailNewsVC *detailNews = [[DetailNewsVC alloc] init];
        detailNews.newsId = entity.newsId;
        detailNews.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:detailNews animated:YES];
    }
}

@end
