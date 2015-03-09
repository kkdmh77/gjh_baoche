//
//  EndStationChooseVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/4.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "EndStationChooseVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"
#import "BuyTicketVC.h"
#include <objc/runtime.h>

@interface EndStationChooseVC ()
{
    NSMutableArray *_netEndStationEntityArray;
}

@end

@implementation EndStationChooseVC

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
    [self setNavigationItemTitle:@"选择目的地点"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetBusRequestType_GetAllEndStationList == request.tag)
        {
            [strongSelf parseNetworkDataWithSourceDic:successInfoObj];
            [strongSelf initialization];
        }
    }];
}

- (void)getNetworkData
{
    /*
     @param StartLocation 开始地点
     */
    if (_startStationId)
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@/%d/destination",[[self class] getRequestURLStr:NetBusRequestType_GetAllEndStationList],_startStationId];
        
        [self sendRequest:urlStr
             parameterDic:nil
        requestMethodType:RequestMethodType_GET
               requestTag:NetBusRequestType_GetAllEndStationList];
    }
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)parseNetworkDataWithSourceDic:(NSDictionary *)dic
{
    NSArray *dataList = [dic safeObjectForKey:@"destinations"];
    _netEndStationEntityArray = [NSMutableArray arrayWithCapacity:dataList.count];
    
    for (NSDictionary *dataDic in dataList)
    {
        EndStationEntity *entity = [EndStationEntity initWithDict:dataDic];
        
        [_netEndStationEntityArray addObject:entity];
    }
}

- (EndStationEntity *)curDataWithIndex:(NSInteger)index
{
    return index < _netEndStationEntityArray.count ? _netEndStationEntityArray[index] : nil;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netEndStationEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = SP14Font;
        cell.textLabel.textColor = Common_BlackColor;
    }
    
    EndStationEntity *entity = [self curDataWithIndex:indexPath.row];
    
    cell.textLabel.text = entity.stationNameStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EndStationEntity *entity = [self curDataWithIndex:indexPath.row];
    
    BuyTicketVC *buyTicket = objc_getAssociatedObject(self, class_getName([BuyTicketVC class]));
    [buyTicket setEndStationEntity:entity];
    
    [self backViewController];
}

@end
