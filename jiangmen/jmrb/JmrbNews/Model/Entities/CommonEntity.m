//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"

@implementation News_NormalEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.newsId = [[dict objectForKey:@"newsId"] integerValue];
        self.newsImageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:dict[@"newsSpicture"]];
        self.newsTitleStr = [dict objectForKey:@"newsTitle"];
        self.newsDescStr = [dict objectForKey:@"newsAbstract"];
        self.newsCommentCount = [[dict objectForKey:@"commCount"] integerValue];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation News_ImageEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation NewsTypeEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.newsTypeId = [[dict objectForKey:@"newstypeId"] integerValue];
        self.newsTypeNameStr = [dict objectForKey:@"newstypeName"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation VideoNewsEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.videoNewsId = [[dict objectForKey:@"newsId"] integerValue];
        self.videoNameStr = [dict objectForKey:@"newsTitle"];
        self.videoImageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:dict[@"newsSpicture"]];
        self.videoPalyCount = [[dict objectForKey:@"newsClicked"] integerValue];
    }
    return self;
}

@end
