//
//  VideoViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-12.
//
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "RefreshTextView.h"
#import "MainPageNewInfoDetail.h"
#import "PictureNewInfoDetail.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "AQGridView.h"


@protocol VideoViewDelegate;

@interface VideoViewController : UIViewController<AQGridViewDelegate, AQGridViewDataSource,ImageLoaderQueueDelegate, UIScrollViewDelegate,EGORefreshTableHeaderDelegate,MainPageNewInfoDetailDelegate,PictureNewInfoDetailDelegate,LoadMoreTableFooterDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
    
    
}

@property (nonatomic, retain) AQGridView *gridView;
@property (nonatomic, assign) id<VideoViewDelegate> delegate;


- (IBAction)clickRefresh:(id)sender;


@end

@protocol VideoViewDelegate <NSObject>

@optional
- (void)PictureNewHideTarBar:(BOOL)isHide;

@end