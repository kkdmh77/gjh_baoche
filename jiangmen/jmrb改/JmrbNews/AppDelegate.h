//
//  AppDelegate.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import <UIKit/UIKit.h>
#import "RootManager.h" 
#import "MBProgressHUD.h"
#import "ImageLoaderQueue.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,ImageLoaderQueueDelegate> {
    RootManager *_rootManager;
    UIView *_loadingView;
    UIActivityIndicatorView *_activityView;
    NSInteger loadingNum;
//    NSInteger startLoadNum;
    UIImageView *_loadBgImageView;
    BOOL _isEverLoad;
    MBProgressHUD *hud;
    ImageLoaderQueue *imageQueue;
    NSDate * startnsDate;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger startLoadNum;

- (void)tarBarStartLoading;
- (void)startLoading;
- (void)stopLoading;
- (BOOL)isLoading;
- (void) alertTishi:(NSString *) title detail:(NSString *) detail;
- (void) alertTishiSucc:(NSString *) title detail:(NSString *) detail;
@end
