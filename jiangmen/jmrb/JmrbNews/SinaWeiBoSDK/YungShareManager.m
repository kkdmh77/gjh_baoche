//
//  YungShareManager.m
//  YungShare
//
//  Created by Danny Deng on 12-3-5.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "YungShareManager.h"
#import "AppDelegate.h"

static YungShareManager *_default;

@interface YungShareManager(Extend)

- (void)sendShareImage:(NSString *)text Image:(UIImage *)image;
- (void)clickBack;
- (void)clickShare;

@end

@implementation YungShareManager
@synthesize sendImage;

+ (id)defaultShare {
    if (!_default) {
        _default = [[super alloc] init];
    }
    return _default;
}

+ (id)alloc {
    if (!_default) {
        _default = [super alloc];
    }
    return _default;
}

- (void)dealloc {
    [_textView release];
    [_preView release];
    [self setSendImage:nil];
    [_shareEngine release];
    [super dealloc];
}

- (id)init {
    if (!_default) {
        _default = [super init];
    }
    return _default;
}

- (void)login {
    if (!_shareEngine) {
        _shareEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_shareEngine setRootViewController:self];
        [_shareEngine setDelegate:self];
        [_shareEngine setIsUserExclusive:NO];
    }
    if (!_preView) {
        _preView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_preView setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:0.9 alpha:1]];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController.view addSubview:_preView];
    for (UIView *view in [_preView subviews]) {
        [_preView removeFromSuperview];
    }
    [_preView setAlpha:.5];
    [_shareEngine logIn];
}

- (void)shareImage:(NSString *)text Image:(UIImage *)image {
    if (!_shareEngine) {
        _shareEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_shareEngine setRootViewController:self];
        [_shareEngine setDelegate:self];
        [_shareEngine setIsUserExclusive:NO];
    }
    if (_preView) {
        [_preView removeFromSuperview];
        [_preView release];
    }
    _preView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [_preView setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:0.9 alpha:1]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_preView];
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 150)];
        [_textView setFont:[UIFont systemFontOfSize:17]];
//        [_textView setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1]];
        [_textView setBackgroundColor:[UIColor clearColor]];
    }
    if (![text hasSuffix:@"＃@江门日报 手机客户端＃"]) {
        [_textView setText:[NSString stringWithFormat:@"%@    ＃@江门日报 手机客户端＃", text]];
    }
    
    [self setSendImage:image];
    if (!_shareEngine) {
        _shareEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_shareEngine setRootViewController:self];
        [_shareEngine setDelegate:self];
        [_shareEngine setIsUserExclusive:NO];
    }
    if (![_shareEngine isLoggedIn]) {
        [_preView setAlpha:.5];
        [_shareEngine logIn];
//        [_shareEngine logInUsingUserID:@"909979297@qq.com" password:@"529143qwe"];
        return;
    }
    [_preView setAlpha:1];
    UIImage *image1;
    UIImageView *imageView;
    UIButton *btnBack, *btnShare;
    
    image1 = [UIImage imageNamed:@"share_background"];
    imageView = [[UIImageView alloc] initWithImage:image1];
    [imageView setFrame:CGRectMake(0, 38, 320, image1.size.height)];
    [_preView addSubview:imageView];
    [imageView release];
    
    
    image1 = [UIImage imageNamed:@"nav_bg"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:image1];
    [titleImageView setFrame:CGRectMake(0, 0, 320, image1.size.height)];
    [_preView addSubview:titleImageView];
    [titleImageView release];
    
    UILabel *lblShareTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 38)];
    [lblShareTitle setTextAlignment:UITextAlignmentCenter];
    [lblShareTitle setTextColor:[UIColor whiteColor]];
    [lblShareTitle setText:@"分享到新浪微博"];
    [lblShareTitle setFont:[UIFont boldSystemFontOfSize:20]];
    [lblShareTitle setBackgroundColor:[UIColor clearColor]];
    [_preView addSubview:lblShareTitle];
    [lblShareTitle release];
    
//    image1 = [UIImage imageNamed:@"logo"];
//    imageView = [[UIImageView alloc] initWithImage:image1];
//    [imageView setFrame:CGRectMake(0, 0, image1.size.width, image1.size.height)];
//    [imageView setCenter:CGPointMake(160, image1.size.height/2 + 5)];
//    [_preView addSubview:imageView];
//    [imageView release];
    
//    UIView *textBgView = [[UIView alloc] initWithFrame:CGRectMake(_textView.frame.origin.x-1, _textView.frame.origin.y-1, _textView.frame.size.width+2, _textView.frame.size.height+2)];
//    [textBgView setBackgroundColor:[UIColor blackColor]];
//    [_preView addSubview:textBgView];
    [_preView addSubview:_textView];
//    [textBgView release];
    
    if (image) {
        imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(10, 100, 320/3, 480/3)];
        [_preView addSubview:imageView];
        [imageView release];
    }
    
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    image1 = [UIImage imageNamed:@"NavigationBar_return_button_selected"];
//    [btnBack.titleLabel setFont:[UIFont systemFontOfSize:20]];
//    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
//    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:image1 forState:UIControlStateHighlighted];
    image1 = [UIImage imageNamed:@"NavigationBar_return_button_normal"];
    [btnBack setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(6, 3, image1.size.width, image1.size.height)];
    [btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:btnBack];
    
    btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    image1 = [UIImage imageNamed:@"share_button"];
    [btnShare setBackgroundImage:image1 forState:UIControlStateNormal];
    image1 = [UIImage imageNamed:@"share_button_tapped"];
    [btnShare setBackgroundImage:image1 forState:UIControlStateHighlighted];
    [btnShare setFrame:CGRectMake(254, 3, image1.size.width, image1.size.height)];
    [btnShare addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:btnShare];
    
    [_textView becomeFirstResponder];
    
//    UIButton *btnLogOut;
//    btnLogOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    image1 = [UIImage imageNamed:@"three_return_button"];
//    [btnLogOut.titleLabel setFont:[UIFont systemFontOfSize:20]];
//    [btnLogOut setTitle:@"登出" forState:UIControlStateNormal];
//    [btnLogOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [btnLogOut setBackgroundImage:image1 forState:UIControlStateNormal];
//    [btnLogOut setFrame:CGRectMake(10, 300, 50, 40)];
//    [btnLogOut addTarget:self action:@selector(clickLogOut) forControlEvents:UIControlEventTouchUpInside];
//    [_preView addSubview:btnLogOut];
}

#pragma mark - private
- (void)sendShareImage:(NSString *)text Image:(UIImage *)image {
    
}

- (void)engineDidLogOut:(WBEngine *)engine {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (void)clickLogOut {
    if (!_shareEngine) {
        _shareEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_shareEngine setRootViewController:self];
        [_shareEngine setDelegate:self];
        [_shareEngine setIsUserExclusive:NO];
    }
    [_shareEngine logOut];
    [_preView removeFromSuperview];
}

- (void)clickBack {
    [_preView removeFromSuperview];
}

- (void)clickShare {
    [_preView removeFromSuperview];
    [_shareEngine sendWeiBoWithText:_textView.text image:self.sendImage];
}

- (void)engineDidLogIn:(WBEngine *)engine {
    if (_textView.text || self.sendImage) {
        [self shareImage:_textView.text Image:self.sendImage];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error {
    NSString *errorStr = nil;
    NSDictionary *userInfo = [error userInfo];
    NSInteger errorCode = [[userInfo objectForKey:@"error_code"] intValue];
    switch (errorCode) {
        case 20019:
            errorStr = @"微博内容已分享";
            break;
        case 21327:
            errorStr = @"请退出后再登陆";
            break;
        default:
            if ([error code] == -1009) {
                errorStr = @"请链接网络";
            }
            else {
                errorStr = @"分享失败,请确保网络畅通";
            }
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorStr message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
    [alert show];
    [alert release];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
    [alert show];
    [alert release];
}

- (void)engineCancelLogin {
    [_preView removeFromSuperview];
}

@end
