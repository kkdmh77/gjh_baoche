//
//  ModifyPasswordVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/25.
//
//

#import "ModifyPasswordVC.h"
#import "FUITextField.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface ModifyPasswordVC ()

@property (weak, nonatomic) IBOutlet UIView *oldPasswordBGView;
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordDescLabel;
@property (weak, nonatomic) IBOutlet FUITextField *oldPasswordTF;

@property (weak, nonatomic) IBOutlet UIView *passwordBGView;
@property (weak, nonatomic) IBOutlet UILabel *passwordDescLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIView *passwordConfirmBGView;
@property (weak, nonatomic) IBOutlet UILabel *passwordConfirmDescLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordConfirmTF;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@end

@implementation ModifyPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"修改密码"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetUserCenterRequestType_ModifyPassword == request.tag)
        {
            [UserInfoModel setUserDefaultPassword:strongSelf.passwordTF.text];
            
            [strongSelf backViewController];
        }
    }];
}

- (void)configureViewsProperties
{
    _oldPasswordBGView.backgroundColor = CellBackgroundColor;
    _passwordBGView.backgroundColor = CellBackgroundColor;
    _passwordConfirmBGView.backgroundColor = CellBackgroundColor;
    
    [_oldPasswordBGView addLineWithPosition:ViewDrawLinePostionType_Top
                               lineColor:CellSeparatorColor
                               lineWidth:LineWidth];
    [_oldPasswordBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                        startPointOffset:50
                          endPointOffset:0
                               lineColor:CellSeparatorColor
                               lineWidth:LineWidth];
    
    [_passwordConfirmBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                  lineColor:CellSeparatorColor
                                  lineWidth:LineWidth];
    [_passwordConfirmBGView addLineWithPosition:ViewDrawLinePostionType_Top
                           startPointOffset:50
                             endPointOffset:0
                                  lineColor:CellSeparatorColor
                                  lineWidth:LineWidth];
    
    UIColor *descTextColor = Common_LiteGrayColor;
    
    _oldPasswordDescLabel.textColor = descTextColor;
    _passwordDescLabel.textColor = descTextColor;
    _passwordConfirmDescLabel.textColor = descTextColor;
    
    _modifyBtn.backgroundColor = Common_BlueColor;
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)initialization
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickModifyBtn:(UIButton *)sender
{
    /*
     userId  用户ID
     userPassword  旧密码
     newPassword  新密码
     */
    if ([self isValidOfInputInfo])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_ModifyPassword]
             parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                            @"userPassword": _oldPasswordTF.text,
                            @"newPassword": _passwordTF.text}
        requestMethodType:RequestMethodType_POST
               requestTag:NetUserCenterRequestType_ModifyPassword];
    }
}

- (BOOL)isValidOfInputInfo
{
    if ([_oldPasswordTF hasText])
    {
        if ([_passwordTF hasText])
        {
            if ([_passwordConfirmTF hasText])
            {
                if ([_passwordTF.text isEqualToString:_passwordConfirmTF.text])
                {
                    return YES;
                }
                else
                {
                    [self showHUDInfoByString:@"新密码2次输入不一致"];
                    return NO;
                }
            }
            else
            {
                [self showHUDInfoByString:@"请再次输入新密码"];
                return NO;
            }
        }
        else
        {
            [self showHUDInfoByString:@"请输入新密码"];
            return NO;
        }
    }
    else
    {
        [self showHUDInfoByString:@"请输入原密码"];
        return NO;
    }
}

@end
