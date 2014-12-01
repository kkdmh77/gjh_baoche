//
//  MainPageSecondNewsVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MainPageSecondNewsListVC.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MainPageSecondNewsListVC ()

- (void)refreshNewList;
- (void)setisNeedLoadNextNo;
- (void)showNewsAds;

@end

@implementation MainPageSecondNewsListVC
@synthesize adsShowView;
@synthesize lblTitle;
@synthesize newsTableView;
@synthesize newsCell;
@synthesize newsHeadCell;
@synthesize delegate;

- (void)dealloc {
    [topView release];
    [tailView release];
    [_lblAds release];
    [newsArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollIsNeedLoadNext = NO;
    isNeedReload = NO;
    isNeedLoadNext = YES;
    _isCancelLoad = NO;
    _isAdsMoving = NO;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    if (iPhone5) {
        [newsTableView setFrame:CGRectMake(0, 70, 320, 498)];
    }

     newsTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newlistpg.png"]];
    
//    NSArray *adsArray = [[ZSSourceModel defaultSource] newsListAdsArray];
//    if ([adsArray count] > 0) {
//        currentAdsNewsNum = 0;
//        NSDictionary *itemDic = [adsArray objectAtIndex:0];
//        NSString *titleString = [itemDic objectForKey:@"newsTitle"];
//        _lblAds = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
//        [adsShowView addSubview:_lblAds];
//        [_lblAds setTextColor:[UIColor whiteColor]];
//        [_lblAds setBackgroundColor:[UIColor clearColor]];
//        [_lblAds setText:[NSString stringWithFormat:@"[新闻推荐]:%@", titleString]];
//        [self performSelector:@selector(showNewsAds) withObject:nil afterDelay:1];
//    }
    [adsShowView setHidden:YES];
    
    topView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    [topView.view setCenter:CGPointMake(160, -topView.view.frame.size.height/2)];
    //[self.newsTableView addSubview:topView.view];
    
    tailView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - newsTableView.bounds.size.height, self.view.frame.size.width, newsTableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[newsTableView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setRefreshFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewList) name:notification_getNewsList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
    
    UISwipeGestureRecognizer *swipGestureNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickNextNews)];
    [swipGestureNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipGestureNext];
    [swipGestureNext release];
    
    UISwipeGestureRecognizer *swipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreNews)];
    [swipGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipGestureLeft];
    [swipGestureLeft release];
}

- (void)clickNextNews{
    
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListChange)]) {
        [delegate MainPageSecondNewsListChange];
    }
    
}

- (void)clickPreNews{
    
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListChangeBack)]) {
        [delegate MainPageSecondNewsListChangeBack];
    }
    
}


-(void)setRefreshFooterView
{
    CGFloat height = MAX(newsTableView.contentSize.height, newsTableView.frame.size.height);
    if (_loadMoreView && [_loadMoreView superview]) {
        // reset position
        _loadMoreView.frame = CGRectMake(0.0f,
                                         height,
                                         newsTableView.frame.size.width,
                                         self.view.bounds.size.height);
    }else {
        // create the footerView
        _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height,newsTableView.frame.size.width, self.view.bounds.size.height)];
        _loadMoreView.delegate = self;
        [newsTableView addSubview:_loadMoreView];
    }
}

#pragma mark - Public
- (IBAction)clickRefresh:(id)sender {
    [newsTableView scrollRectToVisible:CGRectMake(0, 0, 320, 400) animated:NO];
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
    [self loadNewsList:nowNewStyle];
    isNeedLoadNext = YES;
}

- (void)adsShowBegin {
    if (_isCancelLoad == YES) {
        _isCancelLoad = NO;
        [self showNewsAds];
    }
}

- (void)loadNewsList:(NSInteger)typeId {
    nowNewStyle = typeId;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNewsList forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", typeId] forKey:Key_News_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

#pragma mark - xib function
- (IBAction)clickAdsShow:(id)sender {
    NSArray *itemArray = [[ZSSourceModel defaultSource] newsListAdsArray];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:itemArray];
    }
    NSInteger itemId = [[[itemArray objectAtIndex:currentAdsNewsNum] objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGotoNewDetail:)]) {
        [delegate MainPageSecondNewsListGotoNewDetail:itemId];
    }
    
}

- (IBAction)clickBack:(id)sender {
    _isCancelLoad  = YES;
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGoBack)]) {
        [delegate MainPageSecondNewsListGoBack];
    }
}

#pragma mark - Private
- (void)showNewsAds {
    if (_isCancelLoad) {
        return;
    }
    if (_isAdsMoving) {
        return;
    }
    _isAdsMoving = YES;
    NSArray *adsArray = [[ZSSourceModel defaultSource] newsListAdsArray];
    currentAdsNewsNum++;
    if (currentAdsNewsNum >= [adsArray count]) {
        currentAdsNewsNum = 0;
    }
    NSDictionary *itemDic = [adsArray objectAtIndex:currentAdsNewsNum];
    NSString *titleString = [itemDic objectForKey:@"newsTitle"];
    
    UILabel *lblAds1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, 300, 44)];
    [lblAds1 setTextColor:[UIColor whiteColor]];
    [lblAds1 setBackgroundColor:[UIColor clearColor]];
    [lblAds1 setText:[NSString stringWithFormat:@"[新闻推荐]:%@", titleString]];
    if (adsShowView) {
        [adsShowView addSubview:lblAds1];
    }
    [UIView animateWithDuration:1 animations:^{
        [_lblAds setFrame:CGRectMake(10, -44, 300, 44)];
        [lblAds1 setFrame:CGRectMake(10, 0, 300, 44)];
    }completion:^(BOOL finish){
        _isAdsMoving = NO;
        [_lblAds removeFromSuperview];
        [_lblAds release];
        _lblAds = lblAds1;
        [self performSelector:@selector(showNewsAds) withObject:nil afterDelay:2];
    }];
}

- (void)setisNeedLoadNextNo {
    isNeedLoadNext = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
}

- (void)refreshNewList {
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    
    NSDictionary *allListDic = [[ZSSourceModel defaultSource] newsListDataDic];
    NSArray *itemArray = [allListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStyle]];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:itemArray];
    }
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:itemArray];
    [newsTableView reloadData];
    
//    [tailView.view setCenter:CGPointMake(160, [itemArray count]*90 + tailView.view.frame.size.height/2)];
//    [self.newsTableView addSubview:tailView.view];
    
    [self setRefreshFooterView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:newsArray];
    }
    
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGotoNewDetail:)]) {
        [delegate MainPageSecondNewsListGotoNewDetail:itemId];
    }
    _isCancelLoad = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsArray count];
}




//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (section==0) {
//        UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
//        
//        UILabel *totaltext=[[UILabel alloc] initWithFrame:CGRectMake(4, 2, 320, 28)];
//        [totaltext setText:@"共计：￥0.00"];
//        
//        [headview addSubview:totaltext];
//        [totaltext release];
//        
//        return [headview autorelease];
//    }
//    
//    return nil;
//   
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
       // NSString *indentifyCell = @"cell";
        NSString *CellIdentifier = @"cellhead";
        NewsHeadCell *cellhead = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cellhead) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewsHeadCell" owner:self options:nil];
            cellhead = [array objectAtIndex:0];
            [cellhead setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        //[cellhead.cellImageView setImage:[UIImage imageNamed:@"list_default"]];
         
        if ((NSNull *)itemDic == [NSNull null]) {
             UIImage *image = [UIImage imageNamed:@"home_image_loading"];
             [cellhead.cellImageView setImage:image];
        }else{
            [cellhead.cellLabel  setText:[itemDic objectForKey:@"newsTitle"]];
            
            NSMutableArray * piclistArray=[[NSMutableArray alloc] init];
            piclistArray = [itemDic objectForKey:@"rbNewspics"];
            if(piclistArray.count>0){
                UIImage *image = nil;
                NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[[piclistArray objectAtIndex:piclistArray.count-1] objectForKey:@"newspic"]];
                if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
                    image = [imageQueue getImageForURL:urlString];
                    if (!image) {
                        image = [UIImage imageNamed:@"home_image_loading"];
                        [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.row];
                    }
                }
                else {
                    image = [UIImage imageNamed:@"home_image_loading"];
                }
                
                //cellhead.cellImageView.clipsToBounds=YES;
                //[cellhead.cellImageView setContentMode:UIViewContentModeScaleAspectFill];
                [cellhead.cellImageView setImage:image];
            }
        }
        
       
        
        return  cellhead;
        
    }else{
        NSString *indentifyCell = @"cell";
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
            cell = newsCell;
        }
        
        [cell.newsTitle setText:[itemDic objectForKey:@"newsTitle"]];
        [cell.newsTitle setNumberOfLines:2];
        [cell.newsDetailTitle setText:[itemDic objectForKey:@"newsAbstract"]];
        [cell.newsDetailTitle setNumberOfLines:3];
        UIImage *image = nil;
        NSString *urlImage=[itemDic objectForKey:@"newsSpicture"];
        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,urlImage];
        if (urlImage && [urlImage isKindOfClass:[NSString class]] && [urlImage length] > 0) {
            image = [imageQueue getImageForURL:urlString];
            if (!image) {
                image = [UIImage imageNamed:@"list_default"];
                [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.row];
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
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 176;
    }else{
        return 90;
    }
    
}

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
}

#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListHideTarBar:)]) {
        [delegate MainPageSecondNewsListHideTarBar:NO];
    }
    if (delegate && [delegate respondsToSelector:@selector(MainPageInfoDetailBack)]) {
        [delegate MainPageInfoDetailBack];
    }
    if (self.newsTableView && [self.newsTableView retainCount]) {
        NSIndexPath *indexPath = [newsTableView indexPathForSelectedRow];
        [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self adsShowBegin];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
//        if (point.y + 398 > size.height+50) {
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

    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
//    if (isNeedReload) {
//        [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
//        [self loadNewsList:nowNewStyle];
//        isNeedLoadNext = YES;
//    }
//    
//    CGPoint point = scrollView.contentOffset;
//    CGSize size = scrollView.contentSize;
//    if (scrollIsNeedLoadNext && isNeedLoadNext) {
//        if (point.y + 398 > size.height) {
//            [self loadNewsList:nowNewStyle];
//        }
//    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
    [self loadNewsList:nowNewStyle];
    
    isNeedLoadNext = YES;
    
	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    [self loadNewsList:nowNewStyle];
}

@end
