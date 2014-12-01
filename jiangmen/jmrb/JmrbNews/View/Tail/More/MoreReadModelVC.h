//
//  MoreReadModelVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MoreReadModelVCDelegate;

@interface MoreReadModelVC : UIViewController

@property (nonatomic, assign) id<MoreReadModelVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIImageView *halfImageView, *fullImageView;
@property (nonatomic, assign) IBOutlet UILabel *lblReadModel;

- (IBAction)clickHalfScreen:(id)sender;
- (IBAction)clickFullScreen:(id)sender;
- (IBAction)clickBack:(id)sender;

@end

@protocol MoreReadModelVCDelegate <NSObject>
@optional
- (void)MoreDetailGoBack;

@end