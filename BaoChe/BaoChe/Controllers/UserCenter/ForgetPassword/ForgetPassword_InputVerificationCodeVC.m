//
//  ForgetPassword_InputVerificationCodeVC.m
//  Sephome
//
//  Created by swift on 15/1/11.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "ForgetPassword_InputVerificationCodeVC.h"
#import "NITextField.h"
#import "StringJudgeManager.h"
#import "RegisterBC.h"
#import "ATTimerManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "ForgetPassword_ModifyPasswordVC.h"

#define GetVerificationCodeFreezingTime 30  // 获取验证码后的冻结时间

@interface ForgetPassword_InputVerificationCodeVC () <ATTimerManagerDelegate>
{
    RegisterBC *_registerBC;
}

@property (weak, nonatomic) IBOutlet UILabel *emailOrPhoneNumLabel;             // 邮箱或者手机号码Label
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;          // 获取手机验证码btn

@property (weak, nonatomic) IBOutlet NITextField *verificationCodeTF;           // 填写手机验证码TF
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;                      // 确定btn

@end

@implementation ForgetPassword_InputVerificationCodeVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _registerBC = [[RegisterBC alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[ATTimerManager shardManager] stopTimerDelegate:self];
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
        
        if (NetForgetPasswordRequestType_CheckVerificationCode == request.tag)
        {
            ForgetPassword_ModifyPasswordVC *modifyPassword = [ForgetPassword_ModifyPasswordVC loadFromNib];
            modifyPassword.emailOrPhoneNumStr = weakSelf.emailOrPhoneNumStr;
            [weakSelf pushViewController:modifyPassword];
        }
        else if (NetForgetPasswordRequestType_GetVerificationCode == request.tag)
        {
            // 添加倒计时
            [[ATTimerManager shardManager] addTimerDelegate:weakSelf interval:1];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
        [weakSelf showHUDInfoByString:error.localizedDescription];
    }];
}

- (void)setupSubviewsProperty
{
    UIFont *textFont = SP15Font;
    UIColor *placeholderAndLineColor = Common_GrayColor;
    
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[NITextField class]])
        {
            NITextField *textField = (NITextField *)subView;
            
            [textField addBorderToViewWitBorderColor:placeholderAndLineColor borderWidth:1];
            
            textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            textField.backgroundColor = [UIColor clearColor];
            textField.font = textFont;
            textField.placeholderFont = textFont;
            textField.placeholderTextColor = placeholderAndLineColor;
        }
    }
    
    _emailOrPhoneNumLabel.font = textFont;
    _emailOrPhoneNumLabel.textColor = Common_BlackColor;
    _emailOrPhoneNumLabel.text = _emailOrPhoneNumStr;
    
    [self setGetVerificationCodeBtnTitle:GetVerificationCodeFreezingTime];
    [_getVerificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _verificationCodeTF.placeholder = @"请输入手机收到的验证码";
    
    _confirmBtn.backgroundColor = Common_ThemeColor;
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:LocalizedStr(All_Confirm) forState:UIControlStateNormal];
    
    // 添加倒计时
    [[ATTimerManager shardManager] addTimerDelegate:self interval:1];
}

- (void)initialization
{
    [self setupSubviewsProperty];
}

// 获取验证码
- (IBAction)clickGetVerificationCodeBtn:(UIButton *)sender
{
    // 手机号码获取验证码
    if ([StringJudgeManager isValidateStr:_emailOrPhoneNumLabel.text regexStr:MobilePhoneNumRegex])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetForgetPasswordRequestType_GetVerificationCode]
             parameterDic:@{@"mobile": _emailOrPhoneNumLabel.text}
        requestMethodType:RequestMethodType_POST
               requestTag:NetForgetPasswordRequestType_GetVerificationCode];
    }
    else
    {
        [self showHUDInfoByString:@"请输入您用于登录的手机号"];
    }
}

// 确定
- (IBAction)clickSubmitBtn:(UIButton *)sender
{
    if ([_verificationCodeTF hasText])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetForgetPasswordRequestType_CheckVerificationCode]
             parameterDic:@{@"username": _emailOrPhoneNumStr,
                            @"verifyCode": _verificationCodeTF.text}
        requestMethodType:RequestMethodType_POST
               requestTag:NetForgetPasswordRequestType_CheckVerificationCode];
    }
    else
    {
        [self showHUDInfoByString:@"请输入手机收到的验证码"];
    }
}

- (void)setGetVerificationCodeBtnTitle:(NSInteger)second
{
    if (second > 0)
    {
        [_getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", @"获取验证码", second] forState:UIControlStateNormal];
        _getVerificationCodeBtn.userInteractionEnabled = NO;
        _getVerificationCodeBtn.backgroundColor = [UIColor grayColor];
    }
    else
    {
        [_getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];
        _getVerificationCodeBtn.userInteractionEnabled = YES;
        _getVerificationCodeBtn.backgroundColor = HEXCOLOR(0XA780AC);
    }
}

#pragma mark - ATTimerManagerDelegate methods

- (void)timerManager:(ATTimerManager *)manager timerFireWithInfo:(ATTimerStepInfo)info
{
    if (info.totalTime < GetVerificationCodeFreezingTime)
    {
        [self setGetVerificationCodeBtnTitle:GetVerificationCodeFreezingTime - info.totalTime];
    }
    else
    {
        [[ATTimerManager shardManager] stopTimerDelegate:self];
        
        [self setGetVerificationCodeBtnTitle:0];
    }
}

@end
