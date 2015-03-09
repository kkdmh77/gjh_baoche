//
//  BuyTicketVC.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/27.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "CommonEntity.h"

@interface BuyTicketVC : BaseNetworkViewController

- (void)setStartStationEntity:(StartStationCollegeEntity *)startStaion;
- (void)setEndStationEntity:(EndStationEntity *)endStation;

@end
