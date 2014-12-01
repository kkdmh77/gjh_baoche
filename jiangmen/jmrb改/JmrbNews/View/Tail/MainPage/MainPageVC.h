//
//  MainPageVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageNavigationBar.h"
#import "MainPageNewInfoDetail.h"
#import "MainPageSecondNewsListVC.h"
#import "MainPageAdsInfoDetail.h"
#import "MainPageFirstNewsListVC.h"

@protocol MainPageDelegate;

@interface MainPageVC : UIViewController <MainPageAdsInfoDetailDelegate, MainPageSecondNewsListVCDelegate,MainPageNavigationBarDelegate, MainPageFirstNewsListVCDelegate> {
    NSInteger _oldSelectItem;
    MainPageNavigationBar *_navigationBar;
    MainPageFirstNewsListVC *_firstNewsVC;
    MainPageSecondNewsListVC *_secondNewsVC;
    
    MainPageNewInfoDetail *_newInfo;
    MainPageAdsInfoDetail *_adsInfo;
    
    NSInteger firstId;
    NSInteger currentId;
    NSInteger nowNewsStyle;
    NSString *titleString;
    NSMutableArray *typeArray;
    
}

@property (nonatomic, assign) id<MainPageDelegate> delegate;

- (void)initUIDate;

@end

@protocol MainPageDelegate <NSObject>

@optional 
- (void)mainPageHideTarBar:(BOOL) isHide;

@end

