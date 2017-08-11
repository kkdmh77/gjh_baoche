//
//  BaseCollectionView.h
//  Biuu
//
//  Created by 龚 俊慧 on 2017/8/10.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "STCollectionView.h"
#import "GlobalConfig.h"

@interface BaseCollectionView : STCollectionView

@property (nonatomic, assign) ViewLoadType loadType; // 数据加载类型
@property (nonatomic, copy) void (^tapActionHandle) (BaseCollectionView *view); // 点击回调，用于加载失败时点击重新加载

@end
