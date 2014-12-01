//
//  LoginViewController.h
//  JmrbNews
//
//  Created by dean on 12-11-23.
//
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate;

@interface LoginViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
}


@property (nonatomic, assign) id<LoginViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITextField *usertext;
@property (nonatomic, assign) IBOutlet UITextField *pwdtext;
@property (nonatomic, assign) IBOutlet UIButton *camerabut;
@property (nonatomic, assign) IBOutlet UIImageView *userimage;
@property (nonatomic, assign) IBOutlet UIButton *loginbut;
@property (nonatomic, assign) IBOutlet UIButton *registerbut;



- (IBAction)clickBack:(id)sender;
- (IBAction)clickLogin:(id)sender;
- (IBAction)doEditFieldDone:(id)sender ;
- (IBAction)clickCamera:(id)sender;

@end

@protocol LoginViewDelegate <NSObject>

@optional
- (void)LoginSuccesGoTo;

@end
