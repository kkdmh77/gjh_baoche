//
//  BaseTabBarVC.h
//  Sephome
//
//  Created by swift on 14/11/10.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "RequestParameterTool.h"

@interface BaseTabBarVC : RDVTabBarController

- (void)refreshTabItemAttributes:(NSArray<BaseTabBarItemModel *> *)tabBarItemModelArray;

@end

