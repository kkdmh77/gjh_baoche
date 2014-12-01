//
//  TouPiaoActiveViewController.m
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import "TouPiaoActiveViewController.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"
#import "TouPiaoDetailViewController.h"

@interface TouPiaoActiveViewController ()


- (void)refreshShowView;
- (void)setisNeedLoadNextNo;

@end

@implementation TouPiaoActiveViewController
@synthesize newsTableView;

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
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];

    newsArray = [[NSMutableArray alloc] init];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    
    newsTableView.dataSource=self;
    newsTableView.delegate=self;
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - newsTableView.bounds.size.height, self.view.frame.size.width, newsTableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[newsTableView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setRefreshFooterView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getVoteListNews object:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getVoteList forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] clearVoteList];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];


    
    
    
    // Do any additional setup after loading the view from its nib.
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
    // NSInteger oldImageCount = [newsArray count];
    
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:[[ZSSourceModel defaultSource] votelistDic]];
    if ([newsArray count] == 0) {
        return;
    }
    
    [self.newsTableView reloadData];
    
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    
    [self setRefreshFooterView];
    
    
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickBaoLiao:(id)sender{
    BaoLiaoActiveViewController *personnewsvc=[[BaoLiaoActiveViewController alloc] init];
    [self.navigationController pushViewController:personnewsvc animated:YES];
    //[self presentModalViewController:personnewsvc animated:YES];
    [personnewsvc release];
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
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"cell";
    TouPiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (cell == nil) {
        //[[NSBundle mainBundle] loadNibNamed:@"PicListCell" owner:self options:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TouPiaoCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0 && [itemDic objectForKey:@"lotteryId"]!=nil) {
        
        [cell.newsTitle setText:[itemDic objectForKey:@"lotteryTitile"]];
        [cell.newsTitle setNumberOfLines:2];
        
        [cell.newsDetailTitle setText:[itemDic objectForKey:@"lotteryStep"]];
        [cell.newsDetailTitle setNumberOfLines:3];
        [cell.newstypeImageView setImage:[UIImage imageNamed:@"awardsmall.png"]];
        
        [cell.newsImageView setHidden:true];
        [cell.selectimage1 setHidden:true];
        [cell.selecttext1 setHidden:true];
        [cell.selectimage2 setHidden:true];
        [cell.selecttext2 setHidden:true];
        [cell.toupiaonum setHidden:true];
        
    }else{
        [cell.newsTitle setText:[itemDic objectForKey:@"voteTitle"]];
        [cell.newsTitle setNumberOfLines:2];
        [cell.newsDetailTitle setHidden:true];
        [cell.newstypeImageView setImage:[UIImage imageNamed:@"toupiaosmall.png"]];
        UIImage *image = nil;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[itemDic objectForKey:@"votePicture"]];
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
        
        [cell.newsImageView setImage:image];
        
        NSMutableArray * itmelistArray=[[NSMutableArray alloc] init];
        itmelistArray = [itemDic objectForKey:@"voteOptionList"];
        
        if(itmelistArray.count>0){
            [cell.selectimage1 setHidden:NO];
            [cell.selecttext1 setHidden:NO];
            [cell.selecttext1 setText:[[itmelistArray objectAtIndex:0] objectForKey:@"voteoptionContent"]];
        }
        if(itmelistArray.count>1){
            [cell.selectimage2 setHidden:NO];
            [cell.selecttext2 setHidden:NO];
            [cell.selecttext2 setText:[[itmelistArray objectAtIndex:1] objectForKey:@"voteoptionContent"]];
        }
        
        [cell.toupiaonum setText:[NSString stringWithFormat:@"%@人投票",[itemDic objectForKey:@"voteCointInt"]]];
    }
    
    
    
    
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    MoreDetailViewController *detailViewController=[[MoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:detailViewController animated:YES];
    //    [detailViewController release];
     NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
    
    if (indexPath.row==0 && [itemDic objectForKey:@"lotteryId"]!=nil) {
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *objectDic =  [standardUserDefault objectForKey:Key_UserName];
        if(objectDic!=nil){
            AwardViewController *award=[[AwardViewController alloc] init];
            [self.navigationController pushViewController:award animated:YES];
            [award release];
        }else{
            UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登陆,请登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterview show];
            [alterview release];
        }
        
    }else{
        TouPiaoDetailViewController *detailViewController=[[TouPiaoDetailViewController alloc] init];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController loadNewsContent:[newsArray objectAtIndex:indexPath.row]];
    }

    
    //NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
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
    
    [[ZSCommunicateModel defaultCommunicate] clearVoteList];

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getVoteList forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];

    
	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getVoteList forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
