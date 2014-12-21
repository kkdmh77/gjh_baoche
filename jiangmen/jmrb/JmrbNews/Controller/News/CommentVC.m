//
//  CommentVC.m
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import "CommentVC.h"
#import "CommentView.h"
#import "CommentSendController.h"

@interface CommentVC ()

@end

@implementation CommentVC

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
    [self setNavigationItemTitle:@"江门日报"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        
        
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
    /*
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
     */
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    return nil;
}

- (void)initialization
{
    WEAKSELF
    // 评论输入框
    CommentView *comment = [CommentView loadFromNib];
    comment.boundsWidth = self.viewBoundsWidth;
    comment.origin = CGPointMake(0, self.view.boundsHeight - comment.boundsHeight);
    comment.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [comment setRightBtnTitle:@"原文"];
    [comment setOperationHandle:^(CommentView *view, CommentViewOperationType type) {
        
        if (CommentViewOperationType_Input == type)
        {
            [[CommentSendController sharedInstance] showCommentInputViewAndSendUrl:nil
                                                                    completeHandle:^(BOOL isSendSuccess) {
                                                                        
                                                                    }];
        }
        else
        {
            [weakSelf backViewController];
        }
    }];
    [self.view addSubview:comment];
    
    // tab
//    [self setupTableViewWithFrame:self.view.bounds
//                            style:UITableViewStylePlain
//                  registerNibName:NSStringFromClass([VideoNewsCell class])
//                  reuseIdentifier:cellIdentifer_videoNews];
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
    /*
    VideoNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer_videoNews];
    
    VideoNewsEntity *entity = _netVideoNewsEntityArray[indexPath.row];
    [cell loadCellShowDataWithItemEntity:entity];
     */
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
