//
//  CheckPhoneViewController.h
//  JmrbNews
//
//  Created by dean on 13-5-28.
//
//

#import <UIKit/UIKit.h>

@interface CheckPhoneViewController : UIViewController




@property (nonatomic, assign) IBOutlet UITextField *phonetext;
@property (nonatomic, assign) IBOutlet UITextField *vcodeext;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickSendsms:(id)sender;
- (IBAction)doEditFieldDone:(id)sender ;
- (IBAction)clickSubmit:(id)sender ;

@end
