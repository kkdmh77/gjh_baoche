//
//  OrderWriteVC.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/22.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "CommonEntity.h"

@interface OrderWriteVC : BaseNetworkViewController

@property (nonatomic, strong) AllBusListItemEntity *busEntity;
@property (nonatomic, strong) NSMutableArray *passengersItemsArray;

@end
