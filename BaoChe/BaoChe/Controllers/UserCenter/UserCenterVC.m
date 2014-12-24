//
//  UserCenterVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "UserCenterVC.h"
#import "PassengersCell.h"
#import "AddressCell.h"
#import "UserCenter_TabHeaderView.h"

static NSString * const cellIdentifier_userInfoHeader = @"cellIdentifier_userInfoHeader";
static NSString * const cellIdentifier_userCenterPassengersCell = @"cellIdentifier_userCenterPassengersCell";
static NSString * const cellIdentifier_userCenterAddressCell = @"cellIdentifier_userCenterAddressCell";

@interface UserCenterVC ()
{
    UserCenter_TabSectionHeaderView    *_passengersCellSectionHeader;
    UserCenter_TabSectionHeaderView    *_addressCellSectionHeader;
}

@end

@implementation UserCenterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"个人中心"];
}

- (void)setNetworkRequestStatusBlocks
{
    /*
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetBusRequestType_GetAllBusList == request.tag)
        {
            
        }
    }];
     */
}

- (void)getNetworkData
{
    /*
    [self sendRequest:[[self class] getRequestURLStr:NetBusRequestType_GetAllBusList]
         parameterDic:nil
           requestTag:NetBusRequestType_GetAllBusList];
     */
}

- (void)initialization
{
    // tab
    _tableView = InsertTableView(nil, self.view.bounds, self, self, UITableViewStylePlain);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PassengersCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier_userCenterPassengersCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier_userCenterAddressCell];
    
    [self.view addSubview:_tableView];
}

- (void)curIndexTabCellShowData:(NSInteger)index
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return [UserCenter_TabHeaderView getViewHeight];
    }
    else if (1 == indexPath.section)
    {
        return [PassengersCell getCellHeight];
    }
    else if (2 == indexPath.section)
    {
        return [AddressCell getCellHeight];
    }
    else if (3 == indexPath.section)
    {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 != section)
    {
        if (3 == section)
        {
            return CellSeparatorSpace;
        }
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section || 3 == section)
    {
        return CellSeparatorSpace;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        if (!_passengersCellSectionHeader)
        {
            _passengersCellSectionHeader = [UserCenter_TabSectionHeaderView loadFromNib];
            [_passengersCellSectionHeader setTitleString:@"常用乘车人"];
            _passengersCellSectionHeader.tag = section;
            [_passengersCellSectionHeader addTarget:self
                                             action:@selector(headerClicked:)
                                   forControlEvents:UIControlEventTouchUpInside];
        }
        return _passengersCellSectionHeader;
    }
    else if (2 == section)
    {
        if (!_addressCellSectionHeader)
        {
            _addressCellSectionHeader = [UserCenter_TabSectionHeaderView loadFromNib];
            [_addressCellSectionHeader setTitleString:@"常用收货地址"];
            _addressCellSectionHeader.tag = section;
            [_addressCellSectionHeader addTarget:self
                                             action:@selector(headerClicked:)
                                   forControlEvents:UIControlEventTouchUpInside];
        }
        return _addressCellSectionHeader;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_userInfoHeader];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_userInfoHeader];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UserCenter_TabHeaderView *headerView = [UserCenter_TabHeaderView loadFromNib];
            headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:headerView];
        }
        return cell;
    }
    else if (1 == indexPath.section)
    {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_userCenterPassengersCell];
        return cell;

    }
    else if (2 == indexPath.section)
    {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_userCenterAddressCell];
        return cell;
    }
    else if (3 == indexPath.section)
    {
        static NSString *cellIdentifier_logout = @"cellIdentifier_logout";
        
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_logout];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_logout];
            
            CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
            [cell addLineWithPosition:ViewDrawLinePostionType_Top
                            lineColor:CellSeparatorColor
                            lineWidth:LineWidth];
            [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                            lineColor:CellSeparatorColor
                            lineWidth:LineWidth];
            
            InsertLabel(cell,
                        CGRectMake(0, 0, cellSize.width, cellSize.height),
                        NSTextAlignmentCenter,
                        @"退出登录",
                        SP15Font,
                        HEXCOLOR(0XF7981C),
                        NO);
        }
        return cell;
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////

-(void)headerClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
    if (0 == section || 3 == section)
    {
        return 1;
    }
    else if (1 == section)
    {
        if (_passengersCellSectionHeader.selected)
        {
            return 5;
        }
    }
    else if (2 == section)
    {
        if (_addressCellSectionHeader.selected)
        {
            return 8;
        }
    }
    return 0;
}

@end
