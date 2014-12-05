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
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: HEXCOLOR(0X306CC5)} forState:UIControlStateSelected];
        [aItem setTitleTextAttributes:@{UITextAttributeTextColor: HEXCOLOR(0X4F555F)} forState:UIControlStateNormal];
        
        switch (i)
        {
            case 0:
            {
                aItem.title = @"新闻";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_news_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_news_normal"]];
            }
                break;
            case 1:
            {
                aItem.title = @"图片";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_image_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_image_normal"]];
            }
                break;
            case 2:
            {
                aItem.title = @"视频";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_video_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_video_normal"]];
            }
                break;
            case 3:
            {
                aItem.title = @"论坛";
                [aItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_bbs_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_bbs_normal"]];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
