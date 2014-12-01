//
//  MPNewInfoDetailContent.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MPNewInfoDetailContent.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MPNewInfoDetailContent ()

- (void)reFreshNewsContent;
- (void)pinGestureBack:(UIPinchGestureRecognizer *)recognizer;
- (void)setFontIsChangeNO;
- (void)setImageViewAlpha0;

@end

@implementation MPNewInfoDetailContent
@synthesize newsWebView2;
@synthesize itemId;
@synthesize newsTitle, newsImageView, newsSecondTitle, newsBgScrollView;
@synthesize textSlider;
@synthesize btnClickImage;
@synthesize isNeedLoad;

#pragma mark - Public
- (void)clearWebViewContent {
    [newsBgScrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:NO];
    UIImage *image = [UIImage imageNamed:@"home_image_loading"];
    [newsImageView setFrame:CGRectMake(20, 123, 280, 128)];
    [newsImageView setImage:image];
    [newsImageView setAlpha:0];
    [newsTitle setText:@""];
    [newsSecondTitle setText:@""];
    [newsWebView loadHTMLString:@"" baseURL:nil];
    //[webview loadHTMLString:@"" baseURL:nil];
}

- (void)setTextViewFontSize:(NSInteger) fontSize {
    @synchronized([MPNewInfoDetailContent class]) {
        if (_isFontChanging == YES) {
            NSLog(@"jump");
            return;
        }
        _isFontChanging = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",fontSize] forKey:Font_NewsInfoContent];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [newsTitle setFont:[UIFont systemFontOfSize:fontSize]];
        [newsSecondTitle setFont:[UIFont systemFontOfSize:10+(fontSize-17)/3]];
        
        if (_newsItemDic) {
            NSString *jsString = [NSString stringWithFormat:@"document.body.style.fontSize = %i",fontSize];
            [newsWebView stringByEvaluatingJavaScriptFromString:jsString];
            jsString = [NSString stringWithFormat:@"document.body.style.lineHeight = %f", 1.5];
            [newsWebView stringByEvaluatingJavaScriptFromString:jsString];
            
            CGRect frame = newsWebView.frame;
            [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 200)];
            CGSize textSize = [newsWebView sizeThatFits:CGSizeZero];
            [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
            [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height + 80)];
            [newsBgScrollView setScrollEnabled:YES];
        }
        [self performSelector:@selector(setFontIsChangeNO) withObject:nil afterDelay:.5];
    }
}

#pragma mark - system
- (void)dealloc {
    [_imageUrlArray release];
    [newsWebView stopLoading];
    //[webview stopLoading];
    [activityIndicator release];
    [_newsItemDic release];
    [bigImageView release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [newsWebView release];
   // [webview release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isNeedLoad = YES;
    _isFontChanging = NO;
    _oldFontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:Font_NewsInfoContent] intValue];
;
    _newFontSize = _oldFontSize;
    [newsSecondTitle setAdjustsFontSizeToFitWidth:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshNewsContent) name:notification_getNews object:nil];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    bigImageView = [[MPBigImage alloc] initWithNibName:@"MPBigImage" bundle:nil];
    if (iPhone5) {
        [bigImageView.view setFrame:CGRectMake(0, 0, 320, 568)];
    }
    
    [bigImageView setDelegate:self]; 
    
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureBack:)];
//    [self.view addGestureRecognizer:pinchGesture];
//    [pinchGesture release];
    newsWebView = [[UIWebView alloc] init];
    [newsWebView setBackgroundColor:[UIColor clearColor]];
    [newsWebView setDelegate:self];
    newsWebView.opaque=false;
    
    //[newsWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    
    _imageUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [newsImageView setAlpha:0];
    [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+136)];
    [btnClickImage setEnabled:NO];
    
//    webview = [[UIWebView alloc] init];
//    [webview setFrame:CGRectMake(10, 123, 300, 200)];
//    webview.delegate=self;
//    webview.backgroundColor=[UIColor clearColor];
//    [webview setAlpha:0];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 45.0f, 45.0f)];
    [activityIndicator setCenter:self.view.center];
    [self.view addSubview:activityIndicator];
    [newsBgScrollView setDelegate:self];
    [newsBgScrollView addSubview:newsWebView];
    
    for (id subview in newsWebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).scrollEnabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerDidExitFullscreen:)
     
                                                 name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerDidExitFullscreen:)
     
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
     
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerDidExitFullscreen:)
     
                                                 name:@"MPAVControllerPlaybackStateChangedNotification"
     
                                               object:nil];
    
    
    //[(UIScrollView *)[[webview subviews] objectAtIndex:0] setBounces:NO];
}


-(void)setRefreshFooterView
{
    CGFloat height = MAX(newsBgScrollView.contentSize.height, newsBgScrollView.frame.size.height);
    if (_loadMoreView && [_loadMoreView superview]) {
        // reset position
        _loadMoreView.frame = CGRectMake(0.0f,
                                         height,
                                         newsBgScrollView.frame.size.width,
                                         self.view.bounds.size.height);
    }else {
        // create the footerView
        _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height,newsBgScrollView.frame.size.width, self.view.bounds.size.height)];
        _loadMoreView.delegate = self;
        [newsBgScrollView addSubview:_loadMoreView];
    }
}




- (void)playerDidExitFullscreen:(NSNotification*) notification{
    NSLog(@"%@",notification.name);
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:(id)UIInterfaceOrientationLandscapeRight];
    }
    
}


- (void)loadNewsContent:(NSInteger) item{
    [newsImageView setAlpha:0];
    [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+136)];
    [btnClickImage setEnabled:NO];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNews forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i",item] forKey:Key_News_Item_Content];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

#pragma mark - Private
- (void)setImageViewAlpha0 {
    [newsImageView setAlpha:0];
}

- (void)setFontIsChangeNO {
    _isFontChanging = NO;
}

- (void)pinGestureBack:(UIPinchGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _oldFontSize = _newFontSize;
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
            if (fabs(_newFontSize - (_oldFontSize + (recognizer.scale-1)*5)) > .5 ) {
                _newFontSize = _oldFontSize + (recognizer.scale-1)*5;
                if (_newFontSize < 13) {
                    _newFontSize = 13;
                }
                if (_newFontSize > 32) {
                    _newFontSize = 32;
                }
                [self setTextViewFontSize:_newFontSize];
            }
            break;
        default:
            break;
    }
}

- (void)reFreshNewsContent {
    if (!isNeedLoad) {
        return;
    }
    NSMutableDictionary *newsdataDic = [[ZSSourceModel defaultSource] newsDataDic];
    if (_newsItemDic) {
        [_newsItemDic release];
    }
    
    _newsItemDic = [[NSMutableDictionary alloc] initWithDictionary:newsdataDic];
    [newsTitle setText:[_newsItemDic objectForKey:@"newsTitle"]];
    CGRect titleFrame = [newsTitle frame];
    CGSize titleSize = [newsTitle contentSize];
    [newsTitle setFrame:CGRectMake(titleFrame.origin.x, titleFrame.origin.y, titleSize.width, titleSize.height)];
    [newsTitle setCenter:CGPointMake(160, 63)];
    
    NSString *dateString = [_newsItemDic objectForKey:@"newsCreatetime"];
    NSMutableString *secondTitle = [[NSMutableString alloc] init];
    if ([dateString isKindOfClass:[NSString class]]) {
        if ([dateString length] > 16) {
            NSString *datePre = [dateString substringToIndex:10];
            NSString *dateTail = [dateString substringWithRange:NSMakeRange(11, 5)];
            [secondTitle appendString:[NSString stringWithFormat:@"%@ %@",datePre, dateTail]];
        }
    }
    NSString *sourceString = [_newsItemDic objectForKey:@"newsSfrom"];
    if (sourceString && [sourceString isKindOfClass:[NSString class]] && [sourceString length] > 0) {
        [secondTitle appendString:@"  来源： "];
        [secondTitle appendString:sourceString];
    }
    [newsSecondTitle setText:secondTitle];
    [secondTitle release];
    
    
    UIImage *image = nil;
    
    NSString *bodyString = [_newsItemDic objectForKey:@"newsContent"];
    if ([bodyString isKindOfClass:[NSString class]]) {
        NSString *htmlString=nil;
        NSString *newsVideoUrl = [_newsItemDic objectForKey:@"newsVideoUrl"];
        if([[_newsItemDic objectForKey:@"newsClassify"] intValue]==2 && newsVideoUrl!=nil &&newsVideoUrl.length>10){
            NSString *embedHTML = [NSString stringWithFormat:@"<video width=\"300\" height=\"200\" poster=\"%@\" autoplay=\"autoplay\" autobuffer=\"autobuffer\" loop=\"loop\">\
                                   <source src=\"%@\" type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'>\
                                   </video>",[NSString stringWithFormat:@"%@%@",Web_URL ,[_newsItemDic objectForKey:@"newsSpicture"]],newsVideoUrl];
            
            htmlString= [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@\n%@</body> \n </html>", _newFontSize,_newFontSize+10,embedHTML,bodyString];
        }else{
            htmlString= [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@</body> \n </html>", _newFontSize,_newFontSize+10,bodyString];
            
        }
        [newsWebView loadHTMLString:htmlString baseURL:nil];
    }

    
    NSMutableArray  *array = [_newsItemDic objectForKey:@"rbNewspics"];
//    NSString *newsVideoUrl = [_newsItemDic objectForKey:@"newsVideoUrl"];
    
//    if([[_newsItemDic objectForKey:@"newsClassify"] intValue]==2 && newsVideoUrl!=nil &&newsVideoUrl.length>10){
//        [newsImageView setAlpha:0];
//        [btnClickImage setEnabled:NO];
//        //[webview setAlpha:1];
//        
//        ///webview=[[UIWebView alloc] initWithFrame:CGRectMake(10, 123, 300, 200)];
//        
//        NSString *embedHTML = [NSString stringWithFormat:@"<video width=\"300\" height=\"200\" poster=\"%@\" autoplay=\"autoplay\" autobuffer=\"autobuffer\" loop=\"loop\">\
//                               <source src=\"%@\" type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'>\
//                               </video>",[NSString stringWithFormat:@"%@%@",Web_URL ,[_newsItemDic objectForKey:@"newsSpicture"]],newsVideoUrl];
//        
//        [webview setOpaque:NO];
//        NSString *html = [NSString stringWithFormat:embedHTML, webview.frame.size.width, webview.frame.size.height];
//        [webview loadHTMLString:html baseURL:nil];
//        
//        
//        [newsWebView setFrame:CGRectMake(5, webview.frame.origin.y+webview.frame.size.height+5, 310, 200)];
//        
//    }
//    else
    
    //if([[_newsItemDic objectForKey:@"newsClassify"] intValue]==1 && array && [array count] > 0){
    if(array && [array count] > 0){    
        NSString *imageUrlString = [[array objectAtIndex:0] objectForKey:@"newspic"];
        image = [imageQueue getImageForURL:[NSString stringWithFormat:@"%@%@",Web_URL ,imageUrlString]];
        [_imageUrlArray removeAllObjects];
        [_imageUrlArray addObjectsFromArray:array];
        if (image == nil) {
            image = [UIImage imageNamed:@"home_image_loading"];
            [imageQueue addOperationToQueueWithURL:[NSString stringWithFormat:@"%@%@",Web_URL ,imageUrlString] atIndex:itemId];
        }
        else {
            CGRect imageFrame = newsImageView.frame;
            if (image.size.width > imageFrame.size.width) {
                imageFrame.size.height = image.size.height*imageFrame.size.width*1.0/image.size.width;
            }
            else {
                imageFrame.size.height = image.size.height;
            }
            [newsImageView setFrame:imageFrame];
            [newsImageView setAlpha:1];
            [newsImageView setImage:image];
            [btnClickImage setEnabled:YES];
            [btnClickImage setFrame:imageFrame];
            [newsImageView setContentMode:UIViewContentModeScaleAspectFit];
            [newsWebView setFrame:CGRectMake(5, imageFrame.origin.y+imageFrame.size.height+5, 310, 200)];
        }
        
    }else{
        [newsImageView setAlpha:0];
        [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+136)];
        [btnClickImage setEnabled:NO];
    }
    
}

#pragma mark - Xib Function
- (IBAction)clickBigImage:(id)sender {
    if (_imageUrlArray==nil || [_imageUrlArray count]==0) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [bigImageView.view setTransform:CGAffineTransformMakeScale(.1, .1)];
    [window addSubview:bigImageView.view];
    [bigImageView setImageArray:_imageUrlArray];
    [UIView animateWithDuration:.2 animations:^{
        [bigImageView.view setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    }completion:^(BOOL finish) {
        [UIView animateWithDuration:.1 animations:^{
            [bigImageView.view setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
    }];
}

#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    CGRect imageFrame = newsImageView.frame;
    if (_image.size.width > imageFrame.size.width) {
        imageFrame.size.height = _image.size.height*imageFrame.size.width*1.0/_image.size.width;
    }
    else {
        imageFrame.size.height = _image.size.height;
    }
    [newsImageView setFrame:imageFrame];
    [newsImageView setAlpha:1];
    [newsImageView setImage:_image];
    [btnClickImage setEnabled:YES];
    [btnClickImage setFrame:imageFrame];
    [newsImageView setContentMode:UIViewContentModeScaleAspectFit];
    CGRect frame = newsWebView.frame;
    [newsWebView setFrame:CGRectMake(5, imageFrame.origin.y+imageFrame.size.height+5, frame.size.width, frame.size.height)];
    frame = newsWebView.frame;
    [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+frame.size.height + 80)];
    [newsBgScrollView setScrollEnabled:YES];
}

- (void)imageOperationWrongImagePath:(NSInteger)_index {
    CGRect frame = newsWebView.frame;
    [self performSelectorOnMainThread:@selector(setImageViewAlpha0) withObject:nil waitUntilDone:NO];
    [newsWebView setFrame:CGRectMake(5, 259-136, frame.size.width, frame.size.height)];
    [btnClickImage setEnabled:NO];
}

#pragma mark - MPBigImageDelegate
- (void)MPBigImageCloseBigImageView {
    [bigImageView.view removeFromSuperview];
}

#pragma mark WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //if([webView isEqual:webview]){
        [activityIndicator startAnimating];
   // }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //if([webView isEqual:webview]){
        [activityIndicator stopAnimating];
   // }
    
    //CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    @synchronized(self) {
        //something like this
        //usleep(4000);
        CGRect frame = newsWebView.frame;
        [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 200)];
        CGSize textSize = [webView sizeThatFits:CGSizeZero];
        [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
        [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height)];
        [newsBgScrollView setScrollEnabled:YES];
        [self setRefreshFooterView];
    }
    
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
}



#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    //[self loadNewsList:nowNewStyle];
    CGRect frame = newsWebView.frame;
    [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 200)];
    CGSize textSize = [newsWebView sizeThatFits:CGSizeZero];
    [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
    [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height)];
    [newsBgScrollView setScrollEnabled:YES];
    [self setRefreshFooterView];
}

@end
