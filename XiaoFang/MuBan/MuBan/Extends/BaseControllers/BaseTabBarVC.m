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
    
    for (int i = 0; i < items.count; i++)
    {
        UITabBarItem *aItem = [items objectAtIndex:i];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: Common_ThemeColor} forState:UIControlStateSelected];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: Common_InkBlackColor} forState:UIControlStateNormal];
        
        UIViewController *vc = self.viewControllers[i];
        aItem.title = vc.title;
        
        UIImage *normalImage = nil;
        UIImage *selectedImage = nil;
        
        switch (i)
        {
            case 0:
            {
//                title = @"实时水压";
                
                normalImage = [UIImage imageNamed:@"message_normal"];
                selectedImage = [UIImage imageNamed:@"message_highlight"];
            }
                break;
            case 1:
            {
//                title = @"位置定位";
                
                normalImage = [UIImage imageNamed:@"position_normal"];
                selectedImage = [UIImage imageNamed:@"position_highlight"];
            }
                break;
            case 2:
            {
//                title = @"接受信息";
                
                normalImage = [UIImage imageNamed:@"shuiya_normal"];
                selectedImage = [UIImage imageNamed:@"shuiya_highlight"];
            }
                break;
            case 3:
            {
//                title = @"基本设置";
                
                normalImage = [UIImage imageNamed:@"setting_normal"];
                selectedImage = [UIImage imageNamed:@"setting_highlight"];
            }
                break;
                
            default:
                break;
        }
        
        if (IOS7)
        {
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            [aItem setImage:normalImage];
            [aItem setSelectedImage:selectedImage];
        }
        else
        {
            [aItem setFinishedSelectedImage:normalImage
                withFinishedUnselectedImage:selectedImage];
        }
    }
}

@end
