//
//  RegesterViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-28.
//
//

#import "RegesterViewController.h"
#import "CommonUtil.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "ZSSourceModel.h"

@interface RegesterViewController (){
   
    LoginModel *loginmodel;
}

 -(void)loginSuccess;
@end

@implementation RegesterViewController
@synthesize usertext,pwdtext,phonetext,comferpwdtext,sexboybtn,sexgirlbtn;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    
    //[loginmodel release];
   // [RadioButton addObserverForGroupId:@"first group" observer:self];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [pwdtext setSecureTextEntry:YES];
    [comferpwdtext setSecureTextEntry:YES];
    [sexboybtn setSelected:YES];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:Notification_loginSucces object:nil];
      // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickSexboy:(id)sender{
    [sexboybtn setSelected:YES];
    [sexgirlbtn setSelected:NO];
}

- (IBAction)clickSexgir:(id)sender{
    [sexgirlbtn setSelected:YES];
    [sexboybtn setSelected:NO];
}


- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doEditFieldDone:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)clickResgist:(id)sender{
    [usertext resignFirstResponder];
    [phonetext resignFirstResponder];
    [pwdtext resignFirstResponder];
    [comferpwdtext resignFirstResponder];
    
    loginmodel = [[LoginModel alloc] init];
    if([usertext.text isEqual:@""]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"用户名不能为空！" detail:@""];
        return;
        
    }else if([pwdtext.text isEqual:@""]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"密码不能为空！" detail:@""];
        return;
        
    }else if(![pwdtext.text isEqual:comferpwdtext.text]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"两次输入的密码不一样！" detail:@""];
        return;
        
    }else{
        [loginmodel setLoginuser:usertext.text];
        [loginmodel setLoginpassword:pwdtext.text];
        [loginmodel setLoginphone:phonetext.text];
        int sex=1;
        if (sexboybtn.isSelected) {
            sex=1;
        }else{
            sex=0;
        }
        [loginmodel setLoginsex:[NSString stringWithFormat:@"%d", sex]];
        [loginmodel getRegister];
    }
    
}


- (void)loginSuccess{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate alertTishiSucc:@"注册成功" detail:@""];
    if(delegate && [delegate respondsToSelector:@selector(RegesterSuccesGoTo)]){
        [delegate RegesterSuccesGoTo];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
