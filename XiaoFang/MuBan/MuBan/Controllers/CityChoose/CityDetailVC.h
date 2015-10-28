//
//  CityDetailVC.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/28.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"

@interface CityDetailVC : BaseNetworkViewController

/// 0:宁波 1:湖州
@property (nonatomic, assign) NSInteger cityType;
@property (nonatomic, assign) BOOL isLoadTabBarController;

@end
