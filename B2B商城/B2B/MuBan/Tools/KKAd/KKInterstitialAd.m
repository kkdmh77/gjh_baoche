//
//  KKInterstitialAd.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/1.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKInterstitialAd.h"
#import "KKInterstitialAdContentVC.h"
#include <objc/runtime.h>

static const void * const kKey = &kKey;

@interface KKInterstitialAd ()

@property (nonatomic, strong) KKInterstitialAdContentVC *adContentController; ///< 广告内容控制器

@end

@implementation KKInterstitialAd

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.adContentController = [KKInterstitialAdContentVC loadFromNib];
        objc_setAssociatedObject(_adContentController, (__bridge const void *)(_adContentController), self, OBJC_ASSOCIATION_ASSIGN);
    }
    return self;
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if (rootViewController && !_adContentController.presentingViewController) {
        rootViewController.definesPresentationContext = YES;
        _adContentController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _adContentController.delegate = _delegate;
        _adContentController.adModel = _adModel;
        
        [rootViewController presentViewController:_adContentController
                                         animated:NO
                                       completion:nil];
    }
}

- (void)hideAdAnimated:(BOOL)animated {
    [_adContentController dismissAnimated:animated
                               completion:nil];
}

#pragma mark - setter & getter methods

@end
