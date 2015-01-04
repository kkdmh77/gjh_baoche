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

@interface EndStationChooseVC ()
{
    NSMutableArray *_netCollegeEntityArray;
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
        if (NetBusRequestType_GetAllStartCollegesList == request.tag)
        {
            [strongSelf parseNetworkDataWithSourceDic:successInfoObj];
            [strongSelf initialization];
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetBusRequestType_GetAllStartCollegesList]
         parameterDic:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetBusRequestType_GetAllStartCollegesList];
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
    NSArray *collegeList = [dic safeObjectForKey:@"list"];
    _netCollegeEntityArray = [NSMutableArray arrayWithCapacity:collegeList.count];
    
    for (NSDictionary *collegeDic in collegeList)
    {
        StartStationCollegeEntity *entity = [StartStationCollegeEntity initWithDict:collegeDic];
        
        [_netCollegeEntityArray addObject:entity];
    }
}

- (StartStationCollegeEntity *)curDataWithIndex:(NSInteger)index
{
    return index < _netCollegeEntityArray.count ? _netCollegeEntityArray[index] : nil;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netCollegeEntityArray.count;
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
    
    StartStationCollegeEntity *entity = [self curDataWithIndex:indexPath.row];
    
    cell.textLabel.text = entity.collegeNameStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
