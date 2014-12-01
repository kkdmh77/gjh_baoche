//
//  MoreVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "MoreCell.h"
#import "MoreKeepVC.h"
#import "MoreReadModelVC.h"
#import "MoreAboutVC.h"
#import "MoreOrderChannelVC.h"
#import "MoreLoginVC.h"

@protocol MoreVCDelegate;

@interface MoreVC : UIViewController<UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate,MoreAboutVCDelegate, MoreKeepVCDelegate, MoreLoginVCDelegate, MoreOrderChannelVCDelegate, MoreReadModelVCDelegate> {
    NSMutableArray *imageArray;
    NSMutableArray *labelArray;
    MoreCell IBOutlet *_moreCell;
    MoreKeepVC *_moreKeep;
    ImageLoaderQueue *imageQueue;
}

@property (nonatomic, retain) NSMutableArray *adsArray;
@property (nonatomic, assign) id<MoreVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *moreTableView;
- (IBAction)clickSelectItem:(id)sender;

@end

@protocol MoreVCDelegate <NSObject>

@optional
- (void)MoreVCChooseItem;
- (void)MoreVCHideTarBar:(BOOL)isHide;

@end



