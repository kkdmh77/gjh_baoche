//
//  CheckPhoneViewController.m
//  JmrbNews
//
//  Created by dean on 13-5-28.
//
//

#import "CheckPhoneViewController.h"
#import "ZSSourceModel.h"
#import "LoginModel.h"
#import "CommonUtil.h"
#import "AppDelegate.h"


@interface CheckPhoneViewController (){
    NSDictionary *objectDic;
    LoginModel *loginmodel;
    int randomNum;
}


@end

@implementation CheckPhoneViewController
@synthesize phonetext,vcodeext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [objectDic release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //objectDic=  [[NSDictionary alloc] initWithDictionary:[[ZSSourceModel defaultSource] succLoginDic]];
    //objectDic= [[ZSSourceModel defaultSource] succLoginDic];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    objectDic =  [[NSDictionary alloc] initWithDictionary:[standardUserDefault objectForKey:Key_UserName]];

    [phonetext setText:[objectDic objectForKey:@"userPhone"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSuccess) name:Notification_userscheck object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)checkSuccess{
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate alertTishiSucc:@"" detail:@""];
    //[objectDic setValue:@"1" forKey:@"userVerification"];
    //[objectDic setValue:@"已验证" forKey:@"userVerificationString"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSendsms:(id)sender{
    if([CommonUtil isMobileNumber:phonetext.text]){
        randomNum = arc4random()%1000;
        loginmodel = [[LoginModel alloc] init];
        [loginmodel sendsms:phonetext.text vcode:[NSString stringWithFormat:@"尊敬的江门日报用户，您本次的手机验证码是：%d",randomNum]];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"手机号码不正确." detail:@""];
    }

    
}

- (IBAction)doEditFieldDone:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)clickSubmit:(id)sender{
    if (![vcodeext.text isEqualToString:@""]) {
        if ([vcodeext.text isEqualToString:[NSString stringWithFormat:@"%d",randomNum]]) {
            [loginmodel updateUser:[objectDic objectForKey:@"userId"] userName:[objectDic objectForKey:@"userName"] userPassword:[objectDic objectForKey:@"userPassword"] userPhone:[objectDic objectForKey:@"userPhone"] userSex:[objectDic objectForKey:@"userSex"] userVerification:@"1"];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate alertTishi:@"验证码错误." detail:@""];
        }
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"验证码不能为空." detail:@""];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
