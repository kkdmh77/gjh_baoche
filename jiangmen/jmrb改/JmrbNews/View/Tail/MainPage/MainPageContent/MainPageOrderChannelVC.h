//
//  MainPageOrderChannelVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreOrderCell.h"
#import "ImageLoaderQueue.h"

@interface MainPageOrderChannelVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageLoaderQueueDelegate>{
    MoreOrderCell IBOutlet *_moreOrderCell;
    ImageLoaderQueue *_imageQueue;
}

@property (nonatomic, retain) NSArray *newsCatagoryArray;
@property (nonatomic, assign) IBOutlet UITableView *orderTableView;

- (IBAction)clickBack:(id)sender;

@end
