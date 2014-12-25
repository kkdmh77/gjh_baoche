//
//  ModifyUserInfoVC.m
//  JmrbNews
//
//  Created by swift on 14/12/25.
//
//

#import "ModifyUserInfoVC.h"
#import "FUITextField.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "StringJudgeManager.h"

@interface ModifyUserInfoVC ()

@property (weak, nonatomic) IBOutlet UIView *userNameBGView;
@property (weak, nonatomic) IBOutlet UILabel *userNameDescLabel;
@property (weak, nonatomic) IBOutlet FUITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UIView *genderBGView;
@property (weak, nonatomic) IBOutlet UILabel *genderDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;

@property (weak, nonatomic) IBOutlet UIView *mobilePhoneBGView;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneDescLabel;
@property (weak, nonatomic) IBOutlet FUITextField *mobilePhoneTF;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@end

@implementation ModifyUserInfoVC

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
    [self setNavigationItemTitle:@"修改资料"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetUserCenterRequestType_ModifyUserInfo == request.tag)
        {
            NSString *userName = [[successInfoObj safeObjectForKey:@"response"] safeObjectForKey:@"userName"];
            NSString *mobilePhone = [[successInfoObj safeObjectForKey:@"response"] safeObjectForKey:@"userPhone"];
            [UserInfoModel setUserDefaultLoginName:userName];
            [UserInfoModel setUserDefaultMobilePhoneNum:mobilePhone];
            
            [strongSelf backViewController];
        }
    }];
}

- (void)configureViewsProperties
{
    _userNameBGView.backgroundColor = CellBackgroundColor;
    _genderBGView.backgroundColor = CellBackgroundColor;
    _mobilePhoneBGView.backgroundColor = CellBackgroundColor;
    
    [_userNameBGView addLineWithPosition:ViewDrawLinePostionType_Top
                               lineColor:CellSeparatorColor
                               lineWidth:LineWidth];
    [_userNameBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                        startPointOffset:50
                          endPointOffset:0
                               lineColor:CellSeparatorColor
                               lineWidth:LineWidth];
    
    [_mobilePhoneBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                  lineColor:CellSeparatorColor
                                  lineWidth:LineWidth];
    [_mobilePhoneBGView addLineWithPosition:ViewDrawLinePostionType_Top
                           startPointOffset:50
                             endPointOffset:0
                                  lineColor:CellSeparatorColor
                                  lineWidth:LineWidth];
    
    UIColor *descTextColor = Common_LiteGrayColor;
    
    _userNameDescLabel.textColor = descTextColor;
    _genderDescLabel.textColor = descTextColor;
    _mobilePhoneDescLabel.textColor = descTextColor;
    
    _modifyBtn.backgroundColor = Common_BlueColor;
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)initialization
{
    // 设置属性
    [self configureViewsProperties];
    
    _userNameTF.text = _userEntity.userNameStr;
    if (1 == _userEntity.gender)
    {
        _manBtn.selected = YES;
    }
    else
    {
        _womenBtn.selected = YES;
    }
    _mobilePhoneTF.text = _userEntity.userMobilePhoneStr;
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

- (IBAction)clickModifyBtn:(UIButton *)sender
{
    /*
     userId:用户ID
     userName ：用户名
     userPassword  ：密码    	 	-不修改传@“”
     userPhone  ：  联系电话
     file:用户的头像				-不修改可以不传
     userSex：用户的性别
     userVerification:是否已经手机号码验证通过0.没有  1，通过  -直接传服务器返回的值
     */
    if ([self isValidOfInputInfo])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_ModifyUserInfo]
             parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                            @"userName": _userNameTF.text,
                            @"userPassword": @"",
                            @"userPhone": _mobilePhoneTF.text,
                            @"userSex": _manBtn.selected ? @"1" : @"0",
                            @"userVerification": _userEntity.isVerificationPhoneNum}
        requestMethodType:RequestMethodType_POST
               requestTag:NetUserCenterRequestType_ModifyUserInfo];
    }
}

- (BOOL)isValidOfInputInfo
{
    if ([_userNameTF hasText])
    {
        if ([StringJudgeManager isValidateStr:_mobilePhoneTF.text regexStr:MobilePhoneNumRegex])
        {
            return YES;
        }
        else
        {
            [self showHUDInfoByString:@"请输入手机号码"];
            return NO;;
        }
    }
    else
    {
        [self showHUDInfoByString:@"请输入用户名"];
        return NO;
    }
}

@end
