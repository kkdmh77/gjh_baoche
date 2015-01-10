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
        self.adImageUrlStr = dict[@"adSrc"] ? [UrlManager getImageRequestUrlStrByUrlComponent:dict[@"adSrc"]] : [UrlManager getImageRequestUrlStrByUrlComponent:dict[@"newsSpicture"]];
        self.newsNameStr = [dict objectForKey:@"newsTitle"];
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
        self.newsShareurlStr = [dict safeObjectForKey:@"newsShareurl"];
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

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.newsTypeNameStr forKey:@"newsTypeNameStr"];
    [aCoder encodeObject:@(self.newsTypeId) forKey:@"newsTypeId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init])
    {
        self.newsTypeNameStr = [aDecoder decodeObjectForKey:@"newsTypeNameStr"];
        self.newsTypeId = [[aDecoder decodeObjectForKey:@"newsTypeId"] integerValue];
    }
    return self;
}

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
        self.videoLongTimeStr = [dict safeObjectForKey:@"newsVideotimes"];
        self.newsShareurlStr = [dict safeObjectForKey:@"newsShareurl"];
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
        self.newsShareurlStr = [dict safeObjectForKey:@"newsShareurl"];
        
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

///////////////////////////////////////////////////////////////

@implementation CommentEntity

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

@implementation MyMessageEntity

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

@implementation UserEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.userId = [[dict safeObjectForKey:@"userId"] integerValue];
        self.userHeaderImageUrlStr = [UrlManager getImageRequestUrlStrByUrlComponent:[dict safeObjectForKey:@"userPhoto"]];
        self.userNameStr = [dict safeObjectForKey:@"userName"];
        self.userPasswordStr = [dict safeObjectForKey:@"userPassword"];
        self.userMobilePhoneStr = [dict safeObjectForKey:@"userPhone"];
        self.gender = [[dict safeObjectForKey:@"userSex"] integerValue];
        self.genderStr = [dict safeObjectForKey:@"userSexString"];
        self.isVerificationPhoneNum = [dict safeObjectForKey:@"userVerification"];
    }
    return self;
}

@end
