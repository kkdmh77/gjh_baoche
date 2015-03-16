//
//  AddressManagerVC.m
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PassengerManagerVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"
#import "PassengersCell.h"
#import "InterfaceHUDManager.h"
#import "IQKeyboardManager.h"
#include <objc/runtime.h>
#import "AddPassengersVC.h"
#import "GCDThread.h"

static NSString * const addressRequestUserInfoKey_IndexPath = @"addressRequestUserInfoKey_IndexPath";
static NSString * const cellReusableIdentifier              = @"cellReusableIdentifier";

@interface PassengerManagerVC () <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary                *_networkDataDic;
    
    NSMutableArray              *_networkPassengersEntityArray;
}
@end

@implementation PassengerManagerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _useType = UseType_Edit;
        _defaultSelectedAddressId = NSNotFound;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
    
    // 请求网络数据
    [self getNetworkData];
    /*
    [self getLocalData];
    [_tableView reloadData];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"常用联系人"];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                            barButtonTitle:@"添加联系人"
                                    action:@selector(clickAddOnePassengerBtn:)];
}

/*
// 模拟本地数据
- (void)getLocalData
{
    _networkAddressesEntityArray = [NSMutableArray array];
    for (int i = 0; i < 3; ++i)
    {
        AddressManagerAddressEntity *entity = [[AddressManagerAddressEntity alloc] init];
        entity.userName = [NSString stringWithFormat:@"%@,%d",@"周杰伦",i];
        entity.mobilephone = [NSString stringWithFormat:@"%@,%d",@"1380013800",i];
        entity.provinceAndCity = [NSString stringWithFormat:@"%@,%d",@"广东省珠海市香洲区",i];
        entity.detailAddress = [NSString stringWithFormat:@"%@,%d",@"唐家湾镇清华科技园701室",i];
        entity.zipCode = [NSString stringWithFormat:@"%@,%d",@"519000",i];
        
        [_networkAddressesEntityArray addObject:entity];
    }
}
 */

// 解析数据
- (NSMutableArray *)parseDataFromSourceDic:(NSDictionary *)dic
{
    NSArray *addressesArray = [dic objectForKey:@"passengers"];
    
    if ([addressesArray isAbsoluteValid])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:addressesArray.count];
        
        for (NSDictionary *addressInfoDic in addressesArray)
        {
            PassengersEntity *entity = [PassengersEntity initWithDict:addressInfoDic];
            
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if ([successInfoObj isSafeObject])
        {
            if (NetUserCenterRequestType_GetAllPassenger == request.tag)
            {
                strongSelf->_networkDataDic = (NSDictionary *)successInfoObj;
                strongSelf->_networkPassengersEntityArray = [weakSelf parseDataFromSourceDic:strongSelf->_networkDataDic];
                
                [strongSelf reloadTabData];
            }
            else if (NetUserCenterRequestType_DeletePassenger == request.tag)
            {
                NSIndexPath *indexPath = [request.userInfo objectForKey:addressRequestUserInfoKey_IndexPath];
                
                if (indexPath)
                {
                    // 删除数据&刷新界面
                    [strongSelf->_networkPassengersEntityArray removeObjectAtIndex:indexPath.section];
                    
                    [strongSelf->_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                                          withRowAnimation:UITableViewRowAnimationBottom];
                }
            }
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_GetAllPassenger]
         parameterDic:nil
       requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
    requestMethodType:RequestMethodType_GET
           requestTag:NetUserCenterRequestType_GetAllPassenger];
}

// 设置界面
- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:CGRectInset(self.view.bounds, 0, 0)
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([PassengersCell class])
                  reuseIdentifier:cellReusableIdentifier];
    
    /*
    // 分割线
    [_tableView.tableFooterView addBorderToViewWitBorderColor:Common_LiteGrayColor borderWidth:LineWidth];
     */
}

- (void)reloadTabData
{
    [_tableView reloadData];
}

- (void)clickAddOnePassengerBtn:(UIButton *)sender
{
    [self pushToAddPassengerVCWithPassengerEntity:nil];
}

- (PassengersEntity *)getTabCellShowDataWithArrayIndex:(NSInteger)index
{
    return _networkPassengersEntityArray[index];
}

- (void)pushToAddPassengerVCWithPassengerEntity:(PassengersEntity *)entity
{
    AddPassengersVC *addPassengers = [AddPassengersVC loadFromNib];
    addPassengers.defaultShowEntity = entity;
    
    objc_setAssociatedObject(addPassengers, object_getClassName(self), self, OBJC_ASSOCIATION_ASSIGN);
    
    [self pushViewController:addPassengers];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_networkPassengersEntityArray isAbsoluteValid])
    {
        return _networkPassengersEntityArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PassengersCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellSeparatorSpace / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _networkPassengersEntityArray.count - 1)
    {
        return CellSeparatorSpace / 2;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableIdentifier];
    
    PassengersEntity *entity = [self getTabCellShowDataWithArrayIndex:indexPath.section];

    WEAKSELF
    [cell setOperationHandle:^(PassengersCell *cell, OperationButType type, id sender){
        
        STRONGSELF
        NSIndexPath *indexPath = [strongSelf->_tableView indexPathForCell:cell];
        
        switch (type)
        {
            case OperationButType_Delete:
            {
                  NSString *methodName = [[weakSelf class] getRequestURLStr:NetUserCenterRequestType_DeletePassenger];
                  
                  NSDictionary *userInfo = @{addressRequestUserInfoKey_IndexPath: indexPath};
                  
                  [weakSelf sendRequest:methodName
                           parameterDic:@{}
                         requestHeaders:nil
                      requestMethodType:RequestMethodType_DELETE
                             requestTag:NetUserCenterRequestType_DeletePassenger
                               delegate:self
                               userInfo:userInfo];
            }
                break;
                
            default:
                break;
        }
    }];
    
    // 加载数据
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PassengersEntity *entity = [self getTabCellShowDataWithArrayIndex:indexPath.section];
    
    if (UseType_Selector == _useType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PassengerManagerCellSelectedNotificationKey object:entity];
        
        [self backViewController];
    }
    else
    {
        [self pushToAddPassengerVCWithPassengerEntity:entity];
    }
}

@end
