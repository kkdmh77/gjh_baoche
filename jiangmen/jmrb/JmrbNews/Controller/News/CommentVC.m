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
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommentCell.h"
#import "AppPropertiesInitialize.h"
#import "ShareManager.h"

static NSString * const cellIdenfitier_comment = @"cellIdenfitier_comment";

@interface CommentVC ()
{
    NSMutableArray *_netCommentEntityArray;
}

@end

@implementation CommentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self dddd];
    [self initialization];
    [self getNetworkData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppPropertiesInitialize setKeyboardManagerEnable:NO];
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

- (void)dddd
{
    CommentEntity *entity = [[CommentEntity alloc] init];
    entity.criticsName = @"周杰伦";
    entity.commentContentStr = @"我的评论";
    
    CommentEntity *entity1 = [[CommentEntity alloc] init];
    entity1.criticsName = @"周杰伦";
    entity1.commentContentStr = @"我的评论我的评论我的评论我的评论我的评论我的评论我的评论我的评论";
    
    _netCommentEntityArray = [NSMutableArray arrayWithObjects:entity, entity1, nil];
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"江门日报"];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                                 normalImg:[UIImage imageNamed:@"fengxiang"]
                            highlightedImg:nil
                                    action:@selector(operationShareAction:)];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetNewsRequestType_GetCommentList == request.tag)
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
    NSDictionary *dic = @{@"newsId": @(_newsId)};
    
    [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetCommentList]
         parameterDic:dic
    requestMethodType:RequestMethodType_POST
           requestTag:NetNewsRequestType_GetCommentList];
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    return nil;
}

- (void)initialization
{
    const CGFloat space = 10;
    
    // 标题
    UILabel *titleLabel = InsertLabel(self.view, CGRectMake(space, space, self.viewBoundsWidth - space * 2, 0), NSTextAlignmentLeft, _newsTitleStr, SP18Font, Common_BlackColor, YES);
    UILabel *subTitleLabel = InsertLabel(self.view, CGRectMake(space, CGRectGetMaxY(titleLabel.frame) + space, self.viewBoundsWidth - space * 2, 0), NSTextAlignmentLeft, _subTitleStr, SP12Font, Common_LiteGrayColor, YES);
    UIView *lineView = InsertView(self.view, CGRectMake(space, CGRectGetMaxY(subTitleLabel.frame) + space, self.viewBoundsWidth - space * 2, 1));
    lineView.backgroundColor = CellSeparatorColor;
    
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
            NSURL *url = [UrlManager getRequestUrlByMethodName:[[self class] getRequestURLStr:NetNewsRequestType_AddOneComment]];
            
            [[CommentSendController sharedInstance] showCommentInputViewAndSendUrl:url
                                                                            newsId:_newsId
                                                                    completeHandle:^(BOOL isSendSuccess) {
                                                                        
                                                                        [weakSelf showHUDInfoByString:isSendSuccess ? @"发送成功" : @"发送失败请重试"];
                                                                    }];
        }
        else
        {
            [weakSelf backViewController];
        }
    }];
    [self.view addSubview:comment];
    
    // tab
    [self setupTableViewWithFrame:CGRectMake(space, CGRectGetMaxY(lineView.frame) + space, self.viewBoundsWidth - space * 2, self.view.boundsHeight - comment.boundsHeight - CGRectGetMaxY(lineView.frame) - space)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([CommentCell class])
                  reuseIdentifier:cellIdenfitier_comment];
}

- (void)operationShareAction:(UIButton *)sender
{
    [[ShareManager sharedInstance] shareNewsWithContent:_newsShareurlStr
                                                 NewsId:_newsId
                                            imageUrlStr:_newsImageUrlStr
                                                  title:_newsTitleStr
                                         showCollectBtn:[_newsImageUrlStr isAbsoluteValid] ? YES : NO
                                                 sender:sender];
}

- (void)reloadTableData
{
    [_tableView reloadData];
}

- (CommentEntity *)curShowDataAtIndex:(NSInteger)index
{
    return index < _netCommentEntityArray.count ? _netCommentEntityArray[index] : nil;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netCommentEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell getCellHeihgtWithItemEntity:[self curShowDataAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfitier_comment];
    
    CommentEntity *entity = [self curShowDataAtIndex:indexPath.row];;
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
