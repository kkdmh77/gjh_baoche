//
//  KKInsertBannerAd.m
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/2.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "KKInsertBannerAd.h"
#import "KKAdManager.h"
#import "UIButton+YYWebImage.h"
#import "KKAdManager.h"

#define kCloseBtnSize CGSizeMake(20, 20)

@interface KKInsertBannerAd ()

@property (strong, nonatomic) UIButton *imageBtn;
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation KKInsertBannerAd

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - custom methods

- (void)setup {
    // 创建广告内容视图
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_imageBtn];
    _imageBtn.adjustsImageWhenHighlighted = NO;
    [_imageBtn addTarget:self
                  action:@selector(clickAdContentBtn:)
        forControlEvents:UIControlEventTouchUpInside];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ad_close"]
                        forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ad_close_press"]
                        forState:UIControlStateHighlighted];
    [closeBtn addTarget:self
                 action:@selector(clickCloseBtn:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kCloseBtnSize);
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
    self.closeBtn = closeBtn;
}

- (void)loadAdAndShow {
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
             if ([weakSelf.delegate respondsToSelector:@selector(kkInsertBannerViewLoadFailed:withError:)]) {
                 [weakSelf.delegate kkInsertBannerViewLoadFailed:weakSelf withError:error];
             }
             
             [weakSelf clickCloseBtn:weakSelf.closeBtn];
         } else {
             if ([weakSelf.delegate respondsToSelector:@selector(kkInsertBannerViewLoadSuccess:)]) {
                 [weakSelf.delegate kkInsertBannerViewLoadSuccess:weakSelf];
             }
         }
     }];
    
    if (_containerViewController) {
        [_containerViewController.view addSubview:self];
    }
}

#pragma mark - action methods

// 点击关闭
- (void)clickCloseBtn:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(kkInsertBannerViewWillClosed:closeType:)]) {
        [_delegate kkInsertBannerViewWillClosed:self closeType:KKAdClosedType_CloseBtn];
    }
    
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(kkInsertBannerViewDidClosed:closeType:)]) {
        [_delegate kkInsertBannerViewDidClosed:self closeType:KKAdClosedType_CloseBtn];
    }
}

// 点击广告
- (void)clickAdContentBtn:(UIButton *)sender {
    if (4 == _adModel.targetType) return;
    
    if ([_delegate respondsToSelector:@selector(kkInsertBannerViewClicked:)]) {
        [_delegate kkInsertBannerViewClicked:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(kkInsertBannerViewWillPresentFullScreenModal:)]) {
        [self.delegate kkInsertBannerViewWillPresentFullScreenModal:self];
    }
    WEAKSELF
    // 做相应跳转
    [[KKAdManager sharedInstance] presentViewControllerWithRootViewController:_containerViewController
                                                             adModel:_adModel
                                                            animated:NO
                                                          completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(kkInsertBannerViewDidPresentFullScreenModal:)]) {
            [weakSelf.delegate kkInsertBannerViewDidPresentFullScreenModal:weakSelf];
        }
    }];
}

@end
