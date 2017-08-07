//
//  RTComponentTableView.m
//  Pods
//
//  Created by ricky on 16/6/18.
//
//

#import "RTComponentController.h"

#import "RTBaseComponent.h"

@interface RTComponentController ()

@end

@implementation RTComponentController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewRectForBounds:self.view.bounds];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        [self setupTableViewWithFrame:self.view.bounds
                                style:UITableViewStylePlain
                      registerNibName:nil
                      reuseIdentifier:nil];
        _tableView.dk_backgroundColorPicker = DKColorWithColors(PageBackgroundColor, PageBackgroundColor_Night);
        
        /* @龚俊慧
         * @用self sizing cell方式时不能实现heightForRowAtIndexPath方法
        if (IOS8) {
            
            _tableView.estimatedRowHeight = 70;
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }
         */
    }
    return _tableView;
}

#pragma mark - Methods

- (void)setComponents:(NSArray<id<RTTableComponent>> *)components
{
    if (_components != components) {
        _components = components;
        
        for (id<RTTableComponent> component in components) {
            component.sectionOfTableView = [components indexOfObject:component];
        }
        
        [self.tableView reloadData];
    }
}

- (CGRect)tableViewRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (void)setNetworkRequestStatusBlocks {
    
}

- (void)getNetworkData {
    
}

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.components.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.components[section].numberOfItems;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.components[section].heightForComponentHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.components[section].heightForComponentFooter;
}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return self.components[section].estimatedHeightForComponentHeader;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.components[indexPath.section] heightForComponentItemWithTableView:tableView atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.components[indexPath.section] estimatedHeightForComponentItemWithTableView:tableView atIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.components[section] headerForTableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.components[section] footerForTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.components[indexPath.section] cellForTableView:tableView atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if ([self.components[section] respondsToSelector:@selector(willDisplayHeader:)]) {
        [self.components[section] willDisplayHeader:view];
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.components[indexPath.section] respondsToSelector:@selector(willDisplayCell:forIndexPath:)]) {
        [self.components[indexPath.section] willDisplayCell:cell
                                               forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.components[indexPath.section] respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.components[indexPath.section] didSelectItemAtIndex:indexPath.row];
    }
}

@end
