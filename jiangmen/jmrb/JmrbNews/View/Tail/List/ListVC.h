//
//  ListVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
#import "ListSecondNewsListVC.h"
#import "MainPageNewInfoDetail.h"
#import "ImageLoaderQueue.h"

@protocol ListVCDelegate;

@interface ListVC : UIViewController <ListSecondNewsListVCDelegate,UITableViewDataSource, UITableViewDelegate, ImageLoaderQueueDelegate>{
    ImageLoaderQueue *_imageQueue;
    ListCell IBOutlet *_listCell;
    NSMutableDictionary *_secondNewListDic;
    MainPageNewInfoDetail *_newInfo;
    ListSecondNewsListVC *_secondNewsVC;
}

@property (nonatomic, assign) id<ListVCDelegate> delegate;
@property (nonatomic, retain) NSArray *newsCatagoryArray;
@property (nonatomic, assign) IBOutlet UITableView *listTableView;

@end

@protocol ListVCDelegate <NSObject>

@optional
- (void)ListVCHideTarBar:(BOOL) isHide;

@end
