//
//  RegisterVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "RegisterVC.h"
#import "FlatUIKit.h"

@interface RegisterVC ()

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
    
}

@end
