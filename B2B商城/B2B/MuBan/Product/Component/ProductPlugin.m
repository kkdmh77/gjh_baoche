//
//  ProductPlugin.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/6.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "ProductPlugin.h"
#import "ProductViewController.h"
#import "PGMethod.h"
#import <NerdyUI.h>
#import "UITool.h"
#import "GCDThread.h"
#import "PasswordInputView.h"
#import "ShareManager.h"
#import "RequestParameterTool.h"

@implementation ProductPlugin

- (ProductViewController *)productViewController {
    for (UIViewController *viewController in [UITool tabViewControllers]) {
        UIViewController *contentViewController = nil;
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            contentViewController = ((UINavigationController *)viewController).topViewController;
        } else {
            contentViewController = viewController;
        }
        
        if ([contentViewController isKindOfClass:[ProductViewController class]]) {
            return (ProductViewController *)contentViewController;
        }
    }
    return nil;
}

// 显示tabbar
- (void)showMainMenu:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        [UITool setTabBarHidden:NO];
    }];
}

// 隐藏tabbar
- (void)hideMainMenu:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        [UITool setTabBarHidden:YES];
    }];
}

// 显示产品导航
- (void)showProductNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([self productViewController]) {
            if ([commands.arguments isValidArray]) {
                [self productViewController].navigationItem.title = commands.arguments[0];
            }
            
            [UITool setViewControllerNavigationBarHidden:[self productViewController]
                                                  hidden:NO];
        }
    }];
}

// 隐藏产品导航
- (void)hideProductNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([self productViewController]) {
            [UITool setViewControllerNavigationBarHidden:[self productViewController]
                                                  hidden:YES];
        }
    }];
}

// 扫描二维码
- (void)scanQrCode:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        @weakify(self);
        [UITool pushToScanViewControllerWtihCompleteHandle:^(NSString *resultStr) {
            NSString *function = Str(@"qrCallBack('%@')", resultStr);
            
            [weak_self.JSFrameContext evaluateJavaScript:function
                                       completionHandler:^(id obj, NSError *error) {
                                           
            }];
        }];
    }];
}

// 设置产品导航栏消息数
- (void)setMsgCount:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([commands.arguments isValidArray]) {
            [self productViewController].msgCount = [commands.arguments[0] integerValue];
        }
    }];
}

// 设置产品导航栏购物车数
- (void)setCarCount:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([commands.arguments isValidArray]) {
            [self productViewController].cartCount = [commands.arguments[0] integerValue];
        }
    }];
}

// 显示产品模块无搜索框的二级导航栏
- (void)showNoSearchNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([commands.arguments isValidArray]) {
            NSString *searchBarTitle = commands.arguments[0];
            NSString *moreMenuDataStr = commands.arguments[1];
            
            NSArray *moreMenuDataArray = [NSJSONSerialization JSONObjectWithData:[moreMenuDataStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:NULL];
            
            [[self productViewController] configureTwoLevelNavAttributesWithMenuDics:moreMenuDataArray
                                                                        hasSearchBar:NO
                                                                      searchBarTitle:searchBarTitle];
        }
    }];
}

// 隐藏产品模块无搜索框的二级导航栏
- (void)hideNoSearchNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        [[self productViewController] configureOneLevelNavAttributesWithSearchBarTitle:nil];
    }];
}

// 显示产品模块有搜索框的二级导航栏
- (void)showSearchNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if ([commands.arguments isValidArray]) {
            NSString *searchBarTitle = commands.arguments[0];
            NSString *moreMenuDataStr = commands.arguments[1];
            
            NSArray *moreMenuDataArray = [NSJSONSerialization JSONObjectWithData:[moreMenuDataStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:NULL];
            
            [[self productViewController] configureTwoLevelNavAttributesWithMenuDics:moreMenuDataArray
                                                                        hasSearchBar:YES
                                                                      searchBarTitle:searchBarTitle];
        }
    }];
}

// 隐藏产品模块有搜索框的二级导航栏
- (void)hideSearchNav:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        [[self productViewController] configureOneLevelNavAttributesWithSearchBarTitle:nil];
    }];
}

// 显示密码输入框
- (void)showInputPassword:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if (commands.arguments.count >= 4) {
            NSString *title = commands.arguments[0];
            NSString *desc = commands.arguments[1];
            NSString *confirmCallBack = commands.arguments[2];
            NSString *forgetPasswordCallBack = commands.arguments[3];
            
            @weakify(self)
            [[PasswordInputViewManager sharedInstance] showWithTitle:title
                                                                desc:desc
                                                        actionHandle:^(PasswordInputView *view, PasswordInputViewActionType type, id sender) {
                NSString *funciton = nil;
                if (type == PasswordInputViewActionTypeConfirm) {
                    funciton = Str(@"%@('%@')", confirmCallBack, view.inputPassword);
                } else if (type == PasswordInputViewActionTypeForgotPassword) {
                    funciton = Str(@"%@()", forgetPasswordCallBack);
                }

                [weak_self.JSFrameContext stringByEvaluatingJavaScriptFromString:funciton];
            }];
        }
    }];
}

// 隐藏密码输入框
- (void)hideInputPassword:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        [[PasswordInputViewManager sharedInstance] hide];
    }];
}

// 调出分享界面
- (void)appShare:(PGMethod *)commands {
    [GCDThread enqueueForeground:^{
        if (commands.arguments.count >= 3) {
            NSString *title = commands.arguments[0];
            NSString *url = commands.arguments[1];
            NSString *shareContent = commands.arguments[2];
            
            @weakify(self)
            [[ShareManager sharedInstance] shareWithContent:shareContent
                                                      title:title
                                                        url:url
                                                 insetImage:nil
                                               contentImage:nil
                                        presentedController:self.rootViewController
                                                 completion:^(UMSocialShareResponse *result, NSError *error) {
                 [GCDThread enqueueBackgroundWithDelay:0.0
                                                 block:^{
                     NSString *function = Str(@"shareCallBack('%@')", error ? @NO : @YES);
                     
                     [weak_self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:)
                                                 withObject:function
                                              waitUntilDone:YES];
                 }];
            }];
        }
    }];
}

- (void)stringByEvaluatingJavaScriptFromString:(NSString *)js {
    [self.JSFrameContext evaluateJavaScript:js
                          completionHandler:^(id obj, NSError *error) {
        
    }];
}

// 对参数信息进行加密
- (NSString *)encryptAppInfo:(PGMethod *)commands {
    if ([commands.arguments isValidArray]) {
        NSString *toEncodeInfo = commands.arguments[0];
        NSData *toEncodeInfoData = [toEncodeInfo dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *key = kMD5;
        NSData *resultData = [toEncodeInfoData AESEncryptWithKey:key];
        
        NSString *resultStr = resultData.hexString;
        resultStr = kAppId.a(@"|").a(resultStr);
        
        return resultStr;
        
        /*
        PDRPluginResult *pluginResult = [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                                                           messageAsArray:[NSArray arrayWithObjects:resultStr, nil]];
        NSString *jsonStr = [pluginResult toJSONString];
        [self toCallback:commands.callBackID withReslut:jsonStr];
         */
    }
    return nil;
}

@end
