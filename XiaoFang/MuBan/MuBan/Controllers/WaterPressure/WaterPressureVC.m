//
//  MessageVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WaterPressureVC.h"
#import "CommonEntity.h"
#import "WaterPressureCell.h"
#import "DetailListVC.h"
#import "CityChooseListVC.h"
#import "AppDelegate.h"

static NSString * const WaterPressureCellIdentifier = @"WaterPressureCellIdentifier";

@interface WaterPressureVC ()
{
    NSArray *_tabDataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *numberBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *valueBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *positionBtn;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation WaterPressureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"nav_menu"]
                            highlightedImg:nil
                                    action:NULL];
    
    [self configureLocalData];
    [self setup];
    
    // 进入城市选择页面
    CityChooseListVC *cityChoose = [[CityChooseListVC alloc] init];
    UINavigationController *cityChooseNav = [[UINavigationController alloc] initWithRootViewController:cityChoose];
    [self presentViewController:cityChooseNav modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:self.title];
}

- (void)configureViewsProperties
{
    CGFloat width = (IPHONE_WIDTH - 45 - 50 - 80) / 2;
    UIColor *BGColor = HEXCOLOR(0XF0F0F0);
    
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    [_positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    
    [_numberBtn addLineWithPosition:ViewDrawLinePostionType_Right
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    [_nameBtn addLineWithPosition:ViewDrawLinePostionType_Right
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
    [_valueBtn addLineWithPosition:ViewDrawLinePostionType_Right
                         lineColor:CellSeparatorColor
                         lineWidth:LineWidth];
    [_phoneBtn addLineWithPosition:ViewDrawLinePostionType_Right
                         lineColor:CellSeparatorColor
                         lineWidth:LineWidth];
    
    _numberBtn.backgroundColor = BGColor;
    _nameBtn.backgroundColor = BGColor;
    _valueBtn.backgroundColor = BGColor;
    _phoneBtn.backgroundColor = BGColor;
    _positionBtn.backgroundColor = BGColor;
    
    // tab
    [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([WaterPressureCell class]) bundle:nil] forCellReuseIdentifier:WaterPressureCellIdentifier];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)configureLocalData
{
    /*
    DataEntity *entityOne = [[DataEntity alloc] initWithNumber:@"001" nameStr:@"室外消防栓" position:@"奉化市滕头村内" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityTwo = [[DataEntity alloc] initWithNumber:@"002" nameStr:@"室外消防栓" position:@"奉化市江口民营科技园聚金路" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityThird = [[DataEntity alloc] initWithNumber:@"003" nameStr:@"室外消防栓" position:@"奉化市花鸟市场A区" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityFour = [[DataEntity alloc] initWithNumber:@"004" nameStr:@"室外消防栓" position:@"奉化市东郊开发区瑞峰路" value:0.22 leader:@"赵永军" company:@"奉化大队" mobilePhone:@"13957887266" companyPosition:@"奉化市大成路88号"];
    DataEntity *entityFive = [[DataEntity alloc] initWithNumber:@"005" nameStr:@"室外消防栓" position:@"宁波市通途路与文化路交叉口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entitySix = [[DataEntity alloc] initWithNumber:@"006" nameStr:@"室外消防栓" position:@"宁波市康庄南路120号" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entitySeven = [[DataEntity alloc] initWithNumber:@"007" nameStr:@"室外消防栓" position:@"宁波市庄桥火车站门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityEight = [[DataEntity alloc] initWithNumber:@"008" nameStr:@"室外消防栓" position:@"宁波市海曙区环城西路电视台门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityNice = [[DataEntity alloc] initWithNumber:@"009" nameStr:@"室外消防栓" position:@"宁波市江东南路与道士堰路口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityTen = [[DataEntity alloc] initWithNumber:@"010" nameStr:@"室外消防栓" position:@"宁波市中兴路157号公安局门口" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    DataEntity *entityEleven = [[DataEntity alloc] initWithNumber:@"011" nameStr:@"室外消防栓" position:@"宁波市白鹤新村大门口左边" value:0.22 leader:@"赵永军" company:@"宁波消防支队" mobilePhone:@"13957887266" companyPosition:@"宁波市环城西路208号"];
    
    _tabDataArray = [NSArray arrayWithObjects:entityOne, entityTwo, entityThird, entityFour, entityFive, entitySix, entitySeven, entityEight, entityNice, entityTen, entityEleven, nil];
     */
    
    _tabDataArray = SharedAppDelegate.tabDataArray;
}

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tabDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WaterPressureCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaterPressureCell *cell = [tableView dequeueReusableCellWithIdentifier:WaterPressureCellIdentifier];
    
    DataEntity *entity = _tabDataArray[indexPath.row];
    [cell loadDataWithShowEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailListVC *detailList = [DetailListVC loadFromNib];
    detailList.entity = _tabDataArray[indexPath.row];
    detailList.hidesBottomBarWhenPushed = YES;
    
    [self pushViewController:detailList];
}

@end
