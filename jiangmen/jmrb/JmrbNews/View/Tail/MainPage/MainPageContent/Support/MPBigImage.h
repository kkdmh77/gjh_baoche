//
//  MPBigImage.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "YReadPictureView.h"

@protocol MPBigImageDelegate <NSObject>

@optional
- (void)MPBigImageCloseBigImageView;

@end

@interface MPBigImage : UIViewController <ImageLoaderQueueDelegate,YReadPictureViewDelegate>{
    YReadPictureView *readPictureView;
    ImageLoaderQueue *imageQueue;
    UILabel *titlelaber;
    NSMutableArray *imageURLArray;
}

@property (nonatomic, assign) id<MPBigImageDelegate> delegate;

- (void)setImageArray:(NSArray *)imageArray;

@end
