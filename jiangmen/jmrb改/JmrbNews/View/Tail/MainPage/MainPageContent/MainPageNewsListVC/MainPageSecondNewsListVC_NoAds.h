//
//  MainPageSecondNewsVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCell.h"
#import "ImageLoaderQueue.h"
#import "MainPageNewInfoDetail.h"

@protocol MainPageSecondNewsListVCDelegate;

@interface MainPageSecondNewsListVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate, MainPageNewInfoDetailDelegate, UIScrollViewDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    NSInteger nowNewStyle;
    BOOL isNeedLoadNext;
    UILabel *_lblAds;
    NSInteger currentAdsNewsNum;
    BOOL _isCancelLoad;
    BOOL _isAdsMoving;
}

@property (nonatomic, assign) id<MainPageSecondNewsListVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) IBOutlet NewsCell *newsCell;
@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

- (void)loadNewsList:(NSInteger)typeId;
- (IBAction)clickBack:(id)sender;
- (void)adsShowBegin;

@end

@protocol MainPageSecondNewsListVCDelegate <NSObject>

@optional
- (void)MainPageSecondNewsListHideTarBar:(BOOL)isHide;
- (void)MainPageSecondNewsListGoBack;
- (void)MainPageSecondNewsListGotoNewDetail:(NSInteger) itemId;
- (void)MainPageSecondNewsListSetNewsInfoArray:(NSArray *)secondNewsArray;
- (void)MainPageInfoDetailBack;

@end
