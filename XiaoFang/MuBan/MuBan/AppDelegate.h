//
//  AppDelegate.h
//  rest_test
//
//  Created by swift on 15/1/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseTabBarVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BaseTabBarVC   *baseTabBarController;
@property (nonatomic, strong) NSMutableArray *tabDataArray;

@end

