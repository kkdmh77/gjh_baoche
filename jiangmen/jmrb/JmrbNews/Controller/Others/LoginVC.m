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

@interface LoginVC ()
{
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet UIButton *userHeaderImageView;
@property (weak, nonatomic) IBOutlet FUITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

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
                            barButtonTitle:Cancel
                                    action:@selector(backViewController)];
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
    [_userNameLabel addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    _userNameLabel.leftViewMode = UITextFieldViewModeAlways;
    _userNameLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghuming"]];
    _userNameLabel.backgroundColor = HEXCOLOR(0XF7F7F7);
    _userNameLabel.text = [UserInfoModel getUserDefaultLoginName];
    
    [_passwordLabel addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    _passwordLabel.leftViewMode = UITextFieldViewModeAlways;
    _passwordLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    _passwordLabel.backgroundColor = HEXCOLOR(0XF7F7F7);
    _passwordLabel.text = [UserInfoModel getUserDefaultPassword];
    
    [_rememberPasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _rememberPasswordBtn.selected = YES;
    
    _loginBtn.backgroundColor = Common_BlueColor;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    
    _registerBtn.backgroundColor = HEXCOLOR(0XDCDCDC);
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickRememberBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
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
                  successHandle:^(id successInfoObj) {
                      
                      [UserInfoModel setUserDefaultLoginName:_userNameLabel.text];
                      if (weakSelf.rememberPasswordBtn.selected)
                      {
                          [UserInfoModel setUserDefaultPassword:_passwordLabel.text];
                      }
                      
                      [weakSelf backViewController];
                      
                  } failedHandle:^(NSError *error) {
                      
                  }];
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    RegisterVC *registerVC = [RegisterVC loadFromNib];
    [self pushViewController:registerVC];
}

@end
