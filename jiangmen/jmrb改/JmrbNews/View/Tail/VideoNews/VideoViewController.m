//
//  VideoViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-12.
//
//


#import "VideoViewController.h"
#import "VideoCell.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "VoteModel.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController (){

    VoteModel *votemodel;
}

- (void)refreshShowView;
- (void)setisNeedLoadNextNo;

@end

@implementation VideoViewController

@synthesize delegate;
@synthesize gridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [votemodel release];
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

    votemodel = [[VoteModel alloc] init];
    
    if (iPhone5) {
        self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 39, 320, 488)];
    }else{
        self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 39, 320, 400)];
    }
    
//    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    self.gridView.scrollEnabled=true;
    //self.gridView.contentSize=CGSizeMake(320, 420);
    
       
    self.gridView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newlistpg.png"]];
    
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - gridView.bounds.size.height, self.view.frame.size.width, gridView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[gridView addSubview:_refreshHeaderView];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setRefreshFooterView];
    
    [self.view addSubview:gridView];
    
   // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate startLoading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getVideoInfor object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLiverefresh) name:Notification_getVideoLive object:nil];
    
    [self.gridView reloadData];
    [self loadVideoData];
    
//    UIWebView *webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
//   // NSURLRequest * request = [NSURLRequest requestWithURL:@""];
//   // [webview loadRequest:request];
//    
//    NSString *embedHTML = [NSString stringWithFormat:@"\
//                           <html><head>\
//                           <style type=\"text/css\">\
//                           body {\
//                           background-color: transparent;\
//                           color: white;\
//                           }\
//                           </style>\
//                           </head><body style=\"margin:0\">\
//                           <embed id=\"yt\" src=\"%@\"  \
//                           ></embed>\
//                           </body></html>", [[NSBundle mainBundle] pathForResource:@"Video_3.mp4" ofType:nil]];
//    
//    [webview setOpaque:NO];
//     NSString *html = [NSString stringWithFormat:embedHTML, webview.frame.size.width, webview.frame.size.height];
//    [webview loadHTMLString:html baseURL:nil];
//    [self.view addSubview:webview];
     
    // Do any additional setup after loading the view from its nib.
}

- (void)videoLiverefresh{
    NSDictionary *videolive= [[ZSSourceModel defaultSource] hotVideoLiveDic];
    if(videolive!=nil){
        UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];

//        UIImageView *bofangimageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 150)];
//        
//        UIImage *image = nil;
//        NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[videolive objectForKey:@"sysvideopicsrc"]];
//        if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
//            image = [imageQueue getImageForURL:urlString];
//            if (!image) {
//                image = [UIImage imageNamed:@"list_default"];
//                [imageQueue addOperationToQueueWithURL:urlString atIndex:-11];
//            }
//        }
//        else {
//            image = [UIImage imageNamed:@"list_default"];
//        }
//        
//        [bofangimageview setImage:image];
//        UIButton *videolivebtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        videolivebtn.frame = CGRectMake(10, 5, 300, 150);
//        
//        [videolivebtn addTarget:self action:@selector(butvideoClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [headview addSubview:bofangimageview];
//        [headview addSubview:videolivebtn];
        
        UIWebView *newsWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 310, 160)];
       
        NSString *embedHTML = [NSString stringWithFormat:@"<video width=\"310\" height=\"160\" poster=\"%@\" autoplay=\"autoplay\" autobuffer=\"autobuffer\" loop=\"loop\">\
                               <source src=\"%@\" type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'>\
                               </video>",[NSString stringWithFormat:@"%@%@",Web_URL,[videolive objectForKey:@"sysvideopicsrc"]],[videolive objectForKey:@"sysvideourl"]];
        
        NSString *htmlString= [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; line-height:%ipx}\n  </style> \n </head> \n <body>%@</body> \n </html>", 160,embedHTML];
        
        [newsWebView loadHTMLString:htmlString baseURL:nil];
         
        [newsWebView setBackgroundColor:[UIColor clearColor]];
        [newsWebView setOpaque:NO];
        
        for (id subview in newsWebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).showsHorizontalScrollIndicator = NO;
             //[(UIScrollView *)aView setShowsVerticalScrollIndicator:NO];
        }
        
        
        [headview addSubview:newsWebView];
        
        [self.gridView setGridHeaderView:headview];
        
        //[bofangimageview release];
        [newsWebView release];
        //[videolivebtn release];
        [headview release];
       

    }
    
    
}

- (void)refreshShowView{
    [votemodel getVideoLive];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    // NSInteger oldImageCount = [newsArray count];
    
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:[[ZSSourceModel defaultSource] hotVideoDic]];
    if ([newsArray count] == 0) {
        return;
    }
    
    [self.gridView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:gridView];
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:gridView];
    
    [self setRefreshFooterView];

    
}

-(void)setRefreshFooterView
{
    CGFloat height = MAX(gridView.contentSize.height, gridView.frame.size.height);
    if (_loadMoreView && [_loadMoreView superview]) {
        // reset position
        _loadMoreView.frame = CGRectMake(0.0f,
                                         height,
                                         gridView.frame.size.width,
                                         self.view.bounds.size.height);
    }else {
        // create the footerView
        _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height,gridView.frame.size.width, self.view.bounds.size.height)];
        _loadMoreView.delegate = self;
        [gridView addSubview:_loadMoreView];
    }
}

-(void) loadVideoData{
    [[ZSCommunicateModel defaultCommunicate] clearHotVideoList];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getHotVideoNews forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];

}


-(void)butvideoClick:(id)sender{
    //视频文件路径
   // NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    //视频URL
    NSURL *url = [NSURL URLWithString:@"http://flv2.jmnews.com.cn/m/2013/05/20130515-01.mp4"];
    //视频播放对象
    MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    movie.controlStyle = MPMovieControlStyleFullscreen;
    [movie.view setFrame:self.view.bounds];
    movie.initialPlaybackTime = -1;
    [self.view addSubview:movie.view];
    //[self.navigationController pushViewController:movie animated:YES];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [movie play];
}


#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    // 释放视频对象
    [theMovie release];
}

- (IBAction)clickRefresh:(id)sender{
    [self loadVideoData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [gridView reloadData];
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
    [self loadVideoData];
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getHotVideoNews forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}


#pragma mark AQGridViewDataSource
-(NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView{
    
    return newsArray.count;
}

-(AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index{
    
    static NSString *identifier = @"PlainCell";
    
    VideoCell *cell = (VideoCell *)[aGridView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        cell = [[VideoCell alloc] initWithFrame:CGRectMake(0, 0, 150, 180) reuseIdentifier:identifier];
    }
    NSDictionary *itemDic = [newsArray objectAtIndex:index];
    [cell.captionLabel setText:[itemDic objectForKey:@"newsTitle"]];
    [cell.displayLable setText:[[itemDic objectForKey:@"newsClicked"] stringValue]];
    [cell.replayLable setText:[[itemDic objectForKey:@"commCount"] stringValue]];
    UIImage *image = nil;
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[itemDic objectForKey:@"newsSpicture"]];
    if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"list_default"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:index];
        }
    }
    else {
        image = [UIImage imageNamed:@"list_default"];
    }
    [cell.imageView setImage:image];
    
    
    return cell;
    
}

//每个显示框大小
-(CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView{
    
    return CGSizeMake(150, 180);
}

//选中Item
-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{
    
    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
        [delegate PictureNewHideTarBar:YES];
    }
    NSInteger itemid= [[[newsArray objectAtIndex:index] objectForKey:@"newsId"] intValue];
    
//    PictureNewInfoDetail *pictureNewsInfo = [[PictureNewInfoDetail alloc] initWithNibName:@"PictureNewInfoDetail" bundle:nil];
//    [self.navigationController pushViewController:pictureNewsInfo animated:YES];
//    [pictureNewsInfo setDelegate:self];
//    [pictureNewsInfo setNewsArray:newsArray];
//    [pictureNewsInfo setNewsContent:itemid];
//    [pictureNewsInfo initFrame];
//    [pictureNewsInfo.newsTitle setText:@"视频新闻"];
//    [pictureNewsInfo release];
    
    MainPageNewInfoDetail *_newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo setDelegate:self];
    [_newInfo setNewsArray:newsArray];
    [_newInfo setNewsContent:itemid];
    [_newInfo initFrame];
    [_newInfo.newsTitle setText:@"视频新闻"];
    [_newInfo release];

    
}


#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
        [delegate PictureNewHideTarBar:NO];
    }
}


#pragma mark - PictureNewInfoDetailDelegate
- (void)PictureNewInfoShowTarBar {
    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
        [delegate PictureNewHideTarBar:NO];
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
