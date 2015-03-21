//
//  ModifyPasswordVC.m
//  Sephome
//
//  Created by swift on 14/11/24.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "NITextField.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "LoginBC.h"
#import "UserCenterVC.h"
#include <objc/runtime.h>

@interface ModifyPasswordVC ()
{
    LoginBC                     *_loginBC;
}

@property (weak, nonatomic) IBOutlet NITextField *oldPasswordTF;                        // 原始密码
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordErrorRemindLabel;              // 原始密码错误提示

@property (weak, nonatomic) IBOutlet NITextField *theNewPasswordTF;                     // 新密码
@property (weak, nonatomic) IBOutlet UILabel *theNewPasswordErrorRemindLabel;           // 新密码错误提示

@property (weak, nonatomic) IBOutlet NITextField *theNewPasswordConfirmTF;              // 再次输入新密码
@property (weak, nonatomic) IBOutlet UILabel *theNewPasswordConfirmErrorRemindLabel;    // 再次输入新密码错误提示

@property (weak, nonatomic) IBOutlet UIButton *modifyPasswordBtn;                       // 确认修改

@end

@implementation ModifyPasswordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        STRONGSELF
        if (NetUserCenterRequestType_ModifyPossword == request.tag)
        {
            // 登出
            [strongSelf->_loginBC logoutWithSuccessHandle:^(id successInfoObj) {
                
                [strongSelf goBack];
                
            } failedHandle:^(NSError *error) {
                
            }];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
        [weakSelf setDefaultNetFailedBlockImplementationWithNetRequest:request
                                                                 error:error
                                                 isAddFailedActionView:NO
                                                     otherExecuteBlock:nil];
    }];
}

- (void)goBack
{
    // 刷新个人页数据
    UserCenterVC *userCenter = objc_getAssociatedObject(self, class_getName([UserCenterVC class]));
    [userCenter clearAndReloadData];
    
    [self backViewController];
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
            
            [textField addBorderToViewWitBorderColor:placeholderAndLineColor borderWidth:LineWidth];
            
            textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            textField.font = textFont;
            textField.placeholderFont = textFont;
            textField.placeholderTextColor = placeholderAndLineColor;
        }
    }
    
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            
            label.textColor = themeColor;
            label.hidden = YES;
        }
    }
    
    // placeholders and label text
    _oldPasswordTF.placeholder = @"请输入原始密码";
    _oldPasswordErrorRemindLabel.text = @"原始密码错误";
    
    _theNewPasswordTF.placeholder = @"请输入新密码(6-16位数字、字母或符号)";
    _theNewPasswordErrorRemindLabel.text = @"密码必须是6-16位数字、字母或符号";
    
    _theNewPasswordConfirmTF.placeholder = @"确认新密码";
    _theNewPasswordConfirmErrorRemindLabel.text = @"两次密码输入不一致";
    
    _modifyPasswordBtn.titleLabel.font = textFont;
    _modifyPasswordBtn.backgroundColor = HEXCOLOR(0X4BB4BA);
    [_modifyPasswordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
}

- (void)initialization
{
    [self setupSubviewsProperty];
}

// 修改密码
- (IBAction)clickModifyPasswordBtn:(UIButton *)sender
{
    if ([self isValidOfInputInfo])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_ModifyPossword]
             parameterDic:@{@"oldPassword": _oldPasswordTF.text,
                            @"newPassword": _theNewPasswordTF.text}
        requestMethodType:RequestMethodType_POST
               requestTag:NetUserCenterRequestType_ModifyPossword];
    }
}

// 后期移动到BC层
- (BOOL)isValidOfInputInfo
{
    BOOL isValidOldPassword = NO, isValidNewPassword = NO, isValidNewPasswordConfirm = NO;
    
    if ([_oldPasswordTF.text isAbsoluteValid])
    {
        isValidOldPassword = YES;
        _oldPasswordErrorRemindLabel.hidden = YES;
        
        if (_theNewPasswordTF.text.length >= 6 && _theNewPasswordTF.text.length <= 16)
        {
            isValidNewPassword = YES;
            _theNewPasswordErrorRemindLabel.hidden = YES;
            
            if ([_theNewPasswordTF.text isEqualToString:_theNewPasswordConfirmTF.text])
            {
                isValidNewPasswordConfirm = YES;
                _theNewPasswordConfirmErrorRemindLabel.hidden = YES;
            }
            else
            {
                _theNewPasswordConfirmErrorRemindLabel.hidden = NO;
            }
        }
        else
        {
            _theNewPasswordErrorRemindLabel.hidden = NO;
        }
    }
    else
    {
        _oldPasswordErrorRemindLabel.hidden = NO;
    }
    
    return isValidOldPassword && isValidNewPassword && isValidNewPasswordConfirm;
}

@end
