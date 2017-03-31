//
//  KKLaunchAd.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/24.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKLaunchAd.h"
#import "KKAdRequest.h"
#import "KKLaunchAdContentVC.h"
#include <objc/runtime.h>

@interface KKLaunchAd ()

@property (nonatomic, strong) KKLaunchAdContentVC *adContentController; ///< 广告内容控制器

@end

@implementation KKLaunchAd

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.adContentController = [KKLaunchAdContentVC loadFromNib];
        objc_setAssociatedObject(_adContentController, (__bridge const void *)(_adContentController), self, OBJC_ASSOCIATION_ASSIGN);
    }
    return self;
}

- (void)loadAdWithPlaceholderImage:(UIImage *)placeholderImage andShowInWindow:(UIWindow *)window {
    UIViewController *rootViewController = window.rootViewController;

    if (rootViewController && !_adContentController.presentingViewController) {
        rootViewController.definesPresentationContext = YES;
        _adContentController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _adContentController.adModel = _adModel;
        _adContentController.placeholderImage = placeholderImage;
        _adContentController.delegate = _delegate;
        _adContentController.skipBtnOffset = _skipBtnOffset;
        
        [rootViewController presentViewController:_adContentController
                                         animated:NO
                                       completion:nil];
    }
}

- (void)loadAdWithPlaceholderImage:(UIImage *)placeholderImage presentFromRootViewController:(UIViewController *)rootViewController {
    if (rootViewController && !_adContentController.presentingViewController) {
        rootViewController.definesPresentationContext = YES;
        _adContentController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _adContentController.adModel = _adModel;
        _adContentController.placeholderImage = placeholderImage;
        _adContentController.delegate = _delegate;
        _adContentController.skipBtnOffset = _skipBtnOffset;
        
        [rootViewController presentViewController:_adContentController
                                         animated:NO
                                       completion:nil];
    }
}

@end
