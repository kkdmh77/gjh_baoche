//
//  HomePageCollectionModel.m
//  Movie
//
//  Created by 龚 俊慧 on 2017/6/4.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "HomePageCollectionModel.h"

@implementation HomePageCollectionSectionModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.itemModelArray = [NSArray modelArrayWithClass:[HomePageCollectionItemModel class]
                                                  json:dic[@"resources"]];
    
    return YES;
}

@end

@implementation HomePageCollectionItemModel

@end
