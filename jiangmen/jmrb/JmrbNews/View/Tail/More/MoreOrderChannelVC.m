//
//  MoreOrderChannelVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreOrderChannelVC.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"

@interface MoreOrderChannelVC ()

- (void)refreshNewsCategory;

@end

@implementation MoreOrderChannelVC
@synthesize orderTableView;
@synthesize newsCatagoryArray;
@synthesize delegate;

#pragma mark - Private
- (void)refreshNewsCategory {
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if (allDic == nil) {
        return;
    }
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
    if (itemArray == nil || [itemArray count] == 0) {
        return;
    }
    [self setNewsCatagoryArray:itemArray];
    
    NSMutableDictionary *orderSequenceDic = [[ZSSourceModel defaultSource] newsOrderSequenceDic];
    [orderSequenceDic removeAllObjects];
    [orderSequenceDic setObject:[NSNumber numberWithInt:[itemArray count]] forKey:More_News_Order_Sequence_Max];
    
    for (int i = 0 ; i < [itemArray count]; i++) {
        NSMutableDictionary *itemDic = [itemArray objectAtIndex:i];
        [itemDic setObject:[NSNumber numberWithInt:i] forKey:Key_More_Order_Sequence_Num];
        [orderSequenceDic setObject:[NSNumber numberWithInt:i] forKey:[itemDic objectForKey:@"newstype_id"]];
    }
    
    [orderTableView reloadData];
}

#pragma mark - System
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isChangeOrder = NO;
}

- (void)dealloc {
    [self setNewsCatagoryArray:nil];
    [_imageQueue prepareRelease];
    [_imageQueue release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [orderTableView setDelegate:self];
    [orderTableView setDataSource:self];   
    [self refreshNewsCategory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsCategory) name:Notification_getNewsType object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([newsCatagoryArray count] > 0) {
        return [newsCatagoryArray count] - 1;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indetifyString = @"OrderCell";
    MoreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifyString];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"MoreOrderCell" owner:self options:nil];
        cell = _moreOrderCell;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *itemDic = [newsCatagoryArray objectAtIndex:indexPath.section + 1];
    UIImage *image = [_imageQueue getImageForURL:[itemDic objectForKey:@"newstype_Icon_Small"]];
    NSInteger newsId = [[itemDic objectForKey:@"newstype_id"] intValue];
    if (!image) {
        image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
        [_imageQueue addOperationToQueueWithURL:[itemDic objectForKey:@"newstype_Icon_Small"] atIndex:indexPath.section];
    }
    
//    if (indexPath.section == 0) {
//        [cell.btnUp setAlpha:0];
//    }
    [cell.btnUp setTag:indexPath.section+1];
    [cell setNewsId:newsId];
    [cell.cellImageView setImage:image];
    [cell.cellLabel setText:[itemDic objectForKey:@"newstyle_OrderName"]];
    return cell;
}

#pragma mark - Xib Function
- (IBAction)clickOrderUp:(id)sender {
    UIButton *btn = (UIButton *) sender;
    _isChangeOrder = YES;
    if (btn.tag == 1) {
        return;
    }
    else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:[newsCatagoryArray objectAtIndex:btn.tag-1]];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:[newsCatagoryArray objectAtIndex:btn.tag]];
        [newsCatagoryArray replaceObjectAtIndex:btn.tag withObject:dic1];
        [newsCatagoryArray replaceObjectAtIndex:btn.tag-1 withObject:dic2];
        [orderTableView reloadData];
    }
    NSMutableDictionary *orderSequenceDic = [[ZSSourceModel defaultSource] newsOrderSequenceDic];
    [orderSequenceDic removeAllObjects];
    [orderSequenceDic setObject:[NSNumber numberWithInt:[newsCatagoryArray count]] forKey:More_News_Order_Sequence_Max];
    for (int i = 0 ; i < [newsCatagoryArray count]; i++) {
        NSMutableDictionary *itemDic = [newsCatagoryArray objectAtIndex:i];
        [itemDic setObject:[NSNumber numberWithInt:i] forKey:Key_More_Order_Sequence_Num];
        [orderSequenceDic setObject:[NSNumber numberWithInt:i] forKey:[itemDic objectForKey:@"newstype_id"]];
    }
}

- (IBAction)clickBack:(id)sender {
    NSMutableDictionary *orderSequenceDic = [[ZSSourceModel defaultSource] newsOrderSequenceDic];
    [orderSequenceDic removeAllObjects];
    [orderSequenceDic setObject:[NSNumber numberWithInt:[newsCatagoryArray count]] forKey:More_News_Order_Sequence_Max];
    for (int i = 0 ; i < [newsCatagoryArray count]; i++) {
        NSMutableDictionary *itemDic = [newsCatagoryArray objectAtIndex:i];
        [itemDic setObject:[NSNumber numberWithInt:i] forKey:Key_More_Order_Sequence_Num];
        [orderSequenceDic setObject:[NSNumber numberWithInt:i] forKey:[itemDic objectForKey:@"newstype_id"]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(MoreDetailGoBack)]) {
        [delegate MoreDetailGoBack];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChangeOrderSequence object:nil];
}

#pragma mark - ImageQueueDelegate 
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:_index];
//    MoreOrderCell *cell = (MoreOrderCell *)[orderTableView cellForRowAtIndexPath:indexPath];
//    [cell.cellImageView setImage:_image];
    [orderTableView reloadData];
}


@end
