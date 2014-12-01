//
//  MoreOrderChannelVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreOrderCell.h"
#import "ImageLoaderQueue.h"
@protocol MoreOrderChannelVCDelegate;

@interface MoreOrderChannelVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate>{
    MoreOrderCell IBOutlet *_moreOrderCell;
    ImageLoaderQueue *_imageQueue;
    BOOL _isChangeOrder;
}

@property (nonatomic, assign) id<MoreOrderChannelVCDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *newsCatagoryArray;
@property (nonatomic, assign) IBOutlet UITableView *orderTableView;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickOrderUp:(id)sender;

@end

@protocol MoreOrderChannelVCDelegate <NSObject>
@optional
- (void)MoreDetailGoBack;

@end