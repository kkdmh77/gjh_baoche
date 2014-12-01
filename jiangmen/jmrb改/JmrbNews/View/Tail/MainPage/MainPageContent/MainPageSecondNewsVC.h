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

@protocol MainPageSecondNewsVCDelegate;

@interface MainPageSecondNewsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate, MainPageNewInfoDetailDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    NSInteger nowNewStyle;
}

@property (nonatomic, assign) id<MainPageSecondNewsVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) IBOutlet NewsCell *newsCell;

- (void)loadNewsList:(NSInteger)typeId;

@end

@protocol MainPageSecondNewsVCDelegate <NSObject>

@optional
- (void)MainPageSecondNewsGotoNewDetail:(NSInteger) itemId;
- (void)MainPageSecondNewsSetNewsInfoArray:(NSArray *)secondNewsArray;

@end
