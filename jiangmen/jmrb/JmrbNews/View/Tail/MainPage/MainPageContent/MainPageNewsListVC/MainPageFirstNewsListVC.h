//
//  MainPageFirstNewsListVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import <UIKit/UIKit.h>
#import "NewsCell.h"
#import "ImageLoaderQueue.h"
#import "MainPageNewInfoDetail.h"
#import "RefreshTextView.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@protocol MainPageFirstNewsListVCDelegate;

@interface MainPageFirstNewsListVC : UIViewController <ImageLoaderQueueDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MainPageNewInfoDetailDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate> {
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    NSInteger nowNewStyle;
    BOOL isNeedLoadNext;
    RefreshTextView *topView, *tailView;
    NSInteger isNeedReload;
    BOOL scrollIsNeedLoadNext;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
}

@property (nonatomic, assign) id<MainPageFirstNewsListVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIScrollView *showAllScrollView;
@property (nonatomic, assign) IBOutlet UIScrollView *adsScrollView;
@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) IBOutlet NewsCell *newsCell;
@property (nonatomic, assign) IBOutlet UILabel *newsAdsTitle;
@property (nonatomic, assign) IBOutlet UIPageControl *pageControl;

- (void)setisNeedLoadNextYes;
- (void)loadNewsList:(NSInteger)typeId;
- (IBAction)clickPageControl:(id)sender;

@end

@protocol MainPageFirstNewsListVCDelegate <NSObject>
@optional

- (void)MainPageFirstNewsListSetNewsInfoArray:(NSArray *)firstNewsArray;
- (void)MainPageFirstNewsListClickNewsItem:(NSInteger)item type:(NSInteger) type;
- (void)MainPageFirstNewsListClickAds:(NSInteger)item;
- (void)MainPageFirstNewsListAdsArray:(NSArray *)adsArray;
- (void)MainPageInfoDetailBack;
- (void)MainPageFirstNewsListChange;

@end
