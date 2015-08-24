//
//  Annotation.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CommonEntity.h"

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, strong) DataEntity *entity;

@end
