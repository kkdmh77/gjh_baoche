//
//  ProductViewController.h
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"

// 导航栏的级别
typedef NS_ENUM(NSInteger, ProNavLevel) {
    /// 一级
    ProNavLevelOne = 0,
    
    /// 二级
    ProNavLevelTwo,
};

@interface ProductViewController : BaseNetworkViewController

@property (nonatomic, assign) NSInteger msgCount; ///< 消息数量
@property (nonatomic, assign) NSInteger cartCount; ///< 购物车数量

/// 配置一级导航栏
- (void)configureOneLevelNavAttributesWithSearchBarTitle:(NSString *)title;

/// 配置二级导航栏
- (void)configureTwoLevelNavAttributesWithMenuDics:(NSArray<NSDictionary *> *)menuDics
                                      hasSearchBar:(BOOL)hasSearchBar
                                    searchBarTitle:(NSString *)title;

@end
