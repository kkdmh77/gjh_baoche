//
//  AllBusListVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/13.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AllBusListVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface AllBusListVC ()

@end

@implementation AllBusListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetBusRequestType_GetAllBusList == request.tag)
        {
            
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetBusRequestType_GetAllBusList]
         parameterDic:nil
           requestTag:NetBusRequestType_GetAllBusList];
}

@end
