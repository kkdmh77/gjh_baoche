//
//  EmptyDataCell.h
//  Biuu
//
//  Created by 龚 俊慧 on 2017/7/20.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"

@interface EmptyDataCell : UITableViewCell

@property (nonatomic, assign) ViewLoadType loadType; // 数据加载类型
@property (nonatomic, copy) void (^tapActionHandle) (EmptyDataCell *cell); // 点击回调，用于加载失败时点击重新加载

@end
