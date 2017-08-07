//
//  KKLaunchAdContentVC.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/27.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKLaunchAdContentVC.h"
#import "UIButton+YYWebImage.h"
#include <objc/runtime.h>
#import "ATTimerManager.h"
#import "KKAdManager.h"

#define kSkipBtnSize CGSizeMake(40, 40) // 跳过按钮的尺寸
#define kSkipFreezingTime 5  // 跳过的冻结时间

@interface KKLaunchAdContentVC ()<ATTimerManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@end

@implementation KKLaunchAdContentVC

- (void)dealloc {
    [[ATTimerManager shardManager] stopTimerDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    // 图片请求最多3秒，超时算加载失败
    YYWebImageManager *imageManager = [YYWebImageManager sharedManager];
    imageManager.timeout = 3;
    
    WEAKSELF
    [_imageBtn setBackgroundImageWithURL:[NSURL URLWithString:_adModel.imgUrlStr]
                                forState:UIControlStateNormal
                             placeholder:_placeholderImage
                                 options:YYWebImageOptionSetImageWithFadeAnimation
                                 manager:imageManager
                                progress:nil
                               transform:nil
                              completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        // 加载成功就调用成功委托并开启5秒倒计时，失败就调用加载失败委托
        if (error) {
            if ([weakSelf.delegate respondsToSelector:@selector(kkLaunchAdLoadFailed:withError:)]) {
                [weakSelf.delegate kkLaunchAdLoadFailed:[weakSelf getLaunchAd] withError:error];
            }

            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else {
            weakSelf.skipBtn.hidden = NO;
            if ([weakSelf.delegate respondsToSelector:@selector(kkLaunchAdLoadSuccess:)]) {
                [weakSelf.delegate kkLaunchAdLoadSuccess:[weakSelf getLaunchAd]];
            }
         
         // 开启5s倒计时
         [[ATTimerManager shardManager] addTimerDelegate:self interval:1];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)configureViewsProperties {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    _imageBtn.adjustsImageWhenHighlighted = NO;

    _skipBtn.hidden = YES;
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%d", kSkipFreezingTime]
              forState:UIControlStateNormal];
    _skipBtn.backgroundColor = HEXCOLORAL(0X000000, 0.5);
    _skipBtn.layer.cornerRadius = kSkipBtnSize.height / 2;
    [_skipBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    _skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    if (UIOffsetEqualToOffset(UIOffsetZero, _skipBtnOffset)) {
        _skipBtnOffset = UIOffsetMake(-15, 15);
    }
    [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kSkipBtnSize);
        if (_skipBtnOffset.horizontal >= 0) {
            make.left.equalTo(_skipBtnOffset.horizontal);
        } else {
            make.right.equalTo(_skipBtnOffset.horizontal);
        }
        
        if (_skipBtnOffset.vertical >= 0) {
            make.top.equalTo(_skipBtnOffset.vertical);
        } else {
            make.bottom.equalTo(_skipBtnOffset.vertical);
        }
    }];
}

- (void)setup {
    [self configureViewsProperties];
}

- (void)dismissAnimated:(BOOL)animated closeType:(KKAdClosedType)type completion:(void (^)(void))completion {
    if ([_delegate respondsToSelector:@selector(kkLaunchAdWillClosed:closeType:)]) {
        [_delegate kkLaunchAdWillClosed:[self getLaunchAd] closeType:type];
    }
    
    [self dismissViewControllerAnimated:animated
                             completion:^{
        if ([_delegate respondsToSelector:@selector(kkLaunchAdDidClosed:closeType:)]) {
            [_delegate kkLaunchAdDidClosed:[self getLaunchAd] closeType:type];
        }
                                 
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - action methods

// 点击跳过
- (IBAction)clickSkipBtn:(UIButton *)sender {
    [self dismissAnimated:YES
                closeType:KKAdClosedType_Skip
               completion:nil];
}

// 点击广告
- (IBAction)clickAdContentBtn:(UIButton *)sender {
    if (4 == _adModel.targetType) return;
    
    if ([_delegate respondsToSelector:@selector(kkLaunchAdClicked:)]) {
        [_delegate kkLaunchAdClicked:[self getLaunchAd]];
    }
    
    WEAKSELF
    UIViewController *presentingViewController = self.presentingViewController;
    [self dismissAnimated:NO
                closeType:KKAdClosedType_ClickAd
               completion:^{
       if ([weakSelf.delegate respondsToSelector:@selector(kkLaunchAdWillPresentFullScreenModal:)]) {
           [weakSelf.delegate kkLaunchAdWillPresentFullScreenModal:[weakSelf getLaunchAd]];
       }
                   
        // 做相应跳转
        [[KKAdManager sharedInstance] presentViewControllerWithRootViewController:presentingViewController
                                                                          adModel:weakSelf.adModel
                                                                         animated:NO
                                                                       completion:^{
           if ([weakSelf.delegate respondsToSelector:@selector(kkLaunchAdDidPresentFullScreenModal:)]) {
               [weakSelf.delegate kkLaunchAdDidPresentFullScreenModal:[weakSelf getLaunchAd]];
           }
        }];
    }];
}

#pragma mark - setter & getter methods

- (KKLaunchAd *)getLaunchAd {
    return objc_getAssociatedObject(self, (__bridge const void *)(self));
}

#pragma mark - ATTimerManagerDelegate methods

- (void)timerManager:(ATTimerManager *)manager timerFireWithInfo:(ATTimerStepInfo)info {
    if (info.totalTime >= kSkipFreezingTime) {
        [self dismissAnimated:YES
                    closeType:KKAdClosedType_Auto
                   completion:nil];
        [manager stopTimerDelegate:self];
    }
    
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%.0lf", kSkipFreezingTime - info.totalTime]
              forState:UIControlStateNormal];
}

@end
