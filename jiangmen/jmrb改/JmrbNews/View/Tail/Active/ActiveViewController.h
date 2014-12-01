//
//  ActiveViewController.h
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import <UIKit/UIKit.h>
#import "PersonNewsVC.h"
#import "BaoLiaoActiveViewController.h"
#import "TouPiaoActiveViewController.h"
#import "AwardViewController.h"


@protocol ActiveViewDelegate;

@interface ActiveViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,BaoLiaoActiveViewDelegate>

@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
@property (nonatomic, assign) id<ActiveViewDelegate> delegate;

- (IBAction)clickBack:(id)sender;

@end

@protocol ActiveViewDelegate <NSObject>

@optional
- (void)ActiveViewHideTarBar:(BOOL)isHide;

@end
