//
//  SpecialViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"

#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "SpecialCell.h"
#import "SpecialListViewController.h"


@protocol SpecialViewDelegate;


@interface SpecialViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ImageLoaderQueueDelegate, UIScrollViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate,SpecialListViewDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
    SpecialListViewController *_specialList;
    
    
}

@property (nonatomic, assign) id<SpecialViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
- (IBAction)clickRefresh:(id)sender;

@end


@protocol SpecialViewDelegate <NSObject>

@optional
- (void)SpecialNewHideTarBar:(BOOL)isHide;

@end