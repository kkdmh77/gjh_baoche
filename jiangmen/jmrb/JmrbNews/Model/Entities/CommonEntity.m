//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"

@implementation AdsEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.adId = [[dict objectForKey:@"adId"] integerValue];
        self.newsId = [[dict objectForKey:@"newsId"] integerValue];
        self.adImageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:dict[@"adSrc"]];
        self.adNameStr = [dict objectForKey:@"adName"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////

@implementation ImageNewsEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.imageNewsId = [dict[@"newsId"] integerValue];
        self.imageNewsNameStr = dict[@"newsTitle"];
        self.imageCommentCount = [dict[@"commCount"] integerValue];
        self.imagePraiseCount = 0;
        
        NSArray *imageUrlItemList = dict[@"rbNewspics"];
        if ([imageUrlItemList isAbsoluteValid])
        {
            NSMutableArray *tempUrlsArray = [NSMutableArray arrayWithCapacity:imageUrlItemList.count];
            
            for (NSDictionary *imageUrlItem in imageUrlItemList)
            {
                NSString *imageUrl = [UrlManager getImageRequestUrlStrByUrlComponent:imageUrlItem[@"newspic"]];
                [tempUrlsArray addObject:imageUrl];
            }
            
            self.imageUrlsStrArray = tempUrlsArray;
        }
    }
    return self;
}

@end
