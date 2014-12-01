//
//  MPBigImage.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
//#import "YReadPictureView.h"

@protocol PicBigImageDelegate <NSObject>

@optional
- (void)PicBigImageCloseBigImageView;

@end

@interface PicBigImage : UIViewController <ImageLoaderQueueDelegate>{
    //YReadPictureView *readPictureView;
    ImageLoaderQueue *imageQueue;
    NSMutableArray *imageURLArray;
}

@property (nonatomic, assign) id<PicBigImageDelegate> delegate;

- (void)setImageArray:(NSArray *)imageArray;

@end
