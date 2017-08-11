//
//  BaseTableView.h
//  Biuu
//
//  Created by 龚 俊慧 on 2017/8/10.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"

@interface BaseTableView : UITableView

@property (nonatomic, assign) ViewLoadType loadType; // 数据加载类型
@property (nonatomic, copy) void (^tapActionHandle) (BaseTableView *view); // 点击回调，用于加载失败时点击重新加载

@end
