//
//  MPNewInfoDetailContent.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "MPBigImage.h"

@interface MPAdsInfoDetailContent : UIViewController <ImageLoaderQueueDelegate, MPBigImageDelegate> {
    UIImage *bigImage;
    ImageLoaderQueue *imageQueue;
    MPBigImage *bigImageView;
    NSInteger _oldFontSize;
    NSInteger _newFontSize;
}

@property (nonatomic, assign) IBOutlet UIScrollView *newsBgScrollView;
@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsSecondTitle;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;
@property (nonatomic, assign) IBOutlet UITextView *newsTextView;

@property (nonatomic, assign) NSInteger itemId;
- (void)setTextViewFontSize:(NSInteger) fontSize;

- (void)loadNewsContent:(NSInteger) item;
- (IBAction)clickBigImage:(id)sender;

@end
