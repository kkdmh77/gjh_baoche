//
//  KKInterstitialAdContentVC.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/1.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKInterstitialAdContentVC.h"
#import "KKInterstitialAd.h"
#include <objc/runtime.h>
#import "KKAdManager.h"
#import "UIButton+YYWebImage.h"

@interface KKInterstitialAdContentVC ()

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation KKInterstitialAdContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    WEAKSELF
    [_imageBtn setBackgroundImageWithURL:[NSURL URLWithString:_adModel.imgUrlStr]
                                forState:UIControlStateNormal
                             placeholder:nil
                                 options:YYWebImageOptionSetImageWithFadeAnimation
                                 manager:nil
                                progress:nil
                               transform:nil
                              completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
         // 加载成功就调用成功委托，失败就调用加载失败委托
         if (error) {
             if ([weakSelf.delegate respondsToSelector:@selector(kkInterstitialFailToLoadAd:error:)]) {
                 [weakSelf.delegate kkInterstitialFailToLoadAd:[weakSelf getInterstitialAd] error:error];
             }
             
             [weakSelf dismissViewControllerAnimated:NO completion:nil];
         } else {
             if ([weakSelf.delegate respondsToSelector:@selector(kkInterstitialSuccessToLoadAd:)]) {
                 [weakSelf.delegate kkInterstitialSuccessToLoadAd:[weakSelf getInterstitialAd]];
             }
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_delegate respondsToSelector:@selector(kkInterstitialWillBePresentScreen:)]) {
        [_delegate kkInterstitialWillBePresentScreen:[self getInterstitialAd]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([_delegate respondsToSelector:@selector(kkInterstitialDidBePresentScreen:)]) {
        [_delegate kkInterstitialDidBePresentScreen:[self getInterstitialAd]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)configureViewsProperties {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    _imageBtn.adjustsImageWhenHighlighted = NO;
}

- (void)setup {
    [self configureViewsProperties];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissAnimated:animated
                closeType:KKAdClosedType_CloseBtn
               completion:completion];
}

- (void)dismissAnimated:(BOOL)animated closeType:(KKAdClosedType)type completion:(void (^)(void))completion {
    if ([_delegate respondsToSelector:@selector(kkInterstitialWillClosed:closeType:)]) {
        [_delegate kkInterstitialWillClosed:[self getInterstitialAd] closeType:type];
    }
    
    [self dismissViewControllerAnimated:animated
                             completion:^{
        if ([_delegate respondsToSelector:@selector(kkInterstitialDidClosed:closeType:)]) {
            [_delegate kkInterstitialDidClosed:[self getInterstitialAd] closeType:type];
        }
                                 
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - action methods

// 点击关闭
- (IBAction)clickCloseBtn:(UIButton *)sender {
    [self dismissAnimated:YES
                closeType:KKAdClosedType_CloseBtn
               completion:nil];
}

// 点击广告
- (IBAction)clickAdContentBtn:(UIButton *)sender {
    if (4 == _adModel.targetType) return;
    
    if ([_delegate respondsToSelector:@selector(kkInterstitialClicked:)]) {
        [_delegate kkInterstitialClicked:[self getInterstitialAd]];
    }
    
    WEAKSELF
    UIViewController *presentingViewController = self.presentingViewController;
    [self dismissAnimated:NO
                closeType:KKAdClosedType_ClickAd
               completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(kkInterstitialWillPresentFullScreenModal:)]) {
            [weakSelf.delegate kkInterstitialWillPresentFullScreenModal:[weakSelf getInterstitialAd]];
        }

        // 做相应跳转
        [[KKAdManager sharedInstance] presentViewControllerWithRootViewController:presentingViewController
                                                                          adModel:_adModel
                                                                         animated:NO
                                                                       completion:^{
            if ([weakSelf.delegate respondsToSelector:@selector(kkInterstitialDidPresentFullScreenModal:)]) {
                [weakSelf.delegate kkInterstitialDidPresentFullScreenModal:[weakSelf getInterstitialAd]];
            }
        }];
    }];
}

#pragma mark - setter & getter methods

- (KKInterstitialAd *)getInterstitialAd {
    return objc_getAssociatedObject(self, (__bridge const void *)(self));
}

@end
