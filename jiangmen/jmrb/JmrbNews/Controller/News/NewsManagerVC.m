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

@interface NewsManagerVC () <SUNSlideSwitchViewDelegate>
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
           requestTag:NetNewsRequestType_GetAllNewsType];
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
    self.title = @"滑动切换视图";
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
        
        [_newsViewControllersArray addObject:newsVC];
    }
    
    [self.slideSwitchView buildUI];
    
    self.navigationItem.titleView = _slideSwitchView.topScrollView;
    self.navigationItem.leftBarButtonItem = nil;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right normalImg:[UIImage imageNamed:@"jiahao"] highlightedImg:nil action:NULL];
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

@end
