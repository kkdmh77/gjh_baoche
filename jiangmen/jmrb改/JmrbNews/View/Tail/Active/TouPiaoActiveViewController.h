//
//  TouPiaoActiveViewController.h
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import <UIKit/UIKit.h>
#import "ImageLoaderQueue.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "TouPiaoCell.h"

@interface TouPiaoActiveViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ImageLoaderQueueDelegate, UIScrollViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>{
    
    
    NSMutableArray *newsArray;
    ImageLoaderQueue *imageQueue;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
    
}


@property (nonatomic, assign) IBOutlet UITableView *newsTableView;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickBaoLiao:(id)sender;

@end
