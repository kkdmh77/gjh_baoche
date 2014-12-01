//
//  PictureShowView2VC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSV2Cell.h"
#import "ImageLoaderQueue.h"

@protocol PictureShowView2VCDelegate;

@interface PictureShowView2VC : UIViewController <ImageLoaderQueueDelegate, UIScrollViewDelegate>{
    ImageLoaderQueue *imageQueue;
    NSMutableArray *_pictureNewsArray;
    BOOL isLoading;
}

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) id<PictureShowView2VCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIScrollView *showScrollView;

- (void)clearPictureData;

@end

@protocol PictureShowView2VCDelegate <NSObject>

@optional

- (void)PictureShowViewClickNew:(NSInteger) newsId pictureNewsArray:(NSArray *)PNArray;

@end
