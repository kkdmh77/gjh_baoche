//
//  HomePageVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageHeaderView.h"
#import "HomePageTodayHotCell.h"
#import "CycleScrollView.h"

static NSString * const cellIdentifier_homePageItem = @"cellIdentifier_homePageItem";

@interface HomePageVC () <CycleScrollViewDelegate>

@end

@implementation HomePageVC

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
    
}

- (void)setNetworkRequestStatusBlocks
{
    
}

- (void)getNetworkData
{
    
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([HomePageTodayHotCell class])
                  reuseIdentifier:cellIdentifier_homePageItem];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // tab header view
    HomePageHeaderView *headerView = [HomePageHeaderView loadFromNib];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, _tableView.boundsWidth, 120)
                                                         viewContentMode:ViewShowStyle_None
                                                                delegate:self
                                                         imgUrlsStrArray:@[@"http://image16-c.poco.cn/mypoco/myphoto/20141208/14/525813772014120814022804_640.jpg?596x396_120"]
                                                            isAutoScroll:YES
                                                               isCanZoom:NO];
    scrollView.canBeLongPressToSaveImage = NO;
    [headerView.scrollBGView addSubview:scrollView];
    
    _tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource methods

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
    return [HomePageTodayHotCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CellSeparatorSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize cellSize = [tableView rectForHeaderInSection:section].size;
    UIView *bgView = InsertView(nil, CGRectMake(0, 0, cellSize.width, cellSize.height));
    
    InsertLabel(bgView,
                CGRectMake(10, 0, cellSize.width, cellSize.height),
                NSTextAlignmentLeft,
                @"广之旅国际旅行社",
                SP14Font,
                Common_BlackColor,
                NO);
    [bgView addLineWithPosition:ViewDrawLinePostionType_Bottom
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    bgView.backgroundColor = [UIColor whiteColor];

    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageTodayHotCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_homePageItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CycleScrollViewDelegate methods

- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index
{
    
}

@end
