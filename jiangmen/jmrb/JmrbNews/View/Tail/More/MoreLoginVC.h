//
//  MoreLoginVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MoreLoginVCDelegate;

@interface MoreLoginVC : UIViewController

@property (nonatomic, assign) id<MoreLoginVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UILabel *lblAccount, *lblCode;
@property (nonatomic, assign) IBOutlet UITextField *accountField, *codeField;
@property (nonatomic, assign) IBOutlet UILabel *lblAccountName; 
@property (nonatomic, assign) IBOutlet UIButton *btnLogOut, *btnLogIn;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickLogin:(id)sender;
- (IBAction)clickLogOut:(id)sender;

@end

@protocol MoreLoginVCDelegate <NSObject>
@optional
- (void)MoreDetailGoBack;

@end