//
//  LoginVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "LoginVC.h"
#import "FlatUIKit.h"
#import "RegisterVC.h"
#import "LoginBC.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"

@interface LoginVC ()
{
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet UIView *inputBgView;
@property (weak, nonatomic) IBOutlet FUITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"close"]
                            highlightedImg:nil
                                    action:@selector(backViewController)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"登录"];
    [self setup];
}

- (void)configureViewsProperties
{
    [_inputBgView setRadius:5];
    [_inputBgView addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:1];
   
    [_userNameLabel addLineWithPosition:ViewDrawLinePostionType_Bottom
                       startPointOffset:0
                         endPointOffset:0
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    
    _userNameLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _userNameLabel.leftViewMode = UITextFieldViewModeAlways;
    _userNameLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userName"]];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.text = [UserInfoModel getUserDefaultLoginName];
    
    _passwordLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _passwordLabel.leftViewMode = UITextFieldViewModeAlways;
    _passwordLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    _passwordLabel.backgroundColor = [UIColor clearColor];
    _passwordLabel.text = [UserInfoModel getUserDefaultPassword];
    
    _loginBtn.backgroundColor = Common_ThemeColor;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setRadius:3];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickLoginBtn:(UIButton *)sender
{
    /*
     userName ：用户名
     userPassword  ：密码
     */
    WEAKSELF
    [_loginBC loginWithUserName:_userNameLabel.text
                       password:_passwordLabel.text
                      autoLogin:YES
                        showHUD:YES
                  successHandle:^(id successInfoObj) {
                      
                      [UserInfoModel setUserDefaultLoginName:_userNameLabel.text];
                      [UserInfoModel setUserDefaultPassword:_passwordLabel.text];
                      
                      [self presentViewController:SharedAppDelegate.baseTabBarController modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:^{
                          
                      }];
                      
                  } failedHandle:^(NSError *error) {
                      
    }];
}

@end
