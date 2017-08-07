//
//  BaseWebViewController.m
//  Sephome
//
//  Created by swift on 15/1/18.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "BaseWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface BaseWebViewController () <UIWebViewDelegate>
{
    UIWebView               *_webView;
    UIBarButtonItem         *_activityItem;
    
    WebViewJavascriptBridge *_bridge;
    NSURL                   *_url;
}

@end

@implementation BaseWebViewController

- (id)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        
        _url = url;
    }
    return self;
}

- (void)dealloc
{
    _webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:_navTitleStr];
}

- (void)setNetworkRequestStatusBlocks {
    
    WEAKSELF
    if (_isSelfRequest) {
        
        self.startedBlock = ^(NetRequest *request) {
            
            [weakSelf showHUDInfoByType:HUDInfoType_Loading];
        };
    }
}

- (void)getNetworkData
{
    if ([NetworkStatusManager isConnectNetwork]) {
        
        if (_isSelfRequest) {
            
            [[NetRequestManager sharedInstance] sendRequest:_url
                                               parameterDic:nil
                                                 requestTag:1000
                                                   delegate:self
                                                   userInfo:nil];
        } else {
            
            // 清空加载网络数据的背景图
            UIView *netBackgroundStatusImgView = [self valueForKey:@"netBackgroundStatusImgView"];
            if (netBackgroundStatusImgView) {
                
                [netBackgroundStatusImgView removeFromSuperview];
            }
            [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
        }
    } else {
        
        [self setNoNetworkConnectionStatusView];
    }
}

- (void)initialization
{
    if (_url)
    {
        _webView = InsertWebView(self.view, self.view.bounds, self, 1000);
        [_webView keepAutoresizingInFull];
        
        [self getNetworkData];
        
        [WebViewJavascriptBridge enableLogging];
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        [_bridge setWebViewDelegate:self];
        
        [_bridge registerHandler:@"productJSBack" handler:^(id data, WVJBResponseCallback responseCallback) {
            /*
             NSLog(@"testObjcCallback called: %@", data);
             responseCallback(@"Response from testObjcCallback");
             */
            /*
            NSNumber *productId = [data safeObjectForKey:@"productID"];
            
            ProductDetailVC *productDetail = [[ProductDetailVC alloc] initWithProductId:productId];
            [self pushViewController:productDetail];
             */
        }];
        
        // activityIndicatorView
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner startAnimating];
        _activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
}

- (UIWebView *)theWebView
{
    return _webView;
}

- (void)backViewController
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        [super backViewController];
    }
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
    if (!self.navigationItem.rightBarButtonItem)
    {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    [self webViewLoadFinish];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewLoadFinish];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequestDidStarted:(NetRequest *)request
{
    if (!self.navigationItem.rightBarButtonItem)
    {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    
    if (request.tag == 1000)
    {
        NSString *htmlStr = [infoObj safeObjectForKey:@"detail"];
        
        [_webView loadHTMLString:htmlStr baseURL:nil];
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    DLog(@"error = %@", error);
    
    [super netRequest:request failedWithError:error];
    
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

#pragma mark - tool methods

- (void)webViewLoadFinish {
    
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

@end
