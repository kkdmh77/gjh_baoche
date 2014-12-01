//
//  MainPageSecondNewsVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MainPageSecondNewsListVC.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MainPageSecondNewsListVC ()

- (void)refreshNewList;
- (void)setisNeedLoadNextNo;

@end

@implementation MainPageSecondNewsListVC
@synthesize lblTitle;
@synthesize newsTableView;
@synthesize newsCell;
@synthesize delegate;

- (void)dealloc {
    [_lblAds release];
    [newsArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isNeedLoadNext = YES;
    _isCancelLoad = NO;
    _isAdsMoving = NO;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    
    NSMutableDictionary *newsTypeDataDic = [[[ZSSourceModel defaultSource] newsTypeDataDic] retain];
    NSDictionary *responseDic = [newsTypeDataDic objectForKey:@"response"];
    [newsTypeDataDic release];
    int count = [[responseDic objectForKey:@"count"] intValue];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    for (int i = 0; i < count; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        if ([[itemDic objectForKey:@"newstype_id"] intValue] == nowNewStyle) {
            [lblTitle setText:[itemDic objectForKey:@"newstype_name"]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewList) name:notification_getNewsList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setisNeedLoadNextNo) name:notification_getNewsList_None object:nil];
}

#pragma mark - Public
- (void)adsShowBegin {
    if (_isCancelLoad == YES) {
        _isCancelLoad = NO;
    }
}

- (void)loadNewsList:(NSInteger)typeId {
    nowNewStyle = typeId;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getNewsList forKey:Web_Key_urlString];
    [dic setObject:[NSString stringWithFormat:@"%i", typeId] forKey:Key_News_List_Id_Number];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

#pragma mark - xib function

- (IBAction)clickBack:(id)sender {
    _isCancelLoad  = YES;
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGoBack)]) {
        [delegate MainPageSecondNewsListGoBack];
    }
}

#pragma mark - Private
- (void)setisNeedLoadNextNo {
    isNeedLoadNext = NO;
}

- (void)refreshNewList {
    NSDictionary *allListDic = [[[ZSSourceModel defaultSource] newsListDataDic] retain];
    NSArray *itemArray = [allListDic objectForKey:[NSString stringWithFormat:@"%i",nowNewStyle]];
    [allListDic release];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:itemArray];
    }
    [newsArray removeAllObjects];
    [newsArray addObjectsFromArray:itemArray];
    [newsTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListSetNewsInfoArray:)]) {
        [delegate MainPageSecondNewsListSetNewsInfoArray:newsArray];
    }
    
    NSDictionary *itemDic = [newsArray objectAtIndex:indexPath.section];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MainPageSecondNewsListGotoNewDetail:)]) {
        [delegate MainPageSecondNewsListGotoNewDetail:itemId];
    }
    _isCancelLoad = YES;
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
    UIImage *image = nil;
    NSString *urlString = [itemDic objectForKey:@"newIcon"];
    if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"list_default"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.section];
        }
    }
    else {
        image = [UIImage imageNamed:@"list_default"];
    }
    [cell.newsImageView setImage:image];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [newsTableView reloadData];
}

#pragma mark - MainPageNewInfoDetailDelegate
- (void)MainPageNewInfoDetailGoBack {
    if (delegate && [delegate respondsToSelector:@selector(MainPageInfoDetailBack)]) {
        [delegate MainPageInfoDetailBack];
    }
    if (self.newsTableView && [self.newsTableView retainCount]) {
        NSIndexPath *indexPath = [newsTableView indexPathForSelectedRow];
        [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self adsShowBegin];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    if (isNeedLoadNext) {
        if (point.y + 357 > size.height) {
            [self loadNewsList:nowNewStyle];
        }
    }
}

@end
