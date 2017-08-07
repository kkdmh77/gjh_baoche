//
//  KKLaunchAdContentVC.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 2017/2/27.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKLaunchAd.h"

@interface KKLaunchAdContentVC : UIViewController

@property (nonatomic, assign) UIOffset skipBtnOffset; ///< 跳过按钮位置

@property (nonatomic, strong) KKAdModel *adModel;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, weak) id<KKLaunchAdDelegate> delegate;

@end
