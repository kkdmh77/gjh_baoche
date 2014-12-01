//
//  SpecialViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-16.
//
//

#import "SpecialViewController.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"


@interface SpecialViewController ()

- (void)refreshShowView;
- (void)setisNeedLoadNextNo;


@end

@implementation SpecialViewController
@synthesize newsTableView,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_specialList release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [newsArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    newsArray = [[NSMutableArray alloc] init];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    
    //newlistpg.png
    newsTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    newsTableView.dataSource=self;
    newsTableView.delegate=self;
    [newsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - newsTableView.bounds.size.height, self.view.frame.size.width, newsTableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[newsTableView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getSpecialNews object:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNews forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Public
- (void)setisNeedLoadNextNo {
    //isNeedLoadNext = YES;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
    //[_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];
}


- (void)refreshShowView{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:[[ZSSourceModel defaultSource] specialDic]];
    if ([newsArray count] == 0) {
        return;
    }
    
    [newsTableView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsTableView];

}

- (IBAction)clickRefresh:(id)sender{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNews forKey:Web_Key_urlString];
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
    static NSString *CellIdentifier = @"cell";
    
    SpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (cell == nil) {
        //[[NSBundle mainBundle] loadNibNamed:@"PicListCell" owner:self options:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SpecialCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.row];
    [cell.newsTitle setText:[itemDic objectForKey:@"specialTitle"]];
    [cell.newsInfo setText:[itemDic objectForKey:@"specialAbstract"]];
    [cell.newsInfo setNumberOfLines:3];
    
    NSMutableArray * piclistArray=[[NSMutableArray alloc] init];
    piclistArray = [itemDic objectForKey:@"rbSpecialpics"];

    if(piclistArray.count>0){
        UIImage *image = nil;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[[piclistArray objectAtIndex:0] objectForKey:@"speciapicUrl"]];
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
        [cell.newsImageView1 setImage:image];
    }
    
    if(piclistArray.count>1){
        UIImage *image = nil;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[[piclistArray objectAtIndex:1] objectForKey:@"speciapicUrl"]];
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
        [cell.newsImageView2 setImage:image];
    }
    
    if(piclistArray.count>2){
        UIImage *image = nil;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[[piclistArray objectAtIndex:2] objectForKey:@"speciapicUrl"]];
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
        [cell.newsImageView3 setImage:image];
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
    
//    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
//        [delegate PictureNewHideTarBar:YES];
//    }

    
    NSInteger itemid= [[[newsArray objectAtIndex:indexPath.row] objectForKey:@"specialId"] intValue];
    if(!_specialList){
    
         _specialList=[[SpecialListViewController alloc] init];
    }
    _specialList.delegate=self;
    [_specialList loadSpecialList:itemid];
    [self.navigationController pushViewController:_specialList animated:YES];
    
        
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}


#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    //[_loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    //[_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
	
}



#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    NSMutableDictionary *dic = nil;
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getSpecialNews forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
    
	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
   
}


#pragma mark - SpecialListViewDelegate
- (void)SpecialListListHideTarBar:(BOOL)isHide {
    if (delegate && [delegate respondsToSelector:@selector(SpecialNewHideTarBar:)]) {
        [delegate SpecialNewHideTarBar:isHide];
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
