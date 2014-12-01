//
//  MPNewInfoDetailContent.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "PicBigImage.h"

@interface PictureNewInfoDetailContent : UIViewController <ImageLoaderQueueDelegate,PicBigImageDelegate, UIWebViewDelegate> { 
    NSDictionary *_newsItemDic;
    ImageLoaderQueue *imageQueue;
    PicBigImage *bigImageView;
    NSInteger _oldFontSize;
    NSInteger _newFontSize;
    BOOL _isFontChanging;
    NSMutableArray *_imageUrlArray;
}

@property (nonatomic, assign) IBOutlet UIScrollView *newsBgScrollView;
@property (nonatomic, assign) IBOutlet UITextView *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsSecondTitle;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;
@property (nonatomic, assign) IBOutlet UIWebView *newsWebView;
@property (nonatomic, assign) IBOutlet UIButton *btnClickImage;
@property (nonatomic, assign) BOOL isNeedLoad;

@property (nonatomic, assign) NSInteger itemId;

- (void)loadNewsContent:(NSInteger) item;
- (IBAction)clickBigImage:(id)sender;
- (void)clearWebViewContent;


- (void)setTextViewFontSize:(NSInteger) fontSize;

@end
