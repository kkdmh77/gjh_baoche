//
//  ListVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "ListVC.h"
#import "ImageContant.h"
#import "ZSSourceModel.h"
#import "ZSCommunicateModel.h"

@interface ListVC(private)

- (void)refreshNewsCategory;

@end

@implementation ListVC
@synthesize listTableView;
@synthesize delegate;
@synthesize newsCatagoryArray;

#pragma mark - Private
- (void)refreshNewsCategory {
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if (allDic == nil) {
        return;
    }
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    [self setNewsCatagoryArray:itemArray];
    [listTableView reloadData];
}

#pragma mark - View lifecycle
- (void)dealloc {
    [_secondNewListDic release];
    [_newInfo release];
    [_imageQueue release];
    [self setNewsCatagoryArray:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    _secondNewListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    [_newInfo initFrame];
    _imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [self refreshNewsCategory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsCategory) name:Notification_getNewsType object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsCatagoryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(ListVCHideTarBar:)]) {
        [delegate ListVCHideTarBar:YES];
    }
    
    //不保存列表
    NSInteger item;
    NSDictionary *itemDic = [newsCatagoryArray objectAtIndex:indexPath.section];
    item = [[itemDic objectForKey:@"newstype_id"] intValue];
    
    if (_secondNewsVC) {
        [_secondNewsVC release];
    }
    _secondNewsVC = [[ListSecondNewsListVC alloc] initWithNibName:@"ListSecondNewsListVC" bundle:nil];
    [_secondNewsVC setDelegate:self];
    [_secondNewsVC loadNewsList:item];
    [_newInfo setDelegate:_secondNewsVC];
    [self.navigationController pushViewController:_secondNewsVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indentifyCell = @"ListCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        cell = _listCell;
    }
    UIImage *image = nil;
    NSDictionary *itemDic = [newsCatagoryArray objectAtIndex:indexPath.section];
    image = [_imageQueue getImageForURL:[itemDic objectForKey:@"newstype_Icon_Small"]];
    if (image == nil) {
        image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
        [_imageQueue addOperationToQueueWithURL:[itemDic objectForKey:@"newstype_Icon_Small"] atIndex:indexPath.section];
    }
    [cell.cellLabel setText:[itemDic objectForKey:@"newstyle_OrderName"]];
    [cell.cellImageView setImage:image];
    [cell.cellImageView setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ListSecondNewsListVCDelegate
- (void)MainPageSecondNewsListHideTarBar:(BOOL)isHide {
    if (delegate && [delegate respondsToSelector:@selector(ListVCHideTarBar:)]) {
        [delegate ListVCHideTarBar:isHide];
    }
}

- (void)MainPageSecondNewsListGoBack {
    if (delegate && [delegate respondsToSelector:@selector(ListVCHideTarBar:)]) {
        [delegate ListVCHideTarBar:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [_secondNewsVC release];
    _secondNewsVC = nil;
    NSIndexPath *indexPath = [listTableView indexPathForSelectedRow];
    [listTableView deselectRowAtIndexPath:indexPath animated:YES];
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
}

- (void)MainPageSecondNewsListGotoNewDetail:(NSInteger) itemId {
    if (delegate && [delegate respondsToSelector:@selector(ListVCHideTarBar:)]) {
        [delegate ListVCHideTarBar:YES];
    }
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo initFrame];
    [_newInfo setNewsContent:itemId];
}

- (void)MainPageSecondNewsListSetNewsInfoArray:(NSArray *)secondNewsArray {
    [_newInfo setNewsArray:secondNewsArray];
}

#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:_index];
//    ListCell *cell = (ListCell *)[listTableView cellForRowAtIndexPath:indexPath];
//    [cell.cellImageView setImage:_image];
    [listTableView reloadData];
}

@end
