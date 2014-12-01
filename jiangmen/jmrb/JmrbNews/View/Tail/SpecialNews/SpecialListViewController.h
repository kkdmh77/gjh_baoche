//
//  SpecialListViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "MainPageNewInfoDetail.h"
#import "PictureNewInfoDetail.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "NewsCell.h"


@protocol SpecialListViewDelegate;

@interface SpecialListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ImageLoaderQueueDelegate, UIScrollViewDelegate,MainPageNewInfoDetailDelegate,PictureNewInfoDetailDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
    
     NSInteger nowSpecialId;
}


@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) IBOutlet NewsCell *newsCell;
@property (nonatomic, assign) id<SpecialListViewDelegate> delegate;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickRefresh:(id)sender;

- (void)loadSpecialList:(NSInteger)typeId;
@end

@protocol SpecialListViewDelegate <NSObject>

@optional
- (void)SpecialListListHideTarBar:(BOOL)isHide;

@end


