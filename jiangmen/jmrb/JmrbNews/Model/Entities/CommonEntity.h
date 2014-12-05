//
//  CommonEntity.h
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NetItemList.h"

@interface News_NormalEntity : NetItem

@property (nonatomic, assign) NSInteger newsId;
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

///////////////////////////////////////////////////////////////

@interface NewsTypeEntity : NetItem

@property (nonatomic, copy) NSString *newsTypeNameStr;   // 新闻类型名称
@property (nonatomic, assign) NSInteger newsTypeId;      // 新闻类型ID

@end

///////////////////////////////////////////////////////////////

@interface VideoNewsEntity : NetItem

@property (nonatomic, assign) NSInteger videoNewsId;
@property (nonatomic, copy) NSString *videoNameStr;         // 视频名称
@property (nonatomic, copy) NSString *videoImageUrlStr;     // 视频列表页小图片
@property (nonatomic, assign) NSInteger videoPalyCount;     // 视频播放数

@end

///////////////////////////////////////////////////////////////

@interface ImageNewsEntity : NetItem

@property (nonatomic, assign) NSInteger imageNewsId;
@property (nonatomic, copy) NSString *imageNewsNameStr;     // 图片新闻名
@property (nonatomic, strong) NSArray *imageUrlsStrArray;   // 图片组的urls
@property (nonatomic, assign) NSInteger imageCommentCount;  // 图片评论数
@property (nonatomic, assign) NSInteger imagePraiseCount;   // 图片赞的数量

@end
