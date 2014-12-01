//
//  MainPageFirstNewsListVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define BtnTag  3000
#define ImageViewTag 6000

#import "MainPageFirstNewsListVC.h"
#import "ZSSourceModel.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"

@interface MainPageFirstNewsListVC ()

- (void)refreshNewList;
- (void)setisNeedLoadNextNo;
- (void)refreshAdsData;
- (void)clickPicture;
- (void)connectWebToRefreshAds;

@end

@implementation MainPageFirstNewsListVC
@synthesize delegate;
@synthesize newsTableView;
@synthesize newsCell;
@synthesize adsScrollView;
@synthesize showAllScrollView;
@synthesize newsAdsTitle;
@synthesize pageControl;

#pragma mark System
- (void)dealloc {
    [topView release];
    [tailView release];
    [newsArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewList) name:notification_getNewsList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAdsData) name:notification_getAds object:nil];
    
    isNeedReload = NO;
    scrollIsNeedLoadNext = NO;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    [newsTableView setScrollEnabled:NO];
    [showAllScrollView setDelegate:self];
    [adsScrollView setDelegate:self];
    isNeedLoadNext = YES;
    
    //[adsScrollView setFrame:CGRectMake(0, 0, 320, 160)];
    if (iPhone5) {
        [showAllScrollView setFrame:CGRectMake(0, 70, 320, 448)];
    }
    
    newsTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];

    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 135, 320, 25)];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:.4];
    [self.showAllScrollView addSubview:view];
    [view release];
    
    topView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    [topView.view setCenter:CGPointMake(160, -topView.view.frame.size.height/2 - 5)];
    [self.showAllScrollView addSubview:topView.view];
    tailView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - showAllScrollView.bounds.size.height, self.view.frame.size.width, showAllScrollView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[showAllScrollView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setRefreshFooterView];
    
    [self.showAllScrollView addSubview:newsAdsTitle];
    [self.showAllScrollView addSubview:pageControl];
    [pageControl setHidden:YES];
    [self refreshAdsData];
    
    UISwipeGestureRecognizer *swipGestureNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickNextNews)];
    [swipGestureNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipGestureNext];
    [swipGestureNext release];
}


- (void)clickNextNews{
    
    
    NSLog(@"adfjiejajdfjsdf");
    
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListChange)]) {
        [delegate MainPageFirstNewsListChange];
    }
    
}


-(void)setRefreshFooterView
{
    CGFloat height = MAX(showAllScrollView.contentSize.height, showAllScrollView.frame.size.height);
    if (_loadMoreView && [_loadMoreView superview]) {
        // reset position
        _loadMoreView.frame = CGRectMake(0.0f,
                                         height,
                                         showAllScrollView.frame.size.width,
                                         self.view.bounds.size.height);
    }else {
        // create the footerView
        _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height,showAllScrollView.frame.size.width, self.view.bounds.size.height)];
        _loadMoreView.delegate = self;
        [showAllScrollView addSubview:_loadMoreView];
    }
}

#pragma mark - Public
- (void)setisNeedLoadNextYes {
    isNeedLoadNext = YES;
}
- (void)loadNewsList:(NSInteger)typeId {
    NSMutableDictionary *dic = nil;
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if (allDic == nil) {
        dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:Web_getNewsType forKey:Web_Key_urlString];
        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
        [dic release];
    }
    else {
        NSDictionary *responseDic = [allDic objectForKey:@"response"];
        NSArray *itemArray = [responseDic objectForKey:@"item"];
        if (itemArray == nil || [itemArray count] == 0) {
            dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dic setObject:Web_getNewsType forKey:Web_Key_urlString];
            [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
            [dic release];
        }
        else {
            nowNewStyle = typeId;
            dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dic setObject:Web_getNewsList forKey:Web_Key_urlString];
            [dic setObject:[NSString stringWithFormat:@"%i", typeId] forKey:Key_News_List_Id_Number];
            //[dic setObject:@"1" forKey:Key_News_List_NoPic];
            [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
            [dic release];
        }
    }
}

#pragma mark - Private
- (void)connectWebToRefreshAds {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getAds forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];    
    
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if (allDic == nil) {
        dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:Web_getNewsType forKey:Web_Key_urlString];
        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
        [dic release];
    }
    else {
        NSDictionary *responseDic = [allDic objectForKey:@"response"];
        NSArray *itemArray = [responseDic objectForKey:@"item"];
        if (itemArray == nil || [itemArray count] == 0) {
            dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dic setObject:Web_getNewsType forKey:Web_Key_urlString];
            [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
            [dic release];
        }
    }
}

- (void)clickPicture {
    NSDictionary *allDic = [[ZSSourceModel defaultSource] adsDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    NSDictionary *itemDic = [itemArray objectAtIndex:pageControl.currentPage];
    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
    NSMutableArray *adsArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [itemArray count]; i++) {
        NSDictionary *item_dic = [itemArray objectAtIndex:i];
        NSDictionary *adsDic = [NSDictionary dictionaryWithObjectsAndKeys:[item_dic objectForKey:@"newsId"],@"newsId", nil];
        [adsArray addObject:adsDic];
    }
//    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListAdsArray:)]) {
//        [delegate MainPageFirstNewsListAdsArray:adsArray];
//    }
//    if ( delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListClickAds:)]) {
//        [delegate MainPageFirstNewsListClickAds:item];
//    }
    
    
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListSetNewsInfoArray:)]) {
        [delegate MainPageFirstNewsListSetNewsInfoArray:adsArray];
    }
    
    //NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    //NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListClickNewsItem:  type:)]) {
        [delegate MainPageFirstNewsListClickNewsItem:item type:1];
    }

}

- (void)refreshAdsData {
    for (UIView *view in [adsScrollView subviews]) {
        [view removeFromSuperview];
    }
    CGSize size = adsScrollView.frame.size;
    NSDictionary *allDic = [[ZSSourceModel defaultSource] adsDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [itemArray count]; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        if ([[itemDic objectForKey:@"adtypeOnlyNum"] intValue]==2) {
            [standardUserDefault setObject:[itemDic objectForKey:@"adSrc"]  forKey:Key_Loading_url];
            [itemArray removeObjectAtIndex:i];
        }
    }
    [adsScrollView setContentSize:CGSizeMake(size.width * [itemArray count], size.height)];
    for (int i = 0; i < [itemArray count]; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@",Web_URL,[itemDic objectForKey:@"adSrc"]];
        UIImage *image = [imageQueue getImageForURL:urlString];
        [urlString appendFormat:@"?%f", 1000*[[NSDate date] timeIntervalSince1970]];
        if (!image) {
            image = [UIImage imageNamed:@"home_image_loading" ];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:i + ImageViewTag];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setTag:i + ImageViewTag];
        [imageView setFrame:CGRectMake(i*size.width, 0, size.width, size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [adsScrollView addSubview:imageView];
        [imageView setClipsToBounds:YES];
        [imageView release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*size.width, 0, size.width, size.height)];
        [btn addTarget:self action:@selector(clickPicture) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:BtnTag+i];
        [adsScrollView addSubview:btn];
    }
    [self.pageControl setNumberOfPages:[itemArray count]];
    [self.pageControl setCurrentPage:1];
    [self.pageControl setCurrentPage:0];
    [adsScrollView setContentOffset:CGPointMake(pageControl.currentPage * 320, 0) animated:NO];
    if ([itemArray count] > 0) {
        NSDictionary *itemDic = [itemArray objectAtIndex:0];
        NSString *title = [itemDic objectForKey:@"adName"];
        [newsAdsTitle setText:title];
    }
    else {
        UIImage *image = [UIImage imageNamed:@"home_image_loading" ];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [adsScrollView addSubview:imageView];
        [imageView setClipsToBounds:YES];
        [imageView release];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, size.width, size.height)];
        [btn addTarget:self action:@selector(connectWebToRefreshAds) forControlEvents:UIControlEventTouchUpInside];
        [adsScrollView addSubview:btn];
    }
}

- (void)setisNeedLoadNextNo {
    isNeedLoadNext = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:showAllScrollView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:showAllScrollView];
}

- (void)refreshNewList {
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:showAllScrollView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:showAllScrollView];

    
    NSDictionary *allListDic = [[ZSSourceModel defaultSource] newsListDataDic];
    NSArray *itemArray = [allListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStyle]];
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListSetNewsInfoArray:)]) {
        [delegate MainPageFirstNewsListSetNewsInfoArray:itemArray];
    }
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:itemArray];
    [newsArray removeObjectAtIndex:0];
    CGRect frame = newsTableView.frame;
    frame.size.height = [newsArray count] * 90;
    [newsTableView setFrame:CGRectMake(0, 160, 320, frame.size.height)];
    
    [newsTableView reloadData];
    
    [showAllScrollView setContentSize:CGSizeMake(320, frame.origin.y+frame.size.height)];
    //[tailView.view setCenter:CGPointMake(160, showAllScrollView.contentSize.height + tailView.view.frame.size.height/2)];
    //[self.showAllScrollView addSubview:tailView.view];
    [self setRefreshFooterView];
   
    if (showAllScrollView.contentSize.height < showAllScrollView.frame.size.height ) {
        [showAllScrollView setContentSize:CGSizeMake(320, showAllScrollView.frame.size.height+5)];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListSetNewsInfoArray:)]) {
        [delegate MainPageFirstNewsListSetNewsInfoArray:newsArray];
    }
    
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageFirstNewsListClickNewsItem: type:)]) {
        [delegate MainPageFirstNewsListClickNewsItem:itemId type:0];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indentifyCell = @"cell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
    }
    //cell.backgroundColor=[UIColor clearColor];
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    [cell.newsTitle setText:[itemDic objectForKey:@"newsTitle"]];
    [cell.newsTitle setNumberOfLines:2];
    [cell.newsDetailTitle setText:[itemDic objectForKey:@"newsAbstract"]];
    [cell.newsDetailTitle setNumberOfLines:3];
    UIImage *image = nil;
    NSString *urlImage=[itemDic objectForKey:@"newsSpicture"];
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[itemDic objectForKey:@"newsSpicture"]];
    if (urlImage && [urlImage isKindOfClass:[NSString class]] && [urlImage length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"list_default"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.section];
        }
        [cell setCellImage:image];
    }
    else {
        //image = [UIImage imageNamed:@"list_default"];
        [cell.newsImageView setHidden:YES];
        [cell.newsDetailTitle setFrame:CGRectMake(7, 27, 300, 46)];
    }
    
    if([[itemDic objectForKey:@"newsClassify"] intValue]==2){//视频
       [cell.newstypeImageView setImage:[UIImage imageNamed:@"shipingbiaoshi.png"]]; 
    }else if([[itemDic objectForKey:@"newsClassify"] intValue]==1){//图片
        [cell.newstypeImageView setImage:[UIImage imageNamed:@"tupianbiaoshi.png"]]; 
    }else{
        [cell.newstypeImageView setHidden:YES];
    }
    [cell.newsReplayView setText:[NSString stringWithFormat:@"%@评",[itemDic objectForKey:@"commCount"]]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    if (_index >= ImageViewTag) {
        CGSize size = adsScrollView.frame.size;
        UIView *view = [adsScrollView viewWithTag:_index];
        [view removeFromSuperview];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
        [imageView setFrame:CGRectMake((_index-ImageViewTag)*size.width, 0, size.width, size.height)];
        [adsScrollView addSubview:imageView];
        [imageView release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(_index*size.width, 0, size.width, size.height)];
        [btn addTarget:self action:@selector(clickPicture) forControlEvents:UIControlEventTouchUpInside];
        [adsScrollView addSubview:btn];
        [btn setTag:BtnTag+_index];
    }
    else {
        [newsTableView reloadData];
    }
}

#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    if (self.newsTableView && [self.newsTableView retainCount]) {
        NSIndexPath *indexPath = [newsTableView indexPathForSelectedRow];
        [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (delegate && [delegate respondsToSelector:@selector(MainPageInfoDetailBack)]) {
        [delegate MainPageInfoDetailBack];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isEqual:showAllScrollView]) {
        return ;
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];

//    CGPoint point = [scrollView contentOffset];
//    if (point.y < -50) {
//        isNeedReload = YES;
//        [topView.lblText setText:@"释放刷新"];
//        [UIView animateWithDuration:.1 animations:^{
//            [topView.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
//        }];
//    }
//    else {
//        isNeedReload = NO;
//        [topView.lblText setText:@"下拉刷新"];
//        [UIView animateWithDuration:.1 animations:^{
//            [topView.imageView setTransform:CGAffineTransformMakeRotation(0)];
//        }];
//    }
//    
//    CGSize size = scrollView.contentSize;
//    if (isNeedLoadNext) {
//        if (point.y + 360 > size.height+50) {
//            scrollIsNeedLoadNext = YES;
//            [tailView.lblText setText:@"释放加载下面10条"];
//            [UIView animateWithDuration:.1 animations:^{
//                [tailView.imageView setTransform:CGAffineTransformMakeRotation(0)];
//            }];
//        }
//        else {
//            scrollIsNeedLoadNext = NO;
//            [tailView.lblText setText:@"下拉加载下面10条"];
//            [UIView animateWithDuration:.1 animations:^{
//                [tailView.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
//            }];
//        }
//    }
//    else {
//        scrollIsNeedLoadNext = NO;
//        [tailView.lblText setText:@"已经加载全部新闻"];
//        [UIView animateWithDuration:.1 animations:^{
//            [tailView.imageView setTransform:CGAffineTransformMakeRotation(0)];
//        }];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isEqual:showAllScrollView]) {
        return;
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];

//    if (isNeedReload) {
//        [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
//        [self loadNewsList:nowNewStyle];
//        
//        NSMutableDictionary *dic = nil;
//        dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        [dic setObject:Web_getAds forKey:Web_Key_urlString];
//        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//        [dic release];
//        
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        appDelegate.startLoadNum -= 2;
//        
//        isNeedLoadNext = YES;
//    }
//    CGPoint point = scrollView.contentOffset;
//    CGSize size = scrollView.contentSize;
//    if (scrollIsNeedLoadNext && isNeedLoadNext) {
//        if (point.y + 360 > size.height) {
//            [self loadNewsList:nowNewStyle];
//        }
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:adsScrollView]) {
        return;
    }
    CGPoint point = [adsScrollView contentOffset];
    NSInteger currentAdsItem = (point.x + 1)/320;
    [self.pageControl setCurrentPage:currentAdsItem];
    NSDictionary *allDic = [[ZSSourceModel defaultSource] adsDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    NSDictionary *itemDic = [itemArray objectAtIndex:currentAdsItem];
    NSString *title = [itemDic objectForKey:@"adName"];
    [newsAdsTitle setText:title];
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
    [self loadNewsList:nowNewStyle];
    
    NSMutableDictionary *dic = nil;
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getAds forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.startLoadNum -= 2;

    isNeedLoadNext = YES;

	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
   [self loadNewsList:nowNewStyle];
}


#pragma mark - IBAction function
- (IBAction)clickPageControl:(id)sender {
    [adsScrollView setContentOffset:CGPointMake(pageControl.currentPage * 320, 0) animated:YES];
    NSInteger currentAdsItem = self.pageControl.currentPage;
    NSDictionary *allDic = [[ZSSourceModel defaultSource] adsDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    NSDictionary *itemDic = [itemArray objectAtIndex:currentAdsItem];
    NSString *title = [itemDic objectForKey:@"adName"];
    [newsAdsTitle setText:title];
}

@end







