//
//  DetailNewsVC.m
//  JmrbNews
//
//  Created by swift on 14/12/5.
//
//

#import "DetailNewsVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommentSendController.h"
#import "AppPropertiesInitialize.h"
#import "CommentView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSShareViewDelegate.h>
#import <ShareSDK/ISSViewDelegate.h>
#import "CommentVC.h"

@interface DetailNewsVC () <UIWebViewDelegate, ISSShareViewDelegate, ISSViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation DetailNewsVC

int webTextFontValue = 15;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)setPageLocalizableText
{
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                            barButtonTitle:@"分享"
                                    action:@selector(operationShareAction:)];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        STRONGSELF
        if ([successInfoObj isSafeObject])
        {
            NSArray *newsDataList = [[successInfoObj objectForKey:@"response"] objectForKey:@"item"];
            
            if ([newsDataList isAbsoluteValid])
            {
                NSDictionary *newsDic = newsDataList[0];
                
                NSString *bodyString = [newsDic objectForKey:@"newsContent"];
                
                if ([bodyString isKindOfClass:[NSString class]])
                {
                    NSString *htmlString = nil;
                    NSString *newsTitleStr = [newsDic objectForKey:@"newsTitle"];           // 标题
                    NSString *newsFromStr = [newsDic objectForKey:@"newsSfrom"];            // 来源
                    NSString *newsCreatTimeStr = [newsDic objectForKey:@"newsCreatetime"];  // 创建时间
                    NSString *newsCommentCountStr = [NSString stringWithFormat:@"%@评论",newsDic[@"commCount"]];  // 评论数
                    NSString *subtitleStr = [NSString stringWithFormat:@"%@ %@ %@",newsFromStr, newsCreatTimeStr, newsCommentCountStr];
                    
                    NSString *imageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:[newsDic objectForKey:@"newsSpicture"]];                                         // 图片URL
                    NSString *videoUrl = [newsDic objectForKey:@"newsVideoUrl"];                // 视频地址
                    NSInteger newsType = [[newsDic objectForKey:@"newsClassify"] integerValue]; // 新闻类型
                    
                    /*
                    CGFloat imageWidth = strongSelf->_webView.boundsWidth - 10 * 2;
                    CGFloat imageHeight = imageWidth * .67;
                     */
                    
                    NSString *headerHTML = [NSString stringWithFormat:@"<p style=\"color: black; margin-left: 10px; margin-top: 20; margin-bottom: 0; font-size: 20px; line-height: 20px\"> %@ </p> \n <p style=\"color: black; margin-left: 10px; margin-top: 20; margin-bottom: 15; font-size: 10px; line-height: 10px\"> %@ </p> \n <hr noshade color=\"#DFDEDF\"; size=1>",newsTitleStr, subtitleStr];
                    
                    if(newsType == 2 && videoUrl != nil && videoUrl.length > 10)
                    {
                        NSString *embedHTML = [NSString stringWithFormat:@"<video poster=\"%@\" autobuffer=\"autobuffer\" loop=\"loop\" style=\"width: 100%%; border: none; margin: auto; display: block\">\
                                               <source src=\"%@\" type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'>\
                                               </video>", imageUrlStr, videoUrl];
                        
                        htmlString = [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@\n%@\n%@</body> \n </html>", webTextFontValue, webTextFontValue + 10, headerHTML, embedHTML, bodyString];
                    }
                    else
                    {
                        NSString *imageHTML = @"";
                        
                        if ([imageUrlStr isAbsoluteValid])
                        {
                            imageHTML = [NSString stringWithFormat:@"<img src=\"%@\" style=\"width: 100%%; border: none; margin: auto; display: block\">",imageUrlStr];
                        }
                        
                        htmlString = [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@\n%@\n%@</body> \n </html>", webTextFontValue, webTextFontValue + 10, headerHTML, imageHTML, bodyString];
                        
                    }
                    
                    [strongSelf initializationWithHtmlString:htmlString andCommentCountStr:newsCommentCountStr];
                }
            }
        }
    }];
}

- (void)getNetworkData
{
    if (_newsId)
    {
        [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetNewsDeatil]
             parameterDic:@{@"newsId":@(_newsId)}
               requestTag:NetNewsRequestType_GetNewsDeatil];
    }
}

- (void)initializationWithHtmlString:(NSString *)htmlStr andCommentCountStr:(NSString *)commentCountStr
{
    WEAKSELF
    // 评论输入框
    CommentView *comment = [CommentView loadFromNib];
    comment.boundsWidth = self.viewBoundsWidth;
    comment.origin = CGPointMake(0, self.view.boundsHeight - comment.boundsHeight);
    comment.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [comment setRightBtnTitle:commentCountStr];
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
            CommentVC *commentVC = [[CommentVC alloc] init];
            commentVC.newsId = weakSelf.newsId;
            [weakSelf pushViewController:commentVC];
        }
    }];
    [self.view addSubview:comment];
    
    // webView
    _webView = InsertWebView(self.view, CGRectDecreaseSize(self.view.bounds, 0, comment.boundsHeight), self, 1000);
    [_webView loadHTMLString:htmlStr baseURL:nil];
    [_webView keepAutoresizingInFull];
}

- (void)operationSendCommentGesture:(UITapGestureRecognizer *)gesture
{
    
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

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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
