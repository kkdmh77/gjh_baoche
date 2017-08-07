//
//  GlobalConfig.h
//  Biuu
//
//  Created by 龚 俊慧 on 2017/7/19.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///< 数据加载类型
typedef NS_ENUM(NSInteger, ViewLoadType) {
    ///< 正在加载
    ViewLoadTypeLoading = 0,
    
    ///< 加载成功
    ViewLoadTypeSuccess,
    
    ///< 加载失败
    ViewLoadTypeFailed,
    
    ///< 无网络
    ViewLoadTypeNoNet,
    
    ///< 无数据
    ViewLoadTypeNoneData
};
