//
//  HomePageVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageHeaderView.h"

@interface HomePageVC ()

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
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // tab header view
    HomePageHeaderView *headerView = [HomePageHeaderView loadFromNib];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
