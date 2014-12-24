//
//  NewsManagerVC.m
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "NewsManagerVC.h"
#import "NewsVC.h"
#import "CommonEntity.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "LXActivity.h"
#import "SettingVC.h"
#import "LoginVC.h"
#import "MyMessageVC.h"

@interface NewsManagerVC () <SUNSlideSwitchViewDelegate, LXActivityDelegate>
{
    NSMutableArray *_netNewsTypeEntityArray;
    
    NSMutableArray *_newsViewControllersArray;
}

@end

@implementation NewsManagerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetNewsRequestType_GetAllNewsType == request.tag)
        {
            [strongSelf parseNetDataWithDic:successInfoObj];
            
            [strongSelf initialization];
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetAllNewsType]
         parameterDic:nil
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetNewsRequestType_GetAllNewsType
             delegate:self
             userInfo:nil
       netCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy
         cacheSeconds:CacheNetDataTimeType_OneDay];
    ;
}

- (void)parseNetDataWithDic:(NSDictionary *)dic
{
    NSArray *newsTypeItemList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
    if ([newsTypeItemList isAbsoluteValid])
    {
        _netNewsTypeEntityArray = [NSMutableArray arrayWithCapacity:newsTypeItemList.count];
        
        for (NSDictionary *newsTypeItemDic in newsTypeItemList)
        {
            NewsTypeEntity *entity = [NewsTypeEntity initWithDict:newsTypeItemDic];
            [_netNewsTypeEntityArray addObject:entity];
        }
    }
}

- (void)initialization
{
    self.slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [_slideSwitchView keepAutoresizingInFull];
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.tabItemNormalColor = HEXCOLOR(0X636363);
    _slideSwitchView.tabItemSelectedColor = HEXCOLOR(0X005BA5);
    _slideSwitchView.shadowImage = [UIImage imageWithColor:HEXCOLOR(0XE0E0E0) size:CGSizeMake(1, 1)];
    [self.view addSubview:_slideSwitchView];
    
    // 控制器
    _newsViewControllersArray = [NSMutableArray arrayWithCapacity:_netNewsTypeEntityArray.count];
    for (NewsTypeEntity *entity in _netNewsTypeEntityArray)
    {
        NewsVC *newsVC = [[NewsVC alloc] init];
        newsVC.newsTypeEntity = entity;
        
        [self addChildViewController:newsVC];
        [_newsViewControllersArray addObject:newsVC];
    }
    
    [self.slideSwitchView buildUI];
    
    self.navigationItem.titleView = _slideSwitchView.topScrollView;
    self.navigationItem.leftBarButtonItem = nil;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                                 normalImg:[UIImage imageNamed:@"jiahao"]
                            highlightedImg:nil
                                    action:@selector(operationMoreAction:)];
}

- (void)operationMoreAction:(UIButton *)sender
{
    LXActivity *action = [[LXActivity alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         ShareButtonTitles:@[@"频道定制",
                                                             @"个人中心",
                                                             @"我的消息",
                                                             @"设置"]
                                 withShareButtonImagesName:@[@"pingdaodingzhi_normal",
                                                             @"gerenzhongxing_normal",
                                                             @"wodexiaoxi_normal",
                                                             @"shezhi_normal"]];
    [action showInView:self.view];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return _newsViewControllersArray.count;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return _newsViewControllersArray[number];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NewsVC *newsVC = _newsViewControllersArray[number];
    
    [newsVC viewDidCurrentView];
}

#pragma mark - LXActivityDelegate methods

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    switch (imageIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            LoginVC *login = [LoginVC loadFromNib];
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:loginNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
        case 2:
        {
            MyMessageVC *myMessage = [MyMessageVC new];
            UINavigationController *myMessageNav = [[UINavigationController alloc] initWithRootViewController:myMessage];
            [self presentViewController:myMessageNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
        case 3:
        {
            SettingVC *setting = [[SettingVC alloc] init];
            UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:setting];
            [self presentViewController:settingNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
