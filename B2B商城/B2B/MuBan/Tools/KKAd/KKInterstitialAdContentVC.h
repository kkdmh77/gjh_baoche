//
//  KKInterstitialAdContentVC.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/3/1.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKInterstitialAd.h"

@interface KKInterstitialAdContentVC : UIViewController

@property (nonatomic, strong) KKAdModel *adModel;
@property (nonatomic, weak) id<KKInterstitialAdDelegate> delegate;

/// 关闭广告
- (void)dismissAnimated:(BOOL)animated
             completion:(void (^)(void))completion;

@end
