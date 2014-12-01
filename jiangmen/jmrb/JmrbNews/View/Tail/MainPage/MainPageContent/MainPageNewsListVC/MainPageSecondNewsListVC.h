//
//  MainPageSecondNewsVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import <UIKit/UIKit.h>
#import "NewsCell.h"
#import "NewsHeadCell.h"
#import "ImageLoaderQueue.h"
#import "MainPageNewInfoDetail.h"
#import "RefreshTextView.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@protocol MainPageSecondNewsListVCDelegate;

@interface MainPageSecondNewsListVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate, MainPageNewInfoDetailDelegate, UIScrollViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    NSInteger nowNewStyle;
    BOOL isNeedLoadNext;
    UILabel *_lblAds;
    NSInteger currentAdsNewsNum;
    BOOL _isCancelLoad;
    BOOL _isAdsMoving;
    RefreshTextView *topView, *tailView;
    BOOL isNeedReload;
    BOOL scrollIsNeedLoadNext;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;

}

@property (nonatomic, assign) IBOutlet UIView *adsShowView;
@property (nonatomic, assign) id<MainPageSecondNewsListVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) IBOutlet NewsCell *newsCell;
@property (nonatomic, assign) IBOutlet NewsHeadCell *newsHeadCell;
@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

- (IBAction)clickAdsShow:(id)sender;
- (void)loadNewsList:(NSInteger)typeId;
- (IBAction)clickBack:(id)sender;
- (void)adsShowBegin;
- (IBAction)clickRefresh:(id)sender;

@end

@protocol MainPageSecondNewsListVCDelegate <NSObject>

@optional
- (void)MainPageSecondNewsListHideTarBar:(BOOL)isHide;
- (void)MainPageSecondNewsListGoBack;
- (void)MainPageSecondNewsListGotoNewDetail:(NSInteger) itemId;
- (void)MainPageSecondNewsListSetNewsInfoArray:(NSArray *)secondNewsArray;
- (void)MainPageInfoDetailBack;
- (void)MainPageSecondNewsListChange;
- (void)MainPageSecondNewsListChangeBack;

@end
