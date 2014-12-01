//
//  MPAdsInfoDetailContent.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MPAdsInfoDetailContent.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MPAdsInfoDetailContent ()

- (void)reFreshNewsContent;
- (void)pinGestureBack:(UIPinchGestureRecognizer *)recognizer;
- (void)setFontIsChangeNO;
- (void)setImageViewAlpha0;

@end

@implementation MPAdsInfoDetailContent
@synthesize newsWebView;
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
}

- (void)setTextViewFontSize:(NSInteger) fontSize {
    @synchronized ([MPAdsInfoDetailContent class]) {
        if (_isFontChanging == YES) {
            return;
        }
        _isFontChanging = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",fontSize] forKey:Font_NewsInfoContent];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [newsTitle setFont:[UIFont systemFontOfSize:fontSize]];
        [newsSecondTitle setFont:[UIFont systemFontOfSize:10+(fontSize-17)/3]];
        
        if (_newsItemDic) {
            NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize = %i;document.body.style.lineHeight = %f",fontSize, 1.5];
            [newsWebView stringByEvaluatingJavaScriptFromString:jsString];
            [jsString release];
            
            CGRect frame = newsWebView.frame;
            [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 200)];
            CGSize textSize = [newsWebView sizeThatFits:CGSizeZero];
            [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
            [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height + 80)];
            [newsBgScrollView setScrollEnabled:YES];
            
            [self performSelector:@selector(setFontIsChangeNO) withObject:nil afterDelay:.5];
        }
    }
}

#pragma mark - system
- (void)dealloc {
    [_imageUrlArray release];
    [_newsItemDic release];
    [bigImageView release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //    if (self) {
    //        // Custom initialization
    //    }
    
    if (iPhone5) {
        self = [[super initWithNibName:@"MPAdsInfoDetailContent-5" bundle:nibBundleOrNil]autorelease];
    }
    else
    {
        self = [[super initWithNibName:@"MPAdsInfoDetailContent" bundle:nibBundleOrNil] autorelease];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isNeedLoad = YES;
    _isFontChanging = YES;
    _oldFontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:Font_NewsInfoContent] intValue];
    ;
    _newFontSize = _oldFontSize;
    [newsSecondTitle setAdjustsFontSizeToFitWidth:YES];
    [self setTextViewFontSize:_newFontSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshNewsContent) name:notification_getNews object:nil];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    
    bigImageView = [[MPBigImage alloc] initWithNibName:@"MPBigImage" bundle:nil];
    [bigImageView setDelegate:self];
    
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureBack:)];
//    [self.view addGestureRecognizer:pinchGesture];
//    [pinchGesture release];
    
    [newsWebView setBackgroundColor:[UIColor clearColor]];
    [newsWebView setDelegate:self];
    [newsWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    
    _imageUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsImageView setAlpha:0];
    [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+156)];
    [btnClickImage setEnabled:NO];
    
    
    for (id subview in newsWebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).scrollEnabled = NO;
    }
    
    
}



- (void)loadNewsContent:(NSInteger) item{
    [newsImageView setAlpha:0];
    [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+156)];
    [btnClickImage setEnabled:NO];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNews forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", item] forKey:Key_News_Item_Content];
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
//    _newsItemDic = [[newsdataDic objectForKey:[NSNumber numberWithInt:itemId]] retain];
    _newsItemDic = [[NSMutableDictionary alloc] initWithDictionary:newsdataDic];
    [newsTitle setText:[_newsItemDic objectForKey:@"newsTitle"]];
    CGRect titleFrame = [newsTitle frame];
    CGSize titleSize = [newsTitle contentSize];
    [newsTitle setFrame:CGRectMake(titleFrame.origin.x, titleFrame.origin.y, titleSize.width, titleSize.height)];
    [newsTitle setCenter:CGPointMake(160, 63)];
    
    NSString *dateString = [_newsItemDic objectForKey:@"newsTime"];
    NSMutableString *secondTitle = [[NSMutableString alloc] init];
    if ([dateString isKindOfClass:[NSString class]]) {
        if ([dateString length] > 16) {
            NSString *datePre = [dateString substringToIndex:10];
            NSString *dateTail = [dateString substringWithRange:NSMakeRange(11, 5)];
            [secondTitle appendString:[NSString stringWithFormat:@"%@ %@",datePre, dateTail]];
        }
    }
    NSString *sourceString = [_newsItemDic objectForKey:@"news_Source"];
    if (sourceString && [sourceString isKindOfClass:[NSString class]] && [sourceString length] > 0) {
        [secondTitle appendString:@"  来源： "];
        [secondTitle appendString:sourceString];
    }
    
    [newsSecondTitle setText:secondTitle];
    [secondTitle release];
    
//    NSString *autherString = [_newsItemDic objectForKey:@"newsAuthor"];
    NSString *bodyString = [_newsItemDic objectForKey:@"newsInfo"];
    if ([bodyString isKindOfClass:[NSString class]]) {
        NSString *htmlString = nil;
//        if (autherString && [autherString isKindOfClass:[NSString class]] && [autherString length] > 0) {
//            htmlString = [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@ (%@)</body> \n </html>", _newFontSize,_newFontSize+10,bodyString,autherString];
//        }
//        else {
            htmlString = [NSString stringWithFormat:@"<html> \n <head> \n <style type=\"text/css\"> \n body {text-align:justify; font-size: %ipx; line-height:%ipx}\n  </style> \n </head> \n <body>%@</body> \n </html>", _newFontSize,_newFontSize+10,bodyString];
//        }
        [newsWebView loadHTMLString:htmlString baseURL:nil];
        NSString *jsString = [NSString stringWithFormat:@"document.body.style.lineHeight = %f", 1.5];
        [newsWebView stringByEvaluatingJavaScriptFromString:jsString];
    }
    
    NSString *imageUrlString = [_newsItemDic objectForKey:@"newsIcon_big"];
    UIImage *image = nil;
    if (imageUrlString && [imageUrlString isKindOfClass:[NSString class]] && [imageUrlString length] > 0) {
        [_imageUrlArray removeAllObjects];
        NSArray *array = [_newsItemDic objectForKey:@"pic_list"];
        if (array && [array count] > 0) {
            [_imageUrlArray addObjectsFromArray:array];
        }
        image = [imageQueue getImageForURL:imageUrlString];
        if (image == nil) {
            image = [UIImage imageNamed:@"home_image_loading"];
            [imageQueue addOperationToQueueWithURL:imageUrlString atIndex:itemId];
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
    }
    else {
        [newsImageView setAlpha:0];
        [newsWebView setFrame:CGRectMake(5, 259-136, 310, 200+136)];
        [btnClickImage setEnabled:NO];
    }
    

}

#pragma mark - Xib Function
- (IBAction)clickBigImage:(id)sender {
    if (_imageUrlArray == nil || [_imageUrlArray count]==0) {
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
    [newsWebView setFrame:CGRectMake(5, 259-136, frame.size.width, frame.size.height)];
}

#pragma mark - MPBigImageDelegate
- (void)MPBigImageCloseBigImageView {
    [bigImageView.view removeFromSuperview];
}

#pragma mark WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = newsWebView.frame;
    [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 310, 200)];
    CGSize textSize = [webView sizeThatFits:CGSizeZero];
    [newsWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
    [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height + 80)];
    [newsBgScrollView setScrollEnabled:YES];
   
}

@end
