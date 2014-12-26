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
    [self setNavigationItemTitle:@"注册新用户"];
    [self setup];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[FUITextField class]])
        {
            FUITextField *textField = (FUITextField *)subView;
            
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
        }
    }
    
    [_userNameTF addLineWithPosition:ViewDrawLinePostionType_Top
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_userNameTF addLineWithPosition:ViewDrawLinePostionType_Bottom
                       startPointOffset:10
                         endPointOffset:0
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_passwordConfirmTF addLineWithPosition:ViewDrawLinePostionType_Bottom
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    [_passwordConfirmTF addLineWithPosition:ViewDrawLinePostionType_Top
                    startPointOffset:10
                      endPointOffset:0
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    
    _userNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    _passwordTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    _passwordConfirmTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    
    _registerBtn.backgroundColor = Common_ThemeColor;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setRadius:5];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
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
                      
                      [weakSelf.navigationController dismissViewControllerAnimated:YES
                                                                        completion:nil];
        
    } failedHandle:^(NSError *error) {
        
    }];
}

@end
