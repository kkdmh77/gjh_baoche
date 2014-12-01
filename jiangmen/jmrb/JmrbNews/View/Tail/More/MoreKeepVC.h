//
//  MoreKeepVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageNewInfoDetail.H"
@protocol MoreKeepVCDelegate;

@interface MoreKeepVC : UIViewController<UITableViewDelegate, UITableViewDataSource,MainPageNewInfoDetailDelegate> {
    
    NSMutableArray *_keepArray;
    MainPageNewInfoDetail *_newInfo;
}

@property (nonatomic, assign) id<MoreKeepVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *keepTableView;

- (IBAction)clickBack:(id)sender;

@end

@protocol MoreKeepVCDelegate <NSObject>

@optional
- (void)MoreKeepHideTarBar:(BOOL)isHide;
- (void)MoreDetailGoBack;

@end

