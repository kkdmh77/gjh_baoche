//
//  BaseScrollComponentItemCell.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "BaseScrollComponentItemCell.h"
#import "BaseScrollComponentVC.h"
#import <objc/runtime.h>

@interface BaseScrollComponentItemCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) BaseScrollComponentVC *scrollComponentController;

@end

@implementation BaseScrollComponentItemCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    _tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], PageBackgroundColor_Night);
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)setup
{
    [self configureViewsProperties];
}

- (void)reloadData
{
    self.scrollComponentController = objc_getAssociatedObject(self, kBaseScrollComponentAssociatedKey);
    
    [_tableView reloadData];
    [_tableView scrollToTopAnimated:NO];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_scrollComponentController numberOfRowsInSection:section scrollIndex:self.tag tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_scrollComponentController heightForRowAtIndexPath:indexPath scrollIndex:self.tag tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_scrollComponentController cellForRowAtIndexPath:indexPath scrollIndex:self.tag tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_didSelectRowInTab)
    {
        _didSelectRowInTab(indexPath);
    }
}

@end
