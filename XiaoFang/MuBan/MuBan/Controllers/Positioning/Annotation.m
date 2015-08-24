//
//  Annotation.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (CLLocationCoordinate2D)coordinate
{
    return _entity.coordinate;
}

- (NSString *)title
{
    return _entity.positionStr;
}

@end
