//
//  MainPageSecondNewsVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "ListSecondNewsListVC.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface ListSecondNewsListVC ()

- (void)refreshNewList;
- (void)setisNeedLoadNextNo;
- (void)showNewsAds;

@end

@implementation ListSecondNewsListVC
@synthesize adsShowView;
@synthesize lblTitle;
@synthesize newsTableView;
@synthesize newsCell;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollIsNeedLoadNext = NO;
    isNeedLoadNext = YES;
    _isCancelLoad = NO;
    _isAdsMoving = NO;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    
    NSMutableDictionary *newsTypeDataDic = [[[ZSSourceModel defaultSource] newsTypeDataDic] retain];
    NSDictionary *responseDic = [newsTypeDataDic objectForKey:@"response"];
    [newsTypeDataDic release];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    int count = [itemArray count];
    for (int i = 0; i < count; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        if ([[itemDic objectForKey:@"newstypeId"] intValue] == nowNewStyle) {
            [lblTitle setText:[itemDic objectForKey:@"newstypeName"]];
        }
    }
    
    NSArray *adsArray = [[ZSSourceModel defaultSource] newsListAdsArray];
    if ([adsArray count] > 0) {
        currentAdsNewsNum = 0;
        NSDictionary *itemDic = [adsArray objectAtIndex:0];
        NSString *titleString = [itemDic objectForKey:@"newsTitle"];
        _lblAds = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
        [adsShowView addSubview:_lblAds];
        [_lblAds setTextColor:[UIColor whiteColor]];
        [_lblAds setBackgroundColor:[UIColor clearColor]];
        [_lblAds setText:[NSString stringWithFormat:@"[新闻推荐]:%@", titleString]];
        [self performSelector:@selector(showNewsAds) withObject:nil afterDelay:1];
    }
    [adsShowView setHidden:true];
    
    topView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    [topView.view setCenter:CGPointMake(160, -topView.view.frame.size.height/2)];
    [self.newsTableView addSubview:topView.view];
    tailView = [[RefreshTextView alloc] initWithNibName:@"RefreshTextView" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewList) name:notification_getNewsList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
}

#pragma mark - Public
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
        [self performSelector:@selector(showNewsAds) withObject:nil afterDelay:1];
    }];
}

- (void)setisNeedLoadNextNo {
    isNeedLoadNext = NO;
}

- (void)refreshNewList {
    NSDictionary *allListDic = [[[ZSSourceModel defaultSource] newsListDataDic] retain];
    NSArray *itemArray = [allListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStyle]];
    [allListDic release];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:itemArray];
    }
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:itemArray];
    [newsTableView reloadData];
    
    [tailView.view setCenter:CGPointMake(160, [itemArray count]*70 + tailView.view.frame.size.height/2)];
    [self.newsTableView addSubview:tailView.view];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:newsArray];
    }
    
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGotoNewDetail:)]) {
        [delegate MainPageSecondNewsListGotoNewDetail:itemId];
    }
    _isCancelLoad = YES;
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
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    [cell.newsTitle setText:[itemDic objectForKey:@"newsTitle"]];
    [cell.newsTitle setNumberOfLines:2];
    [cell.newsDetailTitle setText:[itemDic objectForKey:@"newsAbstract"]];
    [cell.newsDetailTitle setNumberOfLines:3];
    UIImage *image = nil;
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[itemDic objectForKey:@"newsSpicture"]];
    if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"list_default"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.section];
        }
    }
    else {
        image = [UIImage imageNamed:@"list_default"];
    }
    [cell setCellImage:image];
    if([[itemDic objectForKey:@"newsVideo"] intValue]==1){//视频
        [cell.newstypeImageView setImage:[UIImage imageNamed:@"list_default"]];
    }else if([[itemDic objectForKey:@"newsHot"] intValue]==1){//图片
        [cell.newstypeImageView setImage:[UIImage imageNamed:@"list_default"]];
    }else{
        [cell.newstypeImageView setHidden:YES];
    }
    [cell.newsReplayView setText:[NSString stringWithFormat:@"%@评",@"10"]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
}

#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
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
    CGPoint point = [scrollView contentOffset];
    if (point.y < -50) {
        isNeedReload = YES;
        [topView.lblText setText:@"释放刷新"];
        [UIView animateWithDuration:.1 animations:^{
            [topView.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
        }];
    }
    else {
        isNeedReload = NO;
        [topView.lblText setText:@"下拉刷新"];
        [UIView animateWithDuration:.1 animations:^{
            [topView.imageView setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
    
    CGSize size = scrollView.contentSize;
    if (isNeedLoadNext) {
        if (point.y + 398 > size.height+50) {
            scrollIsNeedLoadNext = YES;
            [tailView.lblText setText:@"释放加载下面10条"];
            [UIView animateWithDuration:.1 animations:^{
                [tailView.imageView setTransform:CGAffineTransformMakeRotation(0)];
            }];
        }
        else {
            scrollIsNeedLoadNext = NO;
            [tailView.lblText setText:@"下拉加载下面10条"];
            [UIView animateWithDuration:.1 animations:^{
                [tailView.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
            }];
        }
    }
    else {
        scrollIsNeedLoadNext = NO;
        [tailView.lblText setText:@"已经加载全部新闻"];
        [UIView animateWithDuration:.1 animations:^{
            [tailView.imageView setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isNeedReload) {
        [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
        [self loadNewsList:nowNewStyle];
        isNeedLoadNext = YES;
    }
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    if (scrollIsNeedLoadNext && isNeedLoadNext) {
        if (point.y + 398 > size.height) {
            [self loadNewsList:nowNewStyle];
        }
    }
}

@end
