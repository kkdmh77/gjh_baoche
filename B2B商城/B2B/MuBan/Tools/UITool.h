//
//  UITool.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/18.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITool : NSObject

+ (NSArray<UIViewController *> *)tabViewControllers;

+ (void)setTabBarHidden:(BOOL)hidden;

+ (void)setViewControllerNavigationBarHidden:(UIViewController *)viewController hidden:(BOOL)hidden;

// 跳转到扫描页面
+ (void)pushToScanViewControllerWtihCompleteHandle:(void (^) (NSString *resultStr))handle;

@end
