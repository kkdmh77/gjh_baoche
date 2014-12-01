//
//  SpecialListViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-16.
//
//

#import "SpecialListViewController.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"


@interface SpecialListViewController ()

@end

@implementation SpecialListViewController
@synthesize newsTableView,delegate;
@synthesize newsCell;

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
    newsArray = [[NSMutableArray alloc] init];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    
    //newlistpg.png
    newsTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newlistpg.png"]];
    newsTableView.dataSource=self;
    newsTableView.delegate=self;
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - newsTableView.bounds.size.height, self.view.frame.size.width, newsTableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[newsTableView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setRefreshFooterView];
    
   // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate startLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getSpecialNewsContent object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)loadSpecialList:(NSInteger)typeId {
    [[ZSCommunicateModel defaultCommunicate] clearAllSpecialList];
    nowSpecialId = typeId;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNewsContent forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", typeId] forKey:Key_Special_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}


#pragma mark - Public
- (void)setisNeedLoadNextNo {
    //isNeedLoadNext = YES;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
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

- (void)refreshShowView{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:[[ZSSourceModel defaultSource] specialContentDic]];
    if ([newsArray count] == 0) {
        return;
    }
    [newsTableView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    
    [self setRefreshFooterView];
    
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickRefresh:(id)sender{
    [[ZSCommunicateModel defaultCommunicate] clearAllSpecialList];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNewsContent forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", nowSpecialId] forKey:Key_Special_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifyCell = @"cell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
    }

    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    MoreDetailViewController *detailViewController=[[MoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:detailViewController animated:YES];
    //    [detailViewController release];
    
    if (delegate && [delegate respondsToSelector:@selector(SpecialListListHideTarBar:)]) {
        [delegate SpecialListListHideTarBar:YES];
    }
 
    NSInteger itemid= [[[newsArray objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
    
//    PictureNewInfoDetail *pictureNewsInfo = [[PictureNewInfoDetail alloc] initWithNibName:@"PictureNewInfoDetail" bundle:nil];
//    [self.navigationController pushViewController:pictureNewsInfo animated:YES];
//    
//    [pictureNewsInfo setDelegate:self];
//    [pictureNewsInfo setNewsArray:newsArray];
//    [pictureNewsInfo setNewsContent:itemid];
//    [pictureNewsInfo initFrame];
//    [pictureNewsInfo.newsTitle setText:@"专题新闻"];
//    [pictureNewsInfo release];
    
    MainPageNewInfoDetail *_newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo setDelegate:self];
    [_newInfo setNewsArray:newsArray];
    [_newInfo setNewsContent:itemid];
    [_newInfo initFrame];
    [_newInfo.newsTitle setText:@"专题新闻"];
    [_newInfo release];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
	
}



#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [[ZSCommunicateModel defaultCommunicate] clearAllSpecialList];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNewsContent forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", nowSpecialId] forKey:Key_Special_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    
	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNewsContent forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", nowSpecialId] forKey:Key_Special_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}


#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    if (delegate && [delegate respondsToSelector:@selector(SpecialListListHideTarBar:)]) {
        [delegate SpecialListListHideTarBar:NO];
    }
}




//#pragma mark - SpecialListViewDelegate
//- (void)MainPageNewInfoDetailGoBack {
////    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListHideTarBar:)]) {
////        [delegate MainPageSecondNewsListHideTarBar:NO];
////    }
////    if (delegate && [delegate respondsToSelector:@selector(MainPageInfoDetailBack)]) {
////        [delegate MainPageInfoDetailBack];
////    }
////    if (self.newsTableView && [self.newsTableView retainCount]) {
////        NSIndexPath *indexPath = [newsTableView indexPathForSelectedRow];
////        [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
////    }
//   
//}


#pragma mark - PictureNewInfoDetailDelegate
- (void)PictureNewInfoShowTarBar {
    if (delegate && [delegate respondsToSelector:@selector(SpecialListListHideTarBar:)]) {
        [delegate SpecialListListHideTarBar:NO];
    }
}

- (void)PictureNewInfoGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
