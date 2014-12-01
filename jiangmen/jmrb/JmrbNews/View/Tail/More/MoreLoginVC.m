//
//  MoreLoginVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreLoginVC.h"
#import "ZSCommunicateModel.h"
#import <CommonCrypto/CommonDigest.h>

@interface MoreLoginVC ()

- (void)loginInfo:(NSNotification *)notification;
- (void)showLogInStatus;
- (void)showLogOutStatus;

@end

@implementation MoreLoginVC
@synthesize accountField, codeField;
@synthesize lblAccountName;
@synthesize btnLogOut, btnLogIn;
@synthesize lblCode, lblAccount;
@synthesize delegate;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInfo:) name:Notification_LoginIsSuccess object:nil];
//    NSString *accountString = [[NSUserDefaults standardUserDefaults] objectForKey:Login_Accout];
    NSString *accountNameString = [[NSUserDefaults standardUserDefaults] objectForKey:More_Login_Name];
//    if (accountString) {
//        [accountField setText:accountString];
//    }
    [lblAccountName setAdjustsFontSizeToFitWidth:YES];
    if (accountNameString) {
        [self showLogInStatus];
        [lblAccountName setText:[NSString stringWithFormat:@"欢迎本报记者：%@", accountNameString]];
    }
    else {
        [self showLogOutStatus];
    }
}

#pragma mark - Xib Function
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(MoreDetailGoBack)]) {
        [delegate MoreDetailGoBack];
    }
}

- (IBAction)clickLogin:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (accountField.text && [accountField.text length] > 0) {
        [dic setObject:accountField.text forKey:Key_Login_Account];
    }
    else {
        [dic setObject:@"" forKey:Key_Login_Account];
    }
    if (codeField.text && [codeField.text length] > 0) {
        [dic setObject:codeField.text forKey:Key_Login_Code];
    }
    else {
        [dic setObject:@"" forKey:Key_Login_Code];
    }
    NSString *sigString = [dic objectForKey:Key_Login_Code];
    const char *sigChars = [sigString UTF8String];
    unsigned char sig[16];
    CC_MD5(sigChars, strlen(sigChars), sig);
    NSMutableString *sigMD5String = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < 16; i++) {
        [sigMD5String appendString:[NSString stringWithFormat:@"%02X",sig[i]]];
    }
    [dic setObject:sigMD5String forKey:Key_Login_Code];
    
    [dic setObject:Web_local_Reporter_Login forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

- (IBAction)clickLogOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:More_Login_Name];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:More_Login_Reporter_id];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [accountField setText:nil];
    [lblAccountName setText:nil];
    [self showLogOutStatus];
}

#pragma mark - Private
- (void)showLogInStatus {
    [lblAccountName setAlpha:1];
    [btnLogOut setAlpha:1];
    [accountField setAlpha:0];
    [codeField setAlpha:0];
    [btnLogIn setAlpha:0];
    [lblCode setAlpha:0];
    [lblAccount setAlpha:0];
}

- (void)showLogOutStatus {
    [lblAccountName setAlpha:0];
    [btnLogOut setAlpha:0];
    [accountField setAlpha:1];
    [codeField setAlpha:1];
    [btnLogIn setAlpha:1];
    [lblCode setAlpha:1];
    [lblAccount setAlpha:1];
}

- (void)loginInfo:(NSNotification *)notification {
    NSNumber *loginNum = [notification object];
    if ([loginNum boolValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [[NSUserDefaults standardUserDefaults] setObject:accountField.text forKey:Login_Accout];
        [self clickBack:nil];
    }
    else {
        [accountField setText:@""];
        [codeField setText:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"账号或密码错误" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

@end
