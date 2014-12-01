//
//  MoreAboutVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MoreAboutVCDelegate;

@interface MoreAboutVC : UIViewController

@property (nonatomic, assign) id<MoreAboutVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIWebView *bgWebView;

- (IBAction)clickBack:(id)sender;

@end

@protocol MoreAboutVCDelegate <NSObject>

@optional
- (void)MoreDetailGoBack;

@end