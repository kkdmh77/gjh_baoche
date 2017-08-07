//
//  BaseNetworkViewController.m
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import <NerdyUI.h>
#import "GCDThread.h"

#define kStatusBarHeight 20.f

@interface BaseNetworkViewController ()<PDRCoreDelegate,PDRCoreAppWindowDelegate>
{
    __weak UIView      *netStatusBackgroundView;
    UIView *_containerView;
    
    PDRCoreApp* pAppHandle;
    UIStatusBarStyle _statusBarStyle;
    BOOL _isFullScreen;
    UIView *_statusBarView;
}

@end

@implementation BaseNetworkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 该地方一定要注意block引起的retain cycle
        __weak BaseNetworkViewController *weakSelf = self;
        
        self.noNetworkBlock = ^{
            
            BaseNetworkViewController *strongSelf = weakSelf;
            if (strongSelf)
            {
                // 给主view赋值状态背景图(无网络连接)
                [strongSelf setNoNetworkConnectionStatusView];
            }
        };
        
        self.startedBlock = ^(NetRequest *request)
        {
            [weakSelf showHUDInfoByType:HUDInfoType_Loading];
        };
        
        [self setDefaultNetFailedBlock];
        
        // 分页相关参数
        _page = 1;
        _pageSize = 20;
    }
    return self;
}

- (void)dealloc
{
    [self clearDelegate];
    /*
    // 自动的登录相关
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didLoginSuccessNotificationKey object:nil];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置网络请求中每个阶段需要执行的代码块
    [self setNetworkRequestStatusBlocks];
    /*
    // 请求网络数据
    [self getNetworkData];
     */
    /*
    // 自动的登录相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginSuccessAction) name:didLoginSuccessNotificationKey object:nil];
     */
}

// 有的类需要登录后才能请求服务器数据(此方法会在自动弹出登录界面并且登录成功后调用以再次发起推出登录界面控制器的网络请求)
- (void)didLoginSuccessAction
{
    [self getNetworkData];
}

#pragma mark - 设置网络背景状态图

// 设置网络背景状态图
- (void)setNetworkStatusViewByImage:(UIImage *)image userInteractionEnabled:(BOOL)yesOrNo
{
    [self setNetworkStatusViewByImage:image
                           remindText:nil
               userInteractionEnabled:yesOrNo];
}

- (void)setNetworkStatusViewByImage:(UIImage *)image remindText:(NSString *)text userInteractionEnabled:(BOOL)yesOrNo
{
    [self setNetworkStatusViewWithFrame:self.view.bounds
                                  Image:image
                             remindText:text
                 userInteractionEnabled:yesOrNo];
}

- (void)setNetworkStatusViewWithFrame:(CGRect)frame Image:(UIImage *)image remindText:(NSString *)text userInteractionEnabled:(BOOL)yesOrNo
{
    if (netStatusBackgroundView.superview) {
        [netStatusBackgroundView removeGestureWithTarget:self
                                               andAction:@selector(getNetworkData)];
        [netStatusBackgroundView removeFromSuperview];
    }
    
    netStatusBackgroundView = View.xywh(frame).bgColor(self.view.backgroundColor).addTo(self.view);
    [netStatusBackgroundView keepAutoresizingInFull];
    
    UIImageView *imageView = ImageView.img(image).fitSize.addTo(netStatusBackgroundView).makeCons(^{
        make.top.equal.superview.constants(50).And.centerX.equal.superview.constants(0);
    });
    
    Label.str(text).fnt(SP15Font).color([UIColor grayColor]).centerAlignment.preferWidth(netStatusBackgroundView.width - 10 * 2).multiline.addTo(netStatusBackgroundView).makeCons(^{
        make.top.equal.view(imageView).bottom.constants(15).And.centerX.equal.view(imageView);
    });
    
    if (yesOrNo && [self respondsToSelector:@selector(getNetworkData)])
    {
        netStatusBackgroundView.userInteractionEnabled = yesOrNo;
        [netStatusBackgroundView addTarget:self action:@selector(getNetworkData)];
    }
}

- (void)setNoDataSourceStatusView
{
    [self setNoDataSourceStatusViewWithRemindText:@"亲,还没有内容哦!"];
}

- (void)setNoDataSourceStatusViewWithRemindText:(NSString *)remindText
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"gwc_kkry"]
                           remindText:remindText
               userInteractionEnabled:NO];
}

- (void)setNoNetworkConnectionStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"Unify_Image_w51"]
                           remindText:NoConnectionNetwork
               userInteractionEnabled:YES];
}

- (void)setLoadFailureStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"net_status_lost"]
                           remindText:LoadFailed
               userInteractionEnabled:YES];
}

#pragma mark - 分页请求属性设置

- (void)setPagingSuccessActionWithResultCount:(NSInteger)resultCount
{
    ++_page;
    _isRequesting = NO;
    
    // 改变tab底部刷新视图的显示
    if (resultCount < _pageSize)
    {
        _nextPageHasData = NO;
        [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_NoMoreData];
    }
    else
    {
        _nextPageHasData = YES;
        [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_Loading];
    }
}

- (void)setPagingFailedActionWithRequest:(NetRequest *)request error:(NSError *)error
{
    [self showHUDInfoByString:error.localizedDescription];
    _isRequesting = NO;
    
    // 第一页请求
    if (_page == 1)
    {
        [self setDefaultNetFailedBlockImplementationWithNetRequest:request
                                                             error:error
                                             isAddFailedActionView:YES
                                                       isAutoLogin:YES
                                                 otherExecuteBlock:nil];
    }
    else
    {
        if (MyHTTPCodeType_DataSourceNotFound == error.code)
        {
            _nextPageHasData = NO;
            [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_NoMoreData];
        }
        else
        {
            _nextPageHasData = YES;
            [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_Loading];
        }
    }
}

#pragma mark - 设置代码块

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock
{
    [self setNetSuccessBlock:successBlock failedBlock:self.failedBlock];
}

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:self.noNetworkBlock SuccessBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock SuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:self.startedBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:startedBlock progressBlock:self.progressBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock progressBlock:(ExtendVCNetRequestProgressBlock)progressBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    self.noNetworkBlock = noNetworkBlock;
    self.startedBlock = startedBlock;
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
}

#pragma mark - 发送网络请求

- (void)clearDelegate
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

- (void)setNetworkRequestStatusBlocks
{
    // 子类实现,需在getNetworkData方法前调用
//    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
}

// 设置默认的失败后执行的代码块
- (void)setDefaultNetFailedBlock;
{
    WEAKSELF
    self.failedBlock = ^(NetRequest *request, NSError *error)
    {
        [weakSelf setDefaultNetFailedBlockImplementationWithNetRequest:request error:error otherExecuteBlock:nil];
    };
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error otherExecuteBlock:(void (^)(void))otherBlock
{
    [self setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:YES otherExecuteBlock:otherBlock];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView otherExecuteBlock:(void (^)(void))otherBlock
{
    [self setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:isAddActionView isAutoLogin:YES otherExecuteBlock:otherBlock];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView isAutoLogin:(BOOL)isAutoLogin otherExecuteBlock:(void (^)(void))otherBlock
{
    // 无数据
    if (error.code == MyHTTPCodeType_DataSourceNotFound)
    {
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:[LanguagesManager getStr:All_DataSourceNotFoundKey]];
        }
        
        // 没数据时的状态图
        if (isAddActionView)
        {
            [self setNoDataSourceStatusView];
        }
    }
    // 未登录或登录过期
    else if (error.code == MyHTTPCodeType_TokenIllegal ||
             error.code == MyHTTPCodeType_TokenIncomplete ||
             error.code == MyHTTPCodeType_TokenOverdue)
    {
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:@""];
        }
        
        if (isAutoLogin)
        {
            // 自动跳入登录页面
            /*
             LoginAndRegisterVC *login = [LoginAndRegisterVC loadFromNib];
             UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
             [self presentViewController:loginNav
             modalTransitionStyle:UIModalTransitionStyleCoverVertical
             completion:^{
             
             }];
             */
        }
    }
    else
    {
        /*
         [weakSelf showHUDInfoByType:HUDInfoType_Failed];
         */
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:OperationFailure];
        }
        
        // 设置主view的状态背景图(点击重新刷新的图)
        if (isAddActionView)
        {
            [self setLoadFailureStatusView];
        }
    }
    
    if (otherBlock)
    {
        otherBlock();
    }
}

- (void)getNetworkData
{
    // do nothing
//    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
}

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag
{
    return [self sendRequest:urlMethodName parameterDic:parameterDic requestMethodType:RequestMethodType_GET requestTag:tag];
}

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    return [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag];
}

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    return [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    发送必须带header的请求(如果没有登录,header就会为nil,那么就会自动跳转到登录页面)
 @ 创建人      龚俊慧
 @ 创建时间    2014-10-21
 */
- (NetRequest *)sendMustWithTokenHeadersRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    // 待实现...
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate
{
    return [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil];
}

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    return [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo netCachePolicy:NetNotCachePolicy cacheSeconds:0.0];
}

- (NetRequest *)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds
{
    if (![NetworkStatusManager isConnectNetwork] && NetNotCachePolicy == cachePolicy)
    {
        // 执行没有网络连接的代码块
        if (self.noNetworkBlock)
        {
            self.noNetworkBlock();
        }
        
        [self showHUDInfoByType:HUDInfoType_NoConnectionNetwork];
        
        return nil;
    }
    
    NSURL *url = nil;
    BOOL isGETRequest = [methodType isEqualToString:RequestMethodType_GET]; // 是否为GET方式的请求
    
    if (isGETRequest)
    {
        url = [UrlManager getRequestUrlByMethodName:urlMethodName andArgsDic:parameterDic];
    }
    else
    {
        url = [UrlManager getRequestUrlByMethodName:urlMethodName];
    }
    
    return [[NetRequestManager sharedInstance] sendRequest:url parameterDic:!isGETRequest ? parameterDic : nil requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo netCachePolicy:cachePolicy cacheSeconds:cacheSeconds];
}

#pragma mark - NetRequestDelegate Methods

- (void)netRequestDidStarted:(NetRequest *)request
{
    if (self.startedBlock)
    {
       self.startedBlock(request);
    }
}

- (void)netRequest:(NetRequest *)request setProgress:(float)newProgress
{
    if (self.progressBlock)
    {
        self.progressBlock(request, newProgress);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [self hideHUD];
    [self hideHUDInView:self.view];
    
    // 清空加载网络数据的背景图
    if (netStatusBackgroundView.superview)
    {
        [netStatusBackgroundView removeFromSuperview];
    }
    
    if (self.successBlock)
    {
        self.successBlock(request, infoObj);
    }
    
    // [self parserNetworkData:infoObj request:request];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [self hideHUD];
    [self hideHUDInView:self.view];
    
    if (self.failedBlock)
    {
        self.failedBlock(request, error);
    }
}

/*
#pragma  mark - 数据解析

- (void)parserNetworkData:(id)data request:(NetRequest *)request
{
    // do nothing
}
 */

////////////////////////////////////////////////////////////////////////////////

- (BOOL)reserveStatusbarOffset {
    return [PDRCore Instance].settings.reserveStatusbarOffset;
}

// 修改状态栏风格
-(UIStatusBarStyle)getStatusBarStyle {
    return [self preferredStatusBarStyle];
}
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if ( _statusBarStyle != statusBarStyle ) {
        _statusBarStyle = statusBarStyle;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

- (void)reloadPDRCoreAppFrameUrl:(NSString *)urlStr {
    self.loadUrlStr = urlStr;
    
    [self setupPDRUI];
}

- (void)setupPDRUI {
    // normal
    /*
    PDRCore *h5Engine = [PDRCore Instance];
    
    CGRect newRect = self.view.bounds;
    _containerView = [[UIView alloc] initWithFrame:newRect];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];
    
    h5Engine.coreDeleagete = self;
    [h5Engine setContainerView:_containerView];
    h5Engine.persentViewController = self;
    [h5Engine showLoadingPage];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[PDRCore Instance] start];
    });
    
    // 单页面集成时可以设置打开的页面是本地文件或者是网络路径
    NSString *pFilePath = [self.loadUrlStr isValidString] ? self.loadUrlStr : @"http://120.76.188.84:8085/plugin/testAppNAV.html";
    pFilePath = @"http://m.vavic.cn/H5";
    */
    
    
    
    
    
    // webapp
    /*
    PDRCore *h5Engine = [PDRCore Instance];
    [self setStatusBarStyle:h5Engine.settings.statusBarStyle];
    // 获取当前是否是全屏
    _isFullScreen = [UIApplication sharedApplication].statusBarHidden;
    if ( _isFullScreen != h5Engine.settings.fullScreen ) {
        _isFullScreen = h5Engine.settings.fullScreen;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen];
        }
    }
    
    CGRect newRect = self.view.bounds;
    if ( [self reserveStatusbarOffset] && [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series) {
        if ( !_isFullScreen ) {
            newRect.origin.y += kStatusBarHeight;
            newRect.size.height -= kStatusBarHeight;
        }
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newRect.size.width, kStatusBarHeight+1)];
        _statusBarView.backgroundColor = h5Engine.settings.statusBarColor;
        _statusBarView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_statusBarView];
    }
    _containerView = [[UIView alloc] initWithFrame:newRect];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // 设置5+内核的Delegate，5+API在修改状态风格和应用是否全屏时会调用
    h5Engine.coreDeleagete = self;
    h5Engine.persentViewController = self;
    
    [self.view addSubview:_containerView];
    
    
    // 设置WebApp所在的目录，该目录下必须有mainfest.json
    NSString* pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora/apps/MuBan/www"];
    
    // 如果路径中包含中文，或Xcode工程的targets名为中文则需要对路径进行编码
    //NSString* pWWWPath2 =  (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)pTempString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    // 用户在集成5+SDK时，需要在5+内核初始化时设置当前的集成方式，
    // 请参考AppDelegate.m文件的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法
    
    // 设置5+SDK运行的View
    [[PDRCore Instance] setContainerView:_containerView];
    
    // 传入参数可以在页面中通过plus.runtime.arguments参数获取
    NSString* pArgus = @"id=plus.runtime.arguments";
    // 启动该应用
    pAppHandle = [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath withIndexPath:@"index.html" withArgs:pArgus withDelegate:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://m.vavic.cn/H5"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    H5WEWebEngine *h5WE = [[[[[PDRCore Instance] appManager] activeApp] mainFrame] webEngine];
    [h5WE loadRequest:request];
    
    // 如果应用可能会重复打开的话建议使用restart方法
    //[[[PDRCore Instance] appManager] restart:pAppHandle];
    */
    
    
    
    
    // webview
    /*
     http://120.76.188.84:8085/plugin/testAppNAV.html
     http://120.76.188.84:8085/plugin/testAppUI.html
     http://120.76.188.84:8085/plugin/testAppUTIL.html
     */
    
    if (self.appFrame) {
        [self.appFrame removeFromSuperview];
        self.appFrame = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    PDRCore *pCoreHandle = [PDRCore Instance];
    
    [pCoreHandle regPluginWithName:@"appNAV"
                      impClassName:@"ProductPlugin"
                              type:PDRExendPluginTypeFrame
                        javaScript:nil];
    [pCoreHandle regPluginWithName:@"appUI"
                      impClassName:@"ProductPlugin"
                              type:PDRExendPluginTypeFrame
                        javaScript:nil];
    [pCoreHandle regPluginWithName:@"appUTIL"
                      impClassName:@"ProductPlugin"
                              type:PDRExendPluginTypeFrame
                        javaScript:nil];

    [pCoreHandle regPluginWithName:@"barcode"
                      impClassName:@"PGBarcode"
                              type:PDRExendPluginTypeFrame
                        javaScript:nil];
    
    
    if (pCoreHandle != nil) {
        // NSString* pFilePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath, @"Pandora/apps/MuBan/www/plugin.html"];
        [pCoreHandle start];
        // 如果路径中包含中文，或Xcode工程的targets名为中文则需要对路径进行编码
        //NSString* pFilePath =  (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)pTempString, NULL, NULL,  kCFStringEncodingUTF8 );
        
        // 单页面集成时可以设置打开的页面是本地文件或者是网络路径
        NSString *pFilePath = [self.loadUrlStr isValidString] ? self.loadUrlStr : @"http://120.76.188.84:8085/plugin/testAppNAV.html";
        // pFilePath = @"http://m.vavic.cn/H5";
        
        // 用户在集成5+SDK时，需要在5+内核初始化时设置当前的集成方式，
        // 请参考AppDelegate.m文件的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法
        
        CGRect StRect = CGRectMake(0, 20, self.view.width, Screen.height - 64);
        
        self.appFrame = [[PDRCoreAppFrame alloc] initWithName:@"WebViewID1" loadURL:pFilePath frame:StRect];
        if (self.appFrame) {
            [pCoreHandle.appManager.activeApp.appWindow registerFrame:self.appFrame];
            
            [self.view addSubview:self.appFrame];
            // [self.scrollView addSubview:self.appFrame];
            // [self.appFrame keepAutoresizingInFull];
            
            // 注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(pageDidLoad:)
                                                         name:PDRCoreAppFrameDidLoadNotificationKey
                                                       object:nil];
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView keepAutoresizingInFull];
        _scrollView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)pageDidLoadAction {
    /*
     NSString *evalString = @"initAppUI();";
     
     [self.appFrame evaluateJavaScript:evalString completionHandler:^(id obj, NSError *error) {
     
     }];
     */
}

#pragma mark - Notifications Methods

// 页面加载完成
- (void)pageDidLoad:(NSNotification *)notification {
    if (self.appFrame) {
        @weakify(self);
        [GCDThread enqueueBackgroundWithDelay:1 block:^{
            [weak_self performSelectorOnMainThread:@selector(pageDidLoadAction)
                                        withObject:nil
                                     waitUntilDone:YES];
        }];
    }
}



#pragma mark 处理屏幕旋转
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:toInterfaceOrientation]];
    if ([PTDeviceOSInfo systemVersion] >= PTSystemVersion8Series) {
        [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen ];
    }
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[PDRCore Instance].settings supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( [PDRCore Instance].settings ) {
        return [[PDRCore Instance].settings supportsOrientation:interfaceOrientation];
    }
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(BOOL)getStatusBarHidden {
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        return _isFullScreen;
    }
    return [UIApplication sharedApplication].statusBarHidden;
}

#pragma mark  StatusBarStyle


#pragma mark -


#pragma mark - StatusBarBackground iOS >=7.0
-(UIColor*)getStatusBarBackground {
    return _statusBarView.backgroundColor;
}

-(void)setStatusBarBackground:(UIColor*)newColor
{
    if ( newColor ) {
        _statusBarView.backgroundColor = newColor;
    }
}
#pragma mark DelegateFunction
// 切换当前Web应用是否是全屏显示
-(void)wantsFullScreen:(BOOL)fullScreen
{
    if ( _isFullScreen == fullScreen ) {
        return;
    }
    
    _isFullScreen = fullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen withAnimation:_isFullScreen?NO:YES];
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    CGRect newRect = self.view.bounds;
    if ( [PTDeviceOSInfo systemVersion] <= PTSystemVersion6Series ) {
        newRect = [UIApplication sharedApplication].keyWindow.bounds;
        if ( _isFullScreen ) {
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        } else {
            UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if ( UIDeviceOrientationLandscapeLeft == interfaceOrientation
                || interfaceOrientation == UIDeviceOrientationLandscapeRight ) {
                newRect.size.width -=kStatusBarHeight;
            } else {
                newRect.origin.y += kStatusBarHeight;
                newRect.size.height -=kStatusBarHeight;
            }
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        }
        
    } else {
        if ( [self reserveStatusbarOffset] ) {
            _statusBarView.hidden = _isFullScreen;
            if ( !_isFullScreen ) {
                newRect.origin.y += kStatusBarHeight;
                newRect.size.height -= kStatusBarHeight;
            }
        }
        _containerView.frame = newRect;
    }
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:0]];
}

- (void)didReceiveMemoryWarning{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventReceiveMemoryWarning withObject:nil];
}

@end
