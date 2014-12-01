//
//  MPDiscussVC.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSDiscussVC : UIViewController<UIAlertViewDelegate, UITextViewDelegate> {
    UITextView *_discussTextView;
    UIView *_discussView;
    NSInteger _newsId;
    UILongPressGestureRecognizer *_hideKeyBoardGesture;
    UIButton *btnSendDiscuss;
}

@property (nonatomic, assign) IBOutlet UIScrollView *discussScrollView;
@property (nonatomic, assign) IBOutlet UILabel *lblAccountName;
@property (nonatomic, assign) IBOutlet UIView *lineView;

- (IBAction)clickChangeAccount:(id)sender;
- (IBAction)clickDiscuss:(id)sender;
- (IBAction)clickBack:(id)sender;
- (void)setNewsIdDiscuss:(NSInteger )newsId;

@end
