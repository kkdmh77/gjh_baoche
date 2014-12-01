//
//  MPNewInfoDetailContent.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "MPBigImage.h"
#import "LoadMoreTableFooterView.h"

@interface MPNewInfoDetailContent : UIViewController <ImageLoaderQueueDelegate, MPBigImageDelegate, UIWebViewDelegate,LoadMoreTableFooterDelegate,UIScrollViewDelegate> {
//    UIImage *bigImage;
    NSDictionary *_newsItemDic;
    ImageLoaderQueue *imageQueue;
    MPBigImage *bigImageView;
    CGFloat _oldDistence;
    NSInteger _oldFontSize;
    NSInteger _newFontSize;
    BOOL _isFontChanging;
    NSMutableArray *_imageUrlArray;
    UIWebView *newsWebView;
    UIActivityIndicatorView *activityIndicator;
    LoadMoreTableFooterView *_loadMoreView;
}

@property (nonatomic, assign) IBOutlet UIScrollView *newsBgScrollView;
@property (nonatomic, assign) IBOutlet UITextView *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsSecondTitle;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;
@property (nonatomic, assign) IBOutlet UIWebView *newsWebView2;
@property (nonatomic, assign) IBOutlet UISlider *textSlider;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) IBOutlet UIButton *btnClickImage;
@property (nonatomic, assign) BOOL isNeedLoad;

- (void)setTextViewFontSize:(NSInteger) fontSize;

- (void)loadNewsContent:(NSInteger) item;
- (IBAction)clickBigImage:(id)sender;
- (void)clearWebViewContent;

@end
