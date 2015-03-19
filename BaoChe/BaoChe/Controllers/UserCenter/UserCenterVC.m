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
#import "OrderListVC.h"
#import "LoginVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"
#import "LoginBC.h"
#import "InterfaceHUDManager.h"
#import "PassengerManagerVC.h"

static NSString * const cellIdentifier_userInfoHeader = @"cellIdentifier_userInfoHeader";
static NSString * const cellIdentifier_userCenterPassengersCell = @"cellIdentifier_userCenterPassengersCell";
static NSString * const cellIdentifier_userCenterAddressCell = @"cellIdentifier_userCenterAddressCell";

@interface UserCenterVC ()
{
    UserCenter_TabSectionHeaderView    *_passengersCellSectionHeader;
    UserCenter_TabSectionHeaderView    *_addressCellSectionHeader;
    
    UserCenter_TabHeaderView           *_headerView;
    
    UserEntity                         *_userEntity;
    
    LoginBC                            *_loginBC;
}

@end

@implementation UserCenterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:nil
                            highlightedImg:nil
                                    action:NULL];
    
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNetworkData];
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
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetUserCenterRequestType_GetUserInfo == request.tag)
        {
            strongSelf->_userEntity = [UserEntity initWithDict:[successInfoObj safeObjectForKey:@"userInfo"]];
            
            [strongSelf reloadData];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_GetUserInfo]
         parameterDic:nil
       requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
    requestMethodType:RequestMethodType_GET
           requestTag:NetUserCenterRequestType_GetUserInfo];
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

- (void)reloadData
{
    [_tableView reloadData];
    [self reloadTabHeaderViewData];
}

- (void)reloadTabHeaderViewData
{
    [_headerView loadHeaderViewShowDataWithInfoEntity:_userEntity];
}

- (void)clearAndReloadData
{
    // 清空数据
    _userEntity = nil;
    
    // 刷新界面
    [self reloadData];
}

- (void)curIndexTabCellShowData:(NSInteger)index
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[UserInfoModel getRequestHeader_TokenDic] isAbsoluteValid])
    {
        return 4;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    return [self numberOfRowsInSection:section];
     */
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return [UserCenter_TabHeaderView getViewHeight];
    }
    else if (1 == indexPath.section)
    {
        /*
        return [PassengersCell getCellHeight];
         */
        return 50;
    }
    else if (2 == indexPath.section)
    {
        /*
        return [AddressCell getCellHeight];
         */
        return 50;
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
        return CellSeparatorSpace;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
            cell.clipsToBounds = YES;
            
            _headerView = [UserCenter_TabHeaderView loadFromNib];
            _headerView.viewType = UserCenterHeaderViewType_NotLogin;
            _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            WEAKSELF
            [_headerView setOperationHandle:^(UserCenter_TabHeaderView *view, UserCenterTabHeaderViewOperationType type, id sender) {
                
                if (type == UserCenterTabHeaderViewOperationType_CheckAllOrder)
                {
                    OrderListVC *orderList = [[OrderListVC alloc] init];
                    orderList.hidesBottomBarWhenPushed = YES;
                    [weakSelf pushViewController:orderList];
                }
                else if (type == UserCenterTabHeaderViewOperationType_UserHeaderImageBtn)
                {
                    
                }
                else if (type == UserCenterTabHeaderViewOperationType_LoginAndRegister)
                {
                    LoginVC *login = [LoginVC loadFromNib];
                    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
                    [weakSelf presentViewController:loginNav
                               modalTransitionStyle:UIModalTransitionStyleCoverVertical
                                         completion:nil];
                }
            }];
            [cell addSubview:_headerView];
        }
        return cell;
    }
    else if (1 == indexPath.section)
    {
        static NSString *cellIdentifier = @"cellIdentifier_PassengerManager";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
            InsertLabel(cell,
                        CGRectMake(10, 0, 100, cellSize.height),
                        NSTextAlignmentLeft,
                        @"常用联系人",
                        SP15Font,
                        Common_BlackColor,
                        NO);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou_cell"]];
        }
        
        return cell;
    }
    else if (2 == indexPath.section)
    {
        /*
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_userCenterAddressCell];
        return cell;
         */
        
        static NSString *cellIdentifier = @"cellIdentifier_modifyPassword";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
            InsertLabel(cell,
                        CGRectMake(10, 0, 100, cellSize.height),
                        NSTextAlignmentLeft,
                        @"需改密码",
                        SP15Font,
                        Common_BlackColor,
                        NO);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou_cell"]];
        }
        
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
                        Common_ThemeColor,
                        NO);
        }
        return cell;
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 1:
        {
            PassengerManagerVC *passengerManager = [[PassengerManagerVC alloc] init];
            passengerManager.hidesBottomBarWhenPushed = YES;
            [self pushViewController:passengerManager];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            WEAKSELF
            [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil
                                                             message:@"亲，真的要退出当前登录的账号吗？"
                                                       alertShowType:AlertShowType_warning
                                                         cancelTitle:LocalizedStr(All_Cancel)
                                                         cancelBlock:nil
                                                          otherTitle:LocalizedStr(All_Confirm)
                                                          otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                  STRONGSELF
                  [strongSelf->_loginBC logoutWithSuccessHandle:^(id successInfoObj) {
                      
                      // 清空然后刷新数据
                      [strongSelf clearAndReloadData];
                      
                  } failedHandle:^(NSError *error) {
                      
                  }];
            }];
        }
            break;
            
        default:
            break;
    }
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
        /*
        if (_addressCellSectionHeader.selected)
        {
            return 8;
        }
         */
        return 1;
    }
    return 0;
}

@end
