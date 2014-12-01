//
//  MainPageSecondNewsVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MainPageSecondNewsVC.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MainPageSecondNewsVC ()

- (void)refreshNewList;

@end

@implementation MainPageSecondNewsVC
@synthesize newsTableView;
@synthesize newsCell;
@synthesize delegate;

- (void)dealloc {
    [imageQueue cancelQueue];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewList) name:notification_getNewsList object:nil];
}

- (void)loadNewsList:(NSInteger)typeId {
    nowNewStyle = typeId;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNewsList forKey:Web_Key_urlString];
    [dic setObject:[NSNumber numberWithInt:typeId] forKey:Key_News_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

#pragma mark - Private
- (void)refreshNewList {
    NSDictionary *allListDic = [[[ZSSourceModel defaultSource] newsListDataDic] retain];
    NSDictionary *allDic = [allListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStyle]];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsSetNewsInfoArray:itemArray];
    }
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:itemArray];
    [newsTableView reloadData];
    [allListDic release];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsGotoNewDetail:)]) {
        [delegate MainPageSecondNewsGotoNewDetail:itemId];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indentifyCell = @"cell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyCell];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
    }
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    [cell.newsTitle setText:[itemDic objectForKey:@"newsTitle"]];
    [cell.newsTitle setNumberOfLines:2];
    [cell.newsDetailTitle setText:[itemDic objectForKey:@"news_synopsis"]];
    [cell.newsDetailTitle setNumberOfLines:3];
    UIImage *image = [imageQueue getImageForURL:[itemDic objectForKey:@"newIcon"]];
    if (!image) {
        image = [UIImage imageNamed:@"home_image_loading"];
        [imageQueue addOperationToQueueWithURL:[itemDic objectForKey:@"newIcon"] atIndex:indexPath.section];
    }
    [cell.newsImageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.newsImageView setImage:image];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:_index];
//    UITableViewCell *cell = [newsTableView cellForRowAtIndexPath:indexPath];
//    
//    UIImage *image = [UIImage imageNamed:@"TarBar_arrow_right"];
//    [cell.imageView setImage:image];
}

#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    NSIndexPath *indexPath = [newsTableView indexPathForSelectedRow];
    [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
