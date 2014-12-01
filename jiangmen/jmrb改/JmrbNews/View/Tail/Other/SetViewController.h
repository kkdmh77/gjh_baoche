//
//  SetViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-22.
//
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "RegesterViewController.h"
#import "UserInfoViewController.h"
#import "MoreKeepVC.h"

@interface SetViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,LoginViewDelegate,RegesterViewDelegate>{
    
}


@property (nonatomic, assign) IBOutlet UITableView *newsTableView;
- (IBAction)clickBack:(id)sender;

@end
