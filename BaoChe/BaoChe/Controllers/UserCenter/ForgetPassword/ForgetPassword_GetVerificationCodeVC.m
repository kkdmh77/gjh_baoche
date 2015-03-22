//
//  ForgetPassword_GetVerificationCodeVC.m
//  Sephome
//
//  Created by swift on 15/1/11.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "ForgetPassword_GetVerificationCodeVC.h"
#import "NITextField.h"
#import "StringJudgeManager.h"
#import "ForgetPassword_InputVerificationCodeVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface ForgetPassword_GetVerificationCodeVC ()
{
    
}

@property (weak, nonatomic) IBOutlet NITextField *emailOrPhoneNumTF;            // 邮箱或者手机号码TF
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;          // 获取手机验证码btn

@end

@implementation ForgetPassword_GetVerificationCodeVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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
    [self setNavigationItemTitle:@"找回密码"];
    
    [self initialization];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetForgetPasswordRequestType_GetVerificationCode == request.tag)
        {
            ForgetPassword_InputVerificationCodeVC *input = [ForgetPassword_InputVerificationCodeVC loadFromNib];
            input.emailOrPhoneNumStr = strongSelf->_emailOrPhoneNumTF.text;
            [weakSelf pushViewController:input];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
        [weakSelf showHUDInfoByString:error.localizedDescription];
    }];
}

- (void)setupSubviewsProperty
{
    UIFont *textFont = SP15Font;
    UIColor *placeholderAndLineColor = Common_GrayColor;
    UIColor *themeColor = Common_ThemeColor;
    
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[NITextField class]])
        {
            NITextField *textField = (NITextField *)subView;
            
            [textField addBorderToViewWitBorderColor:[UIColor clearColor] borderWidth:1];
            
            textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            textField.backgroundColor = [UIColor whiteColor];
            textField.font = textFont;
            textField.placeholderFont = textFont;
            textField.placeholderTextColor = placeholderAndLineColor;
        }
    }
    
    _emailOrPhoneNumTF.placeholder = @"请输入您用于登录的手机号";
    
    [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerificationCodeBtn.backgroundColor = themeColor;
    [_getVerificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getVerificationCodeBtn setRadius:3];
}

- (void)initialization
{
    [self setupSubviewsProperty];
}

// 获取验证码
- (IBAction)clickGetVerificationCodeBtn:(UIButton *)sender
{
    // 手机号码获取验证码
    if ([StringJudgeManager isValidateStr:_emailOrPhoneNumTF.text regexStr:MobilePhoneNumRegex])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetForgetPasswordRequestType_GetVerificationCode]
             parameterDic:@{@"mobile": _emailOrPhoneNumTF.text}
        requestMethodType:RequestMethodType_POST
               requestTag:NetForgetPasswordRequestType_GetVerificationCode];
    }
    else
    {
        [self showHUDInfoByString:@"请输入您用于登录的手机号"];
    }
}

@end
