//
//  MPNewInfoDetailContent.m
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

@end

@implementation MPAdsInfoDetailContent
@synthesize itemId;
@synthesize newsTitle, newsTextView, newsImageView, newsSecondTitle, newsBgScrollView;

#pragma mark - Public
- (void)setTextViewFontSize:(NSInteger) fontSize {
    [newsTextView setFont:[UIFont systemFontOfSize:fontSize]];
    CGSize textSize = newsTextView.contentSize;
    CGRect frame = newsTextView.frame;
    [newsTextView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
    [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height + 80)];
}

#pragma mark - system
- (void)dealloc {
    [bigImageView release];
    [bigImage release];
    [imageQueue cancelQueue];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _oldFontSize = 17;
    _newFontSize = 17;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshNewsContent) name:notification_getAds object:nil];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [newsTextView setBackgroundColor:[UIColor clearColor]];
    
    bigImageView = [[MPBigImage alloc] initWithNibName:@"MPBigImage" bundle:nil];
    [bigImageView setDelegate:self];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureBack:)];
    [self.view addGestureRecognizer:pinchGesture];
    [pinchGesture release];
}

- (void)loadNewsContent:(NSInteger) item{
    self.itemId = item;
    [self reFreshNewsContent];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dic setObject:Web_getNews forKey:Web_Key_urlString];
//    [dic setObject:[NSNumber numberWithInt:item] forKey:Key_News_Item_Content];
//    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//    [dic release];
}

#pragma mark - Private
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
                if (_newFontSize > 22) {
                    _newFontSize = 22;
                }
                [self setTextViewFontSize:_newFontSize];
            }
            break;
        default:
            break;
    }
}

- (void)reFreshNewsContent {
    NSMutableDictionary *newsdataDic = [[ZSSourceModel defaultSource] adsDataDic];
    NSDictionary *responseDic = [newsdataDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    NSDictionary *itemDic = nil;
    for (int i = 0; i < [itemArray count]; i++) {
        itemDic = [itemArray objectAtIndex:i];
        NSInteger adId = [[itemDic objectForKey:@"ad_id"] intValue];
        if (adId == itemId) {
            break;
        }
    }
    if (itemDic == nil) {
        return;
    }
    [newsTitle setText:[itemDic objectForKey:@"ad_name"]];
    
    NSString *dateString = [itemDic objectForKey:@"ad_createtime"];
    if ([dateString length] > 16) {
        NSString *datePre = [dateString substringToIndex:9];
        NSString *dateTail = [dateString substringWithRange:NSMakeRange(11, 5)];
        [newsSecondTitle setText:[NSString stringWithFormat:@"%@ %@",datePre, dateTail]];
    }
    
    [newsTextView setText:[itemDic objectForKey:@"ad_content"]];
    UIImage *image = [imageQueue getImageForURL:[itemDic objectForKey:@"ad_src"]];
    if (image == nil) {
        image = [UIImage imageNamed:@"Icon"];
        [imageQueue addOperationToQueueWithURL:[itemDic objectForKey:@"ad_src"] atIndex:itemId];
    }
    [newsImageView setImage:image];
    if (bigImage) {
        [bigImage release];
    }
    bigImage = [image retain];
    [newsImageView setContentMode:UIViewContentModeScaleAspectFit];
    CGSize textSize = newsTextView.contentSize;
    CGRect frame = newsTextView.frame;
    [newsTextView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize.height)];
    [newsBgScrollView setContentSize:CGSizeMake(320, frame.origin.y+textSize.height + 80)];
    [newsBgScrollView setScrollEnabled:YES];
}

#pragma mark - Xib Function
- (IBAction)clickBigImage:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [bigImageView.view setTransform:CGAffineTransformMakeScale(.1, .1)];
    [window addSubview:bigImageView.view];
    [bigImageView.imageView setImage:bigImage];
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
    [newsImageView setImage:_image];
    if (bigImage) {
        [bigImage release];
    }
    bigImage = [_image retain];
    [bigImageView.imageView setImage:bigImage];
}

#pragma mark - MPBigImageDelegate
- (void)MPBigImageCloseBigImageView {
    [bigImageView.view removeFromSuperview];
}

@end
