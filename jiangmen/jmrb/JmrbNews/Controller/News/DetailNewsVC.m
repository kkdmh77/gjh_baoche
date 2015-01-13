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
#import "CommentVC.h"
#import "ShareManager.h"

@interface DetailNewsVC () <UIWebViewDelegate>
{
    UIWebView *_webView;
    
    NSString *_newsTitleStr;
    NSString *_subTitleStr;
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
                    
                    strongSelf->_newsTitleStr = newsTitleStr;
                    strongSelf->_subTitleStr = subtitleStr;
                    
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
            commentVC.newsImageUrlStr = _newsImageUrlStr;
            commentVC.newsTitleStr = _newsTitleStr;
            commentVC.subTitleStr = _subTitleStr;
            commentVC.newsShareurlStr = _newsShareurlStr;
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
    [[ShareManager sharedInstance] shareNewsWithContent:_newsShareurlStr
                                                 NewsId:_newsId
                                            imageUrlStr:_newsImageUrlStr
                                                  title:_newsTitleStr
                                         showCollectBtn:[_newsImageUrlStr isAbsoluteValid] ? YES : NO
                                                 sender:sender];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
