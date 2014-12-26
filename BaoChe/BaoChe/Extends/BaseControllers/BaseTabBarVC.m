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
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: Common_BlackColor}
                             forState:UIControlStateSelected];
        
        switch (i)
        {
            case 0:
            {
                aItem.title = @"买票";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"Navigation_Under_ico_22.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Navigation_Under_ico_21.png"]];
            }
                break;
            case 1:
            {
                aItem.title = @"个人中心";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"Navigation_Under_ico_32.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Navigation_Under_ico_31.png"]];
            }
                break;
            case 2:
            {
                aItem.title = @"更多";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"Navigation_Under_ico_12.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Navigation_Under_ico_11.png"]];
            }
                break;
            case 3:
            {
                aItem.title = @"xx";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"Navigation_Under_ico_highlight.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Navigation_Under_ico_normal.png"]];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
