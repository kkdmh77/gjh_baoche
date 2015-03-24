//
//  ForgetPassword_ModifyPasswordVC.m
//  Sephome
//
//  Created by swift on 15/1/11.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "ForgetPassword_ModifyPasswordVC.h"
#import "NITextField.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface ForgetPassword_ModifyPasswordVC ()

@property (weak, nonatomic) IBOutlet NITextField *theNewsPasswordTF;           // 新密码TF
@property (weak, nonatomic) IBOutlet NITextField *theNewsPasswordConfirmTF;    // 确认新密码TF
@property (weak, nonatomic) IBOutlet NITextField *VerificationCodeLabel;       // 验证码

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;                     // 确定btn

@end

@implementation ForgetPassword_ModifyPasswordVC

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
    [self setNavigationItemTitle:@"修改密码"];
    
    [self initialization];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        if (NetForgetPasswordRequestType_ModifyPassword == request.tag)
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
            
            [textField addBorderToViewWitBorderColor:[UIColor clearColor] borderWidth:1];
            
            textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            textField.backgroundColor = [UIColor whiteColor];
            textField.font = textFont;
            textField.placeholderFont = textFont;
            textField.placeholderTextColor = placeholderAndLineColor;
        }
    }
    
    _theNewsPasswordTF.placeholder = @"请输入新密码";
    _theNewsPasswordConfirmTF.placeholder = @"请再次输入新密码";
    
    _confirmBtn.backgroundColor = Common_ThemeColor;
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [_confirmBtn setRadius:3];
}

- (void)initialization
{
    [self setupSubviewsProperty];
}

// 确定
- (IBAction)clickSubmitBtn:(UIButton *)sender
{
    if (_theNewsPasswordTF.text.length >= 6 && _theNewsPasswordTF.text.length <= 16)
    {
        if (_theNewsPasswordConfirmTF.text.length >= 6 && _theNewsPasswordConfirmTF.text.length <= 16)
        {
            if ([_theNewsPasswordTF.text isEqualToString:_theNewsPasswordConfirmTF.text])
            {
                if ([_VerificationCodeLabel hasText])
                {
                    [self sendRequest:[[self class] getRequestURLStr:NetForgetPasswordRequestType_ModifyPassword]
                         parameterDic:@{@"userName": _emailOrPhoneNumStr,
                                        @"password": _theNewsPasswordTF.text,
                                        @"checkcode": _VerificationCodeLabel.text}
                    requestMethodType:RequestMethodType_POST
                           requestTag:NetForgetPasswordRequestType_ModifyPassword];
                }
                else
                {
                    [self showHUDInfoByString:@"请输入验证码"];
                }
            }
            else
            {
                [self showHUDInfoByString:@"2次密码输入不一致"];
            }
        }
        else
        {
            [self showHUDInfoByString:@"请再次输入新密码"];
        }
    }
    else
    {
        [self showHUDInfoByString:@"请输入新密码"];
    }
}

@end
