//
//  NewsCollectionEntity.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 15/1/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsCollectionEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * newsId;
@property (nonatomic, retain) NSString * newsImageUrlStr;
@property (nonatomic, retain) NSString * newsTitleStr;
@property (nonatomic, retain) NSNumber * collectTime;

@end
