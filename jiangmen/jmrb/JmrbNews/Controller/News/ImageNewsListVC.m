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
#import "CommentVC.h"
#import "AppPropertiesInitialize.h"
#import "CommentSendController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSShareViewDelegate.h>
#import <ShareSDK/ISSViewDelegate.h>

static NSString * const cellIdentifer_imageNews = @"cellIdentifer_imageNews";

@interface ImageNewsListVC () <ISSShareViewDelegate, ISSViewDelegate>
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
    
    [AppPropertiesInitialize setKeyboardManagerEnable:NO];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AppPropertiesInitialize setKeyboardManagerEnable:YES];
    
    [super viewWillDisappear:animated];
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
            if ([entity.imageUrlsStrArray isAbsoluteValid])
            {
                [tempImagesEntityArray addObject:entity];
            }
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
    WEAKSELF
    [cell setHandle:^(ImageNewsCell *cell, CellOperationType type, id sender) {
        
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        ImageNewsEntity *entity = _netImageNewsEntityArray[indexPath.section];
        
        if (CellOperationType_CheckComment == type)
        {
            CommentVC *commentVC = [[CommentVC alloc] init];
            commentVC.newsId = entity.imageNewsId;
            commentVC.newsTitleStr = entity.imageNewsNameStr;
            [weakSelf pushViewController:commentVC];
        }
        else if (CellOperationType_GoComment == type)
        {
            NSURL *url = [UrlManager getRequestUrlByMethodName:[[self class] getRequestURLStr:NetNewsRequestType_AddOneComment]];
            
            [[CommentSendController sharedInstance] showCommentInputViewAndSendUrl:url
                                                                            newsId:entity.imageNewsId
                                                                    completeHandle:^(BOOL isSendSuccess) {
                                                                        
                                                                        [weakSelf showHUDInfoByString:isSendSuccess ? @"发送成功" : @"发送失败请重试"];
                                                                    }];
        }
        else if (CellOperationType_Share == type)
        {
            [weakSelf operationShareAction:sender];
        }
    }];
    
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

- (void)operationShareAction:(UIButton *)sender
{
    /*
     // 定义菜单分享列表
     NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeTwitter, ShareTypeFacebook, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeRenren, ShareTypeKaixin, ShareTypeSohuWeibo, ShareType163Weibo, nil];
     */
    
    // 创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"fen xiang"
                                       defaultContent:@""
                                                image:nil
                                                title:@"分享标题"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    // 创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    /*
     id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
     allowCallback:YES
     authViewStyle:SSAuthViewStyleFullScreenPopup
     viewDelegate:self
     authManagerViewDelegate:self];
     // 在授权页面中添加关注官方微博
     [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
     nil]];
     */
    
    /*
     id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
     shareViewDelegate:self];
     */
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享这条新闻"
                                                          oneKeyShareList:nil
                                                           qqButtonHidden:YES
                                                    wxSessionButtonHidden:YES
                                                   wxTimelineButtonHidden:YES
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:self
                                                      friendsViewDelegate:self
                                                    picViewerViewDelegate:self]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark - ISSShareViewDelegate methods

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    // 修改分享编辑框的标题栏颜色
    if (IOS7)
    {
        viewController.navigationController.navigationBar.barTintColor = Common_BlueColor;
    }
    else
    {
        viewController.navigationController.navigationBar.tintColor = Common_BlueColor;
    }
}

@end
