//
//  ImageNewsListVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/5.
//
//

#import "ImageNewsListVC.h"
#import "MJRefresh.h"
#import "ImageNewsCell.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "ImagePreviewController.h"

static NSString * const cellIdentifer_imageNews = @"cellIdentifer_imageNews";

@interface ImageNewsListVC ()
{
    NSMutableArray *_netImageNewsEntityArray;
    
    NSInteger      _curPageIndex;
}

@end

@implementation ImageNewsListVC

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"图片新闻"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetImagesRequestType_GetImagesList == request.tag)
        {
            [strongSelf->_tableView headerEndRefreshing];
            [strongSelf->_tableView footerEndRefreshing];
            
            if (1 == strongSelf->_curPageIndex)
            {
                strongSelf->_netImageNewsEntityArray = [strongSelf parseNetDataWithDic:successInfoObj];
            }
            else
            {
                [strongSelf->_netImageNewsEntityArray addObjectsFromArray:[strongSelf parseNetDataWithDic:successInfoObj]];
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
    
    [self sendRequest:[[self class] getRequestURLStr:NetImagesRequestType_GetImagesList]
         parameterDic:dic
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetImagesRequestType_GetImagesList
             delegate:self
             userInfo:nil
       netCachePolicy:cachePolicy
         cacheSeconds:CacheNetDataTimeType_OneMinute];
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    NSArray *imagesItemList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
    NSMutableArray *tempImagesEntityArray = [NSMutableArray arrayWithCapacity:imagesItemList.count];
    
    if ([imagesItemList isAbsoluteValid])
    {
        for (NSDictionary *imageItemDic in imagesItemList)
        {
            ImageNewsEntity *entity = [ImageNewsEntity initWithDict:imageItemDic];
            [tempImagesEntityArray addObject:entity];
        }
    }
    return tempImagesEntityArray;
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds style:UITableViewStylePlain registerNibName:NSStringFromClass([ImageNewsCell class]) reuseIdentifier:cellIdentifer_imageNews];
    
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
    return _netImageNewsEntityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ImageNewsCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellSeparatorSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer_imageNews];
    
    ImageNewsEntity *entity = _netImageNewsEntityArray[indexPath.section];
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ImageNewsEntity *entity = _netImageNewsEntityArray[indexPath.section];
    
    NSMutableArray *tempImageItemsArray = [NSMutableArray array];
    for (NSString *imageUrlStr in entity.imageUrlsStrArray)
    {
        NSString *desc = [NSString stringWithFormat:@"暂无描述%d",[entity.imageUrlsStrArray indexOfObject:imageUrlStr]];
        
        ImageItem *item = [[ImageItem alloc] initWithImageUrlOrName:imageUrlStr imageDesc:desc];
        [tempImageItemsArray addObject:item];
    }
    
    ImagePreviewController *imagePreview = [ImagePreviewController new];
    imagePreview.titleStr = entity.imageNewsNameStr;
    imagePreview.imageItemsArray = tempImageItemsArray;
    imagePreview.hidesBottomBarWhenPushed = YES;
    [self pushViewController:imagePreview];
}

@end
