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

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIButton *userHeaderImageView;
@property (weak, nonatomic) IBOutlet FUITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginVC

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
    
    [_passwordLabel addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    _passwordLabel.leftViewMode = UITextFieldViewModeAlways;
    _passwordLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    _passwordLabel.backgroundColor = HEXCOLOR(0XF7F7F7);
    
    [_rememberPasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
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
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    RegisterVC *registerVC = [RegisterVC loadFromNib];
    [self pushViewController:registerVC];
}

@end
