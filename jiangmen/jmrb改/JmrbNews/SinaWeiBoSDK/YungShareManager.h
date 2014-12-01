//
//  YungShareManager.h
//  YungShare
//
//  Created by Danny Deng on 12-3-5.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define kWBSDKDemoAppKey @"12051955"
#define kWBSDKDemoAppSecret @"51453d0c4f13caedce945ed1df23d0db"
#import <Foundation/Foundation.h>
#import "WBEngine.h"

@interface YungShareManager : UIViewController<WBEngineDelegate> {
    WBEngine *_shareEngine;
    UITextView *_textView;
    UIView *_preView;
}

@property (nonatomic, retain) UIImage *sendImage;

+ (id)defaultShare;
- (void)login;
- (void)shareImage:(NSString *)text Image:(UIImage *)image;
- (void)clickLogOut;

@end
