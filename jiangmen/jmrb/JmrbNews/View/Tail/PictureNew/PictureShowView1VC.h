//
//  PictureShowView1VC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AFOpenFlowView.h"


#import "ImageLoaderQueue.h"

@protocol PictureShowView1Delegate;

@interface PictureShowView1VC : UIViewController<ImageLoaderQueueDelegate> {
    //OpenFlowView *_openFlowView;
    NSMutableArray *covers;
    NSMutableArray *titles;
    NSMutableArray *contents;
    int whichItem;
    ImageLoaderQueue *imageQueue;
    NSMutableArray *_pictureNewsArray;
    BOOL isLoading;
    NSInteger requestNum;
    NSMutableDictionary *urlDic;
}

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) id<PictureShowView1Delegate> delegate;
@property (nonatomic, assign) IBOutlet UILabel *lblTitle;
@property (nonatomic, assign) IBOutlet UITextView *tvContent;

- (void)clearPictureData;

@end

@protocol PictureShowView1Delegate <NSObject>

@optional
- (void)PictureShowViewClickNew:(NSInteger) newsId pictureNewsArray:(NSArray *)PNArray;

@end


