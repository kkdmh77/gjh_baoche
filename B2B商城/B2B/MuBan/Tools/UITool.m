//
//  UITool.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/4/18.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "UITool.h"
#import "AppDelegate.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CameraGetTextbookVC.h"

@implementation UITool

+ (NSArray<UIViewController *> *)tabViewControllers {
    return SharedAppDelegate.baseTabBarController.viewControllers;
}

+ (void)setTabBarHidden:(BOOL)hidden {
    [SharedAppDelegate.baseTabBarController setTabBarHidden:hidden animated:YES];
}

+ (void)setViewControllerNavigationBarHidden:(UIViewController *)viewController hidden:(BOOL)hidden {
    if (viewController && viewController.navigationController) {
        [viewController.navigationController setNavigationBarHidden:hidden animated:YES];
        
        viewController.fd_prefersNavigationBarHidden = hidden;
    }
}

+ (void)pushToScanViewControllerWtihCompleteHandle:(void (^)(NSString *))handle {
    UIViewController *curSelectedViewController = SharedAppDelegate.baseTabBarController.selectedViewController;
    
    if ([curSelectedViewController isKindOfClass:[UINavigationController class]]) {
        CameraGetTextbookVC *scan = [[CameraGetTextbookVC alloc] initWtihCompleteHandle:handle];
        scan.scanType = CameraScanType_All_BarCode;
        [((UINavigationController *)curSelectedViewController) pushViewController:scan animated:YES];
    }
}

@end
