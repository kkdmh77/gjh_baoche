//
//  PicViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "RefreshTextView.h"
#import "MainPageNewInfoDetail.h"
#import "PictureNewInfoDetail.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "PicListCell.h"

@protocol PicViewDelegate;

@interface PicViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ImageLoaderQueueDelegate, UIScrollViewDelegate,MainPageNewInfoDetailDelegate,PictureNewInfoDetailDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>{
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;

    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;


}

@property (nonatomic, assign) id<PicViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
- (IBAction)clickRefresh:(id)sender;


@end


@protocol PicViewDelegate <NSObject>

@optional
- (void)PictureNewHideTarBar:(BOOL)isHide;

@end
