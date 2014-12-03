//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"

@interface News_NormalEntity : NetItem

@property (nonatomic, copy) NSString *newsImageUrlStr;
@property (nonatomic, copy) NSString *newsTitleStr;
@property (nonatomic, copy) NSString *newsDescStr;
@property (nonatomic, assign) NSInteger newsCommentCount;

@end

///////////////////////////////////////////////////////////////

@interface News_ImageEntity : NetItem

@property (nonatomic, copy) NSString *imageGroupNameStr;        // 图片组标题
@property (nonatomic, strong) NSArray *imageUrlsStrArray;       // 图片组的urls
@property (nonatomic, assign) NSInteger imageCommentCount;      // 图片的评论数

@end
