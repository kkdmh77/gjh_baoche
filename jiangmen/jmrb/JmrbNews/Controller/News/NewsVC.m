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
#import "GCDThread.h"

NSString * const cellIdentifier_normal = @"cellIdentifier_normal";
NSString * const cellIdentifier_image = @"cellIdentifier_image";

@interface NewsVC ()
{
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

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    NSArray *newsItemList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
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
        [vc.navigationController pushViewController:detailNews animated:YES];
    }
}

@end
