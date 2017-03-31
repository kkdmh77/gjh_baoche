//
//  BaseTabBarVC.m
//  Sephome
//
//  Created by swift on 14/11/10.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BaseTabBarVC.h"

@interface BaseTabBarVC ()

@end

@implementation BaseTabBarVC

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
    self.tabBar.backgroundImage = [UIImage imageNamed:@"Navigation_Under.png"];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Navigation_Under_Opt.png"];
    
    if (IOS7)
    {
        // 去除IOS7系统tabbar顶部的那条线
        UIImage *tabBarTopBackgroundImg = [[UIImage alloc] init];
        [[UITabBar appearance] setShadowImage:tabBarTopBackgroundImg];
        /*
         [[UITabBar appearance] setBackgroundImage:tabBarTopBackgroundImg];
         */
    }
    
    NSArray *items = [self.tabBar items];
    
    NSArray *tabItemTitles = @[@"店铺", @"服务", @"产品", @"分享", @"分享"];
    NSArray *tabItemImgaeKeys = @[@[@"tab_dianpu_normal", @"tab_dianpu_selected"],
                                  @[@"tab_fuwu_normal", @"tab_fuwu_selected"],
                                  @[@"tab_chanpin_normal", @"tab_chanpin_selected"],
                                  @[@"tab_fengxiang_normal",  @"tab_fengxiang_selected"],
                                  @[@"tab_mine_normal", @"tab_mine_selected"]];
    
    if (items.count == tabItemTitles.count && items.count == tabItemImgaeKeys.count) {
        for (int i = 0; i < items.count; i++) {
            UITabBarItem *aItem = [items objectAtIndex:i];
            [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0X306CC5)}
                                 forState:UIControlStateSelected];
            [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0X4F555F)}
                                 forState:UIControlStateNormal];
            
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
            
            if (IOS7) {
                normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [aItem setImage:normalImage];
                [aItem setSelectedImage:selectedImage];
            }
        }
    }
}

@end
