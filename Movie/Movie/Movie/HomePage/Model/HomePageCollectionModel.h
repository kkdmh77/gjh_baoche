//
//  HomePageCollectionModel.h
//  Movie
//
//  Created by 龚 俊慧 on 2017/6/4.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@class HomePageCollectionItemModel;

@interface HomePageCollectionSectionModel : NSObject

@property (nonatomic, copy) NSString *columnName; ///< 模块名称
@property (nonatomic, assign) NSInteger jumpChannelId; ///< 频道ID
@property (nonatomic, assign) NSInteger videoType;
@property (nonatomic, strong) NSArray<HomePageCollectionItemModel *> *itemModelArray; ///< item的数据

@end

////////////////////////////////////////////////////////////////////////////////

@interface HomePageCollectionItemModel : NSObject

@property (nonatomic, copy) NSString *thumbnailImage; ///< 封面图
@property (nonatomic, copy) NSString *title; ///< 名称
@property (nonatomic, copy) NSString *videoId; ///< ID
@property (nonatomic, assign) NSInteger rating; ///< 评分 80为8.0分，如果值为0就为7.6分
@property (nonatomic, copy) NSString *updateLabel; ///< 更新说明

@end
