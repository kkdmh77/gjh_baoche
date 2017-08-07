//
//  PasswordInputView.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/23.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "PasswordInputView.h"
#import "PopupController.h"
#import <NerdyUI.h>

@interface PasswordInputView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
// @property (weak, nonatomic) IBOutletCollection(UITextField) NSArray *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *hiddenTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;

@property (weak, nonatomic) IBOutlet UITextField *tfOne;
@property (weak, nonatomic) IBOutlet UITextField *tfTwo;
@property (weak, nonatomic) IBOutlet UITextField *tfThree;
@property (weak, nonatomic) IBOutlet UITextField *tfFour;
@property (weak, nonatomic) IBOutlet UITextField *tfFive;
@property (weak, nonatomic) IBOutlet UITextField *tfSix;

@property (nonatomic, strong) NSArray<UITextField *> *passwordTextField;

@end

@implementation PasswordInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties {
    CGFloat textFieldWidth = 44;
    CGFloat space = (Screen.width - textFieldWidth * _passwordTextField.count) / (_passwordTextField.count + 1);
    
    _tfOne.makeCons(^{
        make.left.equal.superview.constants(space);
        make.right.equal.view(_tfTwo).left.constants(-space);
    });

    _tfSix.makeCons(^{
        make.right.equal.superview.constants(-space);
        make.left.equal.view(_tfFive).right.constants(space);
    });

    _tfThree.makeCons(^{
        make.left.equal.view(_tfTwo).right.constants(space);
        make.right.equal.view(_tfFour).left.constants(-space);
    });
    
    _tfFour.makeCons(^{
        make.right.equal.view(_tfFive).left.constants(-space);
    });
    
    _hiddenTextField.delegate = self;
    
    _confirmBtn.bgImg(@"#1378DF").disabledBgImg(@"#D5D5D5").borderRadius(4);
    _closeBtn.img(@"password_close").bgColor([UIColor clearColor]);
}

- (void)setup {
    self.passwordTextField = @[_tfOne, _tfTwo, _tfThree, _tfFour, _tfFive, _tfSix];
    
    [self configureViewsProperties];
}

- (void)clear {
    _confirmBtn.enabled = NO;
    _hiddenTextField.text = nil;
    for (UITextField *textField in _passwordTextField) {
        textField.text = nil;
    }
}

- (NSString *)inputPassword {
    return _hiddenTextField.text;
}

#pragma mark - action methods

- (IBAction)clickCloseBtn:(id)sender {
    [[PasswordInputViewManager sharedInstance] hide];
    
    if (_actionHandle) _actionHandle(self, PasswordInputViewActionTypeClose, sender);
}

- (IBAction)clickConfirmBtn:(id)sender {
    if (_actionHandle) _actionHandle(self, PasswordInputViewActionTypeConfirm, sender);
}

- (IBAction)clickForgotPasswordBtn:(id)sender {
    if (_actionHandle) _actionHandle(self, PasswordInputViewActionTypeForgotPassword, sender);
}

- (IBAction)textFieldEditingChanged:(UITextField *)textField {
    NSString *passwordText = _hiddenTextField.text; // 当前输入的密码
    
    if (passwordText.length == _passwordTextField.count) {
        // [textField resignFirstResponder]; // 输入完毕
        
        _confirmBtn.enabled = YES;
    } else if (passwordText.length < _passwordTextField.count) {
        _confirmBtn.enabled = NO;
    } else {
        return;
    }
    
    for (NSInteger i = 0; i < _passwordTextField.count; i++) {
        UITextField *textField = _passwordTextField[i];
        
        NSString *passwordChar;
        if (i < passwordText.length) {
            passwordChar = [passwordText substringWithRange:NSMakeRange(i, 1)];
        }
        textField.text = passwordChar;
    }
    
    /*
    if (passwordText.length == 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入的密码是" message:passwordText delegate:nil cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
        [alert show];
    }
     */
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.a(string).length > _passwordTextField.count) {
        return NO;
    }
    return YES;
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface PasswordInputViewManager ()

@property (nonatomic, strong) PopupController *popController;
@property (nonatomic, strong) PasswordInputView *resultView;

@end

@implementation PasswordInputViewManager

DEF_SINGLETON(PasswordInputViewManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.popController = [[PopupController alloc] init];
        _popController.behavior = PopupBehavior_MessageBox;
        
        self.resultView = [PasswordInputView loadFromNib];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title desc:(NSString *)desc actionHandle:(PasswordInputViewActionHandle)handle {
    _resultView.width = Screen.width;
    _resultView.actionHandle = handle;
    [_resultView clear];
    _resultView.titleLabel.text = title;
    _resultView.descLabel.text = desc;
    
    _popController.contentView = _resultView;
    [_popController showInView:[UIApplication sharedApplication].keyWindow
                  animatedType:PopAnimatedType_Input];
}

- (void)hide
{
    [_popController hide];
}

@end
