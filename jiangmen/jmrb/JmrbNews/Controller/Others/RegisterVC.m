//
//  RegisterVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "RegisterVC.h"
#import "FlatUIKit.h"
#import "RegisterBC.h"
#import "LoginBC.h"

@interface RegisterVC ()
{
    RegisterBC  *_registerBC;
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet FUITextField *userNameTF;
@property (weak, nonatomic) IBOutlet FUITextField *genderBGTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet FUITextField *mobilePhoneNumTF;

@property (weak, nonatomic) IBOutlet FUITextField *passwordTF;
@property (weak, nonatomic) IBOutlet FUITextField *passwordConfirmTF;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _registerBC = [[RegisterBC alloc] init];
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"注册"];
    [self setup];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[FUITextField class]])
        {
            FUITextField *textField = (FUITextField *)subView;
            
            [textField addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.backgroundColor = HEXCOLOR(0XF7F7F7);
        }
    }
    
    _userNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghuming"]];
    _genderBGTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xingbie"]];
    _mobilePhoneNumTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shoujihaoma"]];
    _passwordTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    _passwordConfirmTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zaicishurumima"]];
    
    _manBtn.selected = YES;
    
    _registerBtn.backgroundColor = Common_BlueColor;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickManBtn:(UIButton *)sender
{
    _womenBtn.selected = NO;
    _manBtn.selected = YES;
}

- (IBAction)clickWomenBtn:(UIButton *)sender
{
    _manBtn.selected = NO;
    _womenBtn.selected = YES;
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    /*
     userName ：用户名
     userPassword  ：密码
     userPhone  ：  联系电话
     userSex：用户的性别
     1，表示男，0表示女
     */
    WEAKSELF
    [_registerBC registerWithNormalUserName:_userNameTF.text
                                     gender:_manBtn.selected ? @"1" : @"0"
                             mobilePhoneNum:_mobilePhoneNumTF.text
                                   password:_passwordTF.text
                            passwordConfirm:_passwordConfirmTF.text
                              successHandle:^(id successInfoObj) {
                                  
                                  [weakSelf loginWithUserName:_userNameTF.text
                                                     password:_passwordTF.text];
    } failedHandle:^(NSError *error) {
        
    }];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    /*
     userName ：用户名
     userPassword  ：密码
     */
    WEAKSELF
    [_loginBC loginWithUserName:userName
                       password:password
                      autoLogin:YES
                  successHandle:^(id successInfoObj) {
                      
                      [UserInfoModel setUserDefaultLoginName:userName];
                      [weakSelf.navigationController dismissViewControllerAnimated:YES
                                                                        completion:nil];
        
    } failedHandle:^(NSError *error) {
        
    }];
}

@end
