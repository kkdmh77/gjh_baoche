//
//  ModifyUserInfoVC.m
//  JmrbNews
//
//  Created by swift on 14/12/25.
//
//

#import "ModifyUserInfoVC.h"

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
    
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
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
    if ([self isValidOfInputInfo])
    {
        
    }
}

- (BOOL)isValidOfInputInfo
{
    /*
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
     */
}

@end
