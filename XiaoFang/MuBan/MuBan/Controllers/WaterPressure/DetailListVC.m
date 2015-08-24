//
//  DetailListVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "DetailListVC.h"
#import "DetailInfoListCell.h"

static NSString * const detailInfoListCellIdentifier = @"detailInfoListCellIdentifier";

@interface DetailListVC ()

@property (weak, nonatomic) IBOutlet UILabel *monitoringStationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monitoringTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UIButton *valueBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation DetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"水压详情列表"];
}

- (void)configureViewsProperties
{
    // 赋值
    if (_entity)
    {
        _monitoringStationsLabel.text = [NSString stringWithFormat:@"监测点：0%ld", _entity.number];
        _monitoringTypeLabel.text = @"监测点类型：室外消防栓";
        _leaderNameLabel.text = [NSString stringWithFormat:@"负责人：%@", _entity.leaderNameStr];
        _leaderPhoneLabel.text = [NSString stringWithFormat:@"负责人电话：%@", _entity.mobilePhoneStr];
        _companyLabel.text = [NSString stringWithFormat:@"消防负责单位：%@", _entity.companyStr];
        _companyPhoneLabel.text = @"消防负责单位电话：0574-88689806";
        _positionLabel.text = [NSString stringWithFormat:@"地址：%@", _entity.companyPositionStr];
    }
    
    // 设置属性
    CGFloat width = (IPHONE_WIDTH - 80) / 2;
    UIColor *BGColor = HEXCOLOR(0XF0F0F0);
    
    [_collectTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    [_noteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    
    [_valueBtn addLineWithPosition:ViewDrawLinePostionType_Right
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    [_collectTimeBtn addLineWithPosition:ViewDrawLinePostionType_Right
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
    
    _valueBtn.backgroundColor = BGColor;
    _collectTimeBtn.backgroundColor = BGColor;
    _noteBtn.backgroundColor = BGColor;
    
    // tab
    [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([DetailInfoListCell class]) bundle:nil] forCellReuseIdentifier:detailInfoListCellIdentifier];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DetailInfoListCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoListCellIdentifier];
    
    [cell loadData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
