//
//  RegesterViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"


@protocol RegesterViewDelegate;

@interface RegesterViewController : UIViewController



@property (nonatomic, assign) id<RegesterViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITextField *usertext;
@property (nonatomic, assign) IBOutlet UITextField *phonetext;
@property (nonatomic, assign) IBOutlet UITextField *pwdtext;
@property (nonatomic, assign) IBOutlet UITextField *comferpwdtext;

@property (nonatomic, assign) IBOutlet UIButton *sexboybtn;
@property (nonatomic, assign) IBOutlet UIButton *sexgirlbtn;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickSexboy:(id)sender;
- (IBAction)clickSexgir:(id)sender;
- (IBAction)clickResgist:(id)sender;
- (IBAction)doEditFieldDone:(id)sender ;

@end


@protocol RegesterViewDelegate <NSObject>

@optional
- (void)RegesterSuccesGoTo;

@end