//
//  BaseTabBarVC.m
//  Sephome
//
//  Created by swift on 14/11/10.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BaseTabBarVC.h"
#import "RDVTabBarItem.h"
#import <NerdyUI.h>
#import "AFNetworkingTool.h"
#import "GCDThread.h"
#import "BaseNetworkViewController.h"

@interface BaseTabBarVC ()

@end

@implementation BaseTabBarVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    [self setTabBarItemsInfo];
}

// 设置标签栏的属性
- (void)setTabBarItemsInfo
{
     // self.tabBar.backgroundImage = [UIImage imageNamed:@"tab_back"];
     // self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tab_back"];
    
    if (IOS7)
    {
        // 去除IOS7系统tabbar顶部的那条线
        UIImage *tabBarTopBackgroundImg = [[UIImage alloc] init];
        [[UITabBar appearance] setShadowImage:tabBarTopBackgroundImg];
        /*
        [[UITabBar appearance] setBackgroundImage:tabBarTopBackgroundImg];
         */
    }
    
    NSArray<RDVTabBarItem *> *items = [self.tabBar items];
    
    NSArray *tabItemTitles = @[@"店铺", @"服务", @"产品", @"分享", @"我的"];
    NSArray *tabItemImgaeKeys = @[@[@"tab_dianpu_normal", @"tab_dianpu_selected"],
                                  @[@"tab_fuwu_normal", @"tab_fuwu_selected"],
                                  @[@"tab_chanpin_normal", @"tab_chanpin_selected"],
                                  @[@"tab_fengxiang_normal",  @"tab_fengxiang_selected"],
                                  @[@"tab_mine_normal", @"tab_mine_selected"]];
    
    if (items.count == tabItemTitles.count && items.count == tabItemImgaeKeys.count) {
        for (int i = 0; i < items.count; i++) {
            RDVTabBarItem *aItem = [items objectAtIndex:i];
            aItem.imagePositionAdjustment = UIOffsetMake(0, -2);
            aItem.titlePositionAdjustment = UIOffsetMake(0, 2);
            
            /*
            [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0XF64A4A)}
                                 forState:UIControlStateSelected];
            [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0X8E8E8E)}
                                 forState:UIControlStateNormal];
             */
            aItem.selectedTitleAttributes = @{NSForegroundColorAttributeName: HEXCOLOR(0XF64A4A), NSFontAttributeName: Fnt(11)};
            aItem.unselectedTitleAttributes = @{NSForegroundColorAttributeName: HEXCOLOR(0X8E8E8E), NSFontAttributeName: Fnt(11)};
            
            NSString *title = tabItemTitles[i];
            aItem.title = title;
            
            UIViewController *viewController = [self.viewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                ((UINavigationController *)viewController).topViewController.title = title;
            } else {
                viewController.title = title;
            }
            
            UIImage *normalImage = [UIImage imageNamed:tabItemImgaeKeys[i][0]];
            UIImage *selectedImage = [UIImage imageNamed:tabItemImgaeKeys[i][1]];
            
            normalImage = [normalImage resize:CGSizeMake(20, 20)];
            selectedImage = [selectedImage resize:CGSizeMake(20, 20)];
            
            /*
            if (IOS7) {
                normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [aItem setImage:normalImage];
                [aItem setSelectedImage:selectedImage];
            }
             */
            [aItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
            
            [aItem setBackgroundSelectedImage:[UIImage imageNamed:@"tab_back"] withUnselectedImage:[UIImage imageNamed:@"tab_back"]];
        }
    }
    
    [self refreshTabItemAttributes:[UserInfoCache sharedInstance].tabBarItemModelArray];
}

- (void)refreshTabItemAttributes:(NSArray<BaseTabBarItemModel *> *)tabBarItemModelArray {
    if (tabBarItemModelArray.count == self.tabBar.items.count) {
        for (int i = 0; i < self.tabBar.items.count; i++) {
            RDVTabBarItem *aItem = [self.tabBar.items objectAtIndex:i];
            BaseTabBarItemModel *model = tabBarItemModelArray[i];
            
            NSString *normalImageCacheKey = Str(@"itemImageCacheNormalKey_%d", i);
            NSString *selectedImageCacheKey = Str(@"itemImageCacheSelectedKey_%d", i);
            
            YYImageCache *imageCache = [YYImageCache sharedCache];

            UIImage *normalImage = [imageCache getImageForKey:normalImageCacheKey];
            UIImage *selectedImage = [imageCache getImageForKey:selectedImageCacheKey];
            
            if (normalImage && selectedImage) {
                [aItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
            }
            
            // 请求新的图片
            if ([model.icon isValidString] && [model.selectedIcon isValidString]) {
                [GCDThread enqueueBackground:^{
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.icon]];
                    NSData *normalData = [NSURLConnection sendSynchronousRequest:request
                                                               returningResponse:nil
                                                                           error:NULL];
                    
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.selectedIcon]];
                    NSData *selectedData = [NSURLConnection sendSynchronousRequest:request
                                                                 returningResponse:nil
                                                                             error:NULL];
                    
                    UIImage *normalImage = [UIImage imageWithData:normalData];
                    UIImage *selectedImage = [UIImage imageWithData:selectedData];
                    
                    normalImage = [normalImage resize:CGSizeMake(20, 20)];
                    selectedImage = [selectedImage resize:CGSizeMake(20, 20)];
                    
                    [GCDThread enqueueForeground:^{
                        if (normalImage && selectedImage) {
                            [aItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
                            
                            [aItem setNeedsDisplay];
                        }
                        
                        // 缓存图片
                        [imageCache setImage:normalImage forKey:normalImageCacheKey];
                        [imageCache setImage:selectedImage forKey:selectedImageCacheKey];
                    }];
                }];
            }
            
            // 如果模块有对应的url则刷新
            if ([model.url isValidString]) {
                UIViewController *viewController = [self.viewControllers objectAtIndex:i];
                UIViewController *contentViewController = nil;
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    contentViewController = ((UINavigationController *)viewController).topViewController;
                } else {
                    contentViewController = viewController;
                }
                
                if ([contentViewController respondsToSelector:@selector(reloadPDRCoreAppFrameUrl:)]) {
                    [contentViewController performSelector:@selector(reloadPDRCoreAppFrameUrl:) withObject:model.url];
                }
            }
        }
    }
}

@end
